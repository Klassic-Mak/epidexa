import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'disease_guidance.dart';

/// Service for running inference using TFLite MobileNetV3 model for offline skin disease detection
class TfliteInferenceService {
  static const String _modelAssetPath = 'assets/models/mobilenetv3_skin_disease_23classes.tflite';
  static const int _inputSize = 224;
  static const int _numClasses = 23;

  bool _isInitialized = false;
  tfl.Interpreter? _interpreter;
  List<int>? _inputShape;
  List<int>? _outputShape;

  /// Disease class labels (23 classes) - matching the model training labels
  static const List<String> labels = [
    'Acne and Rosacea',
    'Actinic Keratosis and Malignant Lesions',
    'Atopic Dermatitis',
    'Bullous Disease',
    'Cellulitis and Bacterial Infections',
    'Eczema',
    'Exanthems and Drug Eruptions',
    'Hair Loss and Alopecia',
    'Herpes HPV and STDs',
    'Pigmentation Disorders',
    'Lupus and Connective Tissue Diseases',
    'Melanoma and Skin Cancer',
    'Nail Fungus and Nail Disease',
    'Contact Dermatitis',
    'Psoriasis and Lichen Planus',
    'Scabies and Infestations',
    'Seborrheic Keratoses and Benign Tumors',
    'Systemic Disease',
    'Fungal Infections',
    'Urticaria (Hives)',
    'Vascular Tumors',
    'Vasculitis',
    'Warts and Viral Infections',
  ];

  /// Initialize the TFLite model
  Future<void> initialize() async {
    if (_isInitialized && _interpreter != null) return;

    try {
      print('=== TFLite Initialization Started ===');

      // Load model bytes from assets
      final ByteData modelData = await rootBundle.load(_modelAssetPath);
      final Uint8List modelBytes = modelData.buffer.asUint8List(
        modelData.offsetInBytes,
        modelData.lengthInBytes,
      );
      print('Model bytes loaded: ${modelBytes.length} bytes (${(modelBytes.length / 1024 / 1024).toStringAsFixed(2)} MB)');

      // Create interpreter directly from buffer (more reliable than file)
      final options = tfl.InterpreterOptions()..threads = 4;
      _interpreter = tfl.Interpreter.fromBuffer(modelBytes, options: options);

      // Allocate tensors
      _interpreter!.allocateTensors();

      // Get tensor shapes
      _inputShape = _interpreter!.getInputTensor(0).shape;
      _outputShape = _interpreter!.getOutputTensor(0).shape;

      // Get tensor types for debugging
      final inputType = _interpreter!.getInputTensor(0).type;
      final outputType = _interpreter!.getOutputTensor(0).type;

      print('Interpreter created successfully');
      print('Input shape: $_inputShape, type: $inputType');
      print('Output shape: $_outputShape, type: $outputType');

      _isInitialized = true;
      print('=== TFLite Initialization Complete ===');

    } catch (e, stackTrace) {
      print('=== TFLite Initialization FAILED ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      _isInitialized = false;
      _interpreter = null;
      rethrow;
    }
  }

  /// Preprocess image for model input
  Future<List<List<List<List<double>>>>> _preprocessImage(String imagePath) async {
    print('Preprocessing image: $imagePath');

    final imageBytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    print('Original image size: ${image.width}x${image.height}');

    // Resize to 224x224
    final resized = img.copyResize(image, width: _inputSize, height: _inputSize);
    print('Resized to: ${resized.width}x${resized.height}');

    // Create input tensor [1, 224, 224, 3]
    // MobileNetV3 normalization: (pixel / 255.0 - mean) / std
    // ImageNet mean: [0.485, 0.456, 0.406], std: [0.229, 0.224, 0.225]
    const List<double> mean = [0.485, 0.456, 0.406];
    const List<double> std = [0.229, 0.224, 0.225];

    final input = List.generate(
      1, // batch size
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              ((pixel.r / 255.0) - mean[0]) / std[0], // R
              ((pixel.g / 255.0) - mean[1]) / std[1], // G
              ((pixel.b / 255.0) - mean[2]) / std[2], // B
            ];
          },
        ),
      ),
    );

    // Debug: Print sample values from different parts of the image
    final center = input[0][112][112];
    final corner = input[0][0][0];
    final mid = input[0][56][56];
    print('Input tensor created with shape: [1, $_inputSize, $_inputSize, 3]');
    print('Sample normalized values - Center: [${center[0].toStringAsFixed(3)}, ${center[1].toStringAsFixed(3)}, ${center[2].toStringAsFixed(3)}]');
    print('Sample normalized values - Corner: [${corner[0].toStringAsFixed(3)}, ${corner[1].toStringAsFixed(3)}, ${corner[2].toStringAsFixed(3)}]');
    print('Sample normalized values - Mid: [${mid[0].toStringAsFixed(3)}, ${mid[1].toStringAsFixed(3)}, ${mid[2].toStringAsFixed(3)}]');
    return input;
  }

  /// Run softmax on logits to get probabilities
  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(math.max);
    final expValues = logits.map((x) => math.exp(x - maxLogit)).toList();
    final sumExp = expValues.reduce((a, b) => a + b);
    return expValues.map((x) => x / sumExp).toList();
  }

  /// Run inference on an image and get the predicted disease with guidance
  Future<OfflineAnalysisResult> predict(String imagePath) async {
    print('\n=== Starting Prediction ===');
    print('Image path: $imagePath');

    if (!_isInitialized || _interpreter == null) {
      print('Model not initialized, initializing now...');
      await initialize();
    }

    try {
      // Preprocess image
      final input = await _preprocessImage(imagePath);

      // Create output buffer based on output shape
      // The output shape might be [1, 23] or just [23]
      final outputShape = _outputShape ?? [1, _numClasses];
      print('Creating output buffer with shape: $outputShape');

      dynamic output;
      if (outputShape.length == 2) {
        output = List.generate(outputShape[0], (_) => List.filled(outputShape[1], 0.0));
      } else {
        output = List.filled(_numClasses, 0.0);
      }

      // Run inference
      print('Running inference...');
      _interpreter!.run(input, output);
      print('Inference complete');

      // Extract predictions
      List<double> predictions;
      if (output is List<List<double>>) {
        predictions = output[0];
      } else if (output is List<List<dynamic>>) {
        predictions = output[0].map((e) => (e as num).toDouble()).toList();
      } else if (output is List<double>) {
        predictions = output;
      } else {
        print('Output type: ${output.runtimeType}');
        predictions = (output as List).map((e) => (e as num).toDouble()).toList();
      }

      print('Raw output (all ${predictions.length} values): $predictions');

      // Apply softmax if outputs look like logits (not already probabilities)
      final sum = predictions.reduce((a, b) => a + b);
      final minVal = predictions.reduce(math.min);
      final maxVal = predictions.reduce(math.max);
      print('Raw output stats: sum=$sum, min=$minVal, max=$maxVal');

      if (sum.abs() > 2.0 || predictions.any((p) => p < -1 || p > 2)) {
        print('Applying softmax (outputs appear to be logits)');
        predictions = _softmax(predictions);
      }

      // Print all predictions with labels
      print('All predictions after softmax:');
      for (int i = 0; i < predictions.length && i < labels.length; i++) {
        print('  ${labels[i]}: ${(predictions[i] * 100).toStringAsFixed(2)}%');
      }

      // Get top prediction
      int maxIndex = 0;
      double maxProb = predictions[0];
      for (int i = 1; i < predictions.length; i++) {
        if (predictions[i] > maxProb) {
          maxProb = predictions[i];
          maxIndex = i;
        }
      }

      final disease = labels[maxIndex];
      final confidence = maxProb;
      final guidance = DiseaseGuidance.getGuidance(disease);

      print('Top prediction: $disease (${(confidence * 100).toStringAsFixed(1)}%)');
      print('=== Prediction Complete ===\n');

      return OfflineAnalysisResult(
        disease: disease,
        confidence: confidence,
        guidance: guidance,
        allPredictions: _getTopK(predictions, 3),
        imagePath: imagePath,
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      print('=== Prediction FAILED ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get top K predictions
  List<PredictionEntry> _getTopK(List<double> predictions, int k) {
    final indexed = <PredictionEntry>[];
    for (int i = 0; i < predictions.length; i++) {
      indexed.add(PredictionEntry(
        disease: labels[i],
        confidence: predictions[i],
        index: i,
      ));
    }
    indexed.sort((a, b) => b.confidence.compareTo(a.confidence));
    return indexed.take(k).toList();
  }

  /// Check if model is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}

/// Result from offline analysis
class OfflineAnalysisResult {
  final String disease;
  final double confidence;
  final DiseaseGuidanceInfo guidance;
  final List<PredictionEntry> allPredictions;
  final String imagePath;
  final DateTime timestamp;

  const OfflineAnalysisResult({
    required this.disease,
    required this.confidence,
    required this.guidance,
    required this.allPredictions,
    required this.imagePath,
    required this.timestamp,
  });

  /// Convert to the format used by AnalysisResult for UI compatibility
  Map<String, dynamic> toAnalysisResultFormat() {
    return {
      'diagnosis': disease,
      'confidence': confidence,
      'recommendations': guidance.recommendations,
      'requiresUrgentCare': guidance.requiresUrgentCare,
      'description': guidance.description,
      'causes': guidance.causes,
      'symptoms': guidance.symptoms,
      'homeRemedies': guidance.homeRemedies,
      'whenToSeeDoctor': guidance.whenToSeeDoctor,
    };
  }
}

/// Single prediction entry
class PredictionEntry {
  final String disease;
  final double confidence;
  final int index;

  const PredictionEntry({
    required this.disease,
    required this.confidence,
    required this.index,
  });
}
