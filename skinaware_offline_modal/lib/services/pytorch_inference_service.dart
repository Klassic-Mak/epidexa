import 'dart:io';
import 'package:pytorch_lite/pytorch_lite.dart';
import '../config/model_config.dart';
import '../models/prediction_result.dart';

/// Service for running inference using PyTorch Mobile model
/// This replaces TFLite inference with PyTorch TorchScript model
class PyTorchInferenceService {
  ModelObjectDetection? _model;
  bool _isInitialized = false;
  List<String>? _labels;

  /// Initialize PyTorch model
  Future<void> initialize({String? modelPath}) async {
    if (_isInitialized) {
      return;
    }

    try {
      final path = modelPath ?? 'assets/models/skin_disease_model_lite.ptl';
      final labelsPath = 'assets/models/labels.txt';

      print('Loading PyTorch model from: $path');

      // Load model with classification configuration
      _model = await PytorchLite.loadClassificationModel(
        path,
        224, // image width
        224, // image height
        labelPath: labelsPath,
      );

      // Load labels separately for better control
      _labels = await _loadLabels(labelsPath);

      _isInitialized = true;
      print('✓ PyTorch model initialized successfully');
      print('  Number of classes: ${_labels?.length ?? 0}');
    } catch (e) {
      print('Error initializing PyTorch model: $e');
      throw Exception('Failed to initialize PyTorch model: $e');
    }
  }

  /// Load labels from file
  Future<List<String>> _loadLabels(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final contents = await file.readAsString();
        return contents.split('\n').where((line) => line.isNotEmpty).toList();
      } else {
        // Fallback to ModelConfig labels if file doesn't exist
        return ModelConfig.diseaseClasses;
      }
    } catch (e) {
      print('Warning: Could not load labels from $path, using default labels');
      return ModelConfig.diseaseClasses;
    }
  }

  /// Run inference on an image
  Future<PredictionResult> predict(String imagePath) async {
    if (!_isInitialized || _model == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }

    try {
      // Read image bytes
      final imageBytes = await File(imagePath).readAsBytes();

      // Run inference
      final result = await _model!.getImagePrediction(
        imageBytes,
        224, // width
        224, // height
      );

      // Parse result
      // pytorch_lite returns a string with format: "label confidence"
      final parts = result.split(' ');
      String predictedLabel = result;
      double confidence = 0.0;

      if (parts.length >= 2) {
        predictedLabel = parts.sublist(0, parts.length - 1).join(' ');
        confidence = double.tryParse(parts.last) ?? 0.0;
      }

      return PredictionResult(
        diseaseClass: predictedLabel,
        confidence: confidence,
        timestamp: DateTime.now(),
        imagePath: imagePath,
      );
    } catch (e) {
      print('Error during prediction: $e');
      throw Exception('Failed to run prediction: $e');
    }
  }

  /// Get top K predictions
  Future<List<Map<String, dynamic>>> predictTopK(
    String imagePath, {
    int k = 3,
  }) async {
    if (!_isInitialized || _model == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }

    try {
      final imageBytes = await File(imagePath).readAsBytes();

      // Get prediction scores for all classes
      final predictions = await _model!.getImagePredictionList(
        imageBytes,
        224,
        224,
        k, // number of top predictions
      );

      // Convert to list of maps
      final results = <Map<String, dynamic>>[];
      for (var i = 0; i < predictions.length && i < k; i++) {
        final pred = predictions[i];
        results.add({
          'class': pred['label'] ?? 'Unknown',
          'confidence': pred['score'] ?? 0.0,
          'index': i,
        });
      }

      return results;
    } catch (e) {
      print('Error during top-K prediction: $e');
      throw Exception('Failed to run top-K prediction: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _model = null;
    _labels = null;
    _isInitialized = false;
  }

  /// Check if model is initialized
  bool get isInitialized => _isInitialized;

  /// Get list of labels
  List<String>? get labels => _labels;
}
