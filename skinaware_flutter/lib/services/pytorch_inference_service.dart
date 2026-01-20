import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:image/image.dart' as img;

/// Service for running inference using PyTorch Mobile model
class PyTorchInferenceService {
  ClassificationModel? _model;
  bool _isInitialized = false;
  List<String>? _labels;

  /// Initialize PyTorch model
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      print('Loading PyTorch model...');

      // Load model with classification configuration
      // Don't use labelPath - it causes the plugin to read labels from image bytes
      _model = await PytorchLite.loadClassificationModel(
        'assets/models/skinaware.ptl',
        224, // image width
        224, // image height
      );

      // Load labels separately
      _labels = await _loadLabels();

      _isInitialized = true;
      print('✓ PyTorch model initialized successfully');
      print('  Number of classes: ${_labels?.length ?? 0}');
    } catch (e) {
      print('Error initializing PyTorch model: $e');
      throw Exception('Failed to initialize PyTorch model: $e');
    }
  }

  /// Load labels from file
  Future<List<String>> _loadLabels() async {
    try {
      final labelsString = await rootBundle.loadString(
        'assets/models/labels.txt',
      );
      return labelsString.split('\n').where((line) => line.isNotEmpty).toList();
    } catch (e) {
      print('Warning: Could not load labels, using default');
      return _getDefaultLabels();
    }
  }

  /// Default labels if file not found
  List<String> _getDefaultLabels() {
    return [
      'Acne and Rosacea Photos',
      'Actinic Keratosis Basal Cell Carcinoma and other Malignant Lesions',
      'Atopic Dermatitis Photos',
      'Bullous Disease Photos',
      'Cellulitis Impetigo and other Bacterial Infections',
      'Eczema Photos',
      'Exanthems and Drug Eruptions',
      'Hair Loss Photos Alopecia and other Hair Diseases',
      'Herpes HPV and other STDs Photos',
      'Light Diseases and Disorders of Pigmentation',
      'Lupus and other Connective Tissue diseases',
      'Melanoma Skin Cancer Nevi and Moles',
      'Nail Fungus and other Nail Disease',
      'Poison Ivy Photos and other Contact Dermatitis',
      'Psoriasis pictures Lichen Planus and related diseases',
      'Scabies Lyme Disease and other Infestations and Bites',
      'Seborrheic Keratoses and other Benign Tumors',
      'Systemic Disease',
      'Tinea Ringworm Candidiasis and other Fungal Infections',
      'Urticaria Hives',
      'Vascular Tumors',
      'Vasculitis Photos',
      'Warts Molluscum and other Viral Infections',
    ];
  }

  /// Preprocess image to ensure proper format
  Future<Uint8List> _preprocessImage(String imagePath) async {
    try {
      // Read and decode image
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to 224x224 (model input size)
      final resized = img.copyResize(image, width: 224, height: 224);

      // Encode to JPEG with high quality
      return Uint8List.fromList(img.encodeJpg(resized, quality: 95));
    } catch (e) {
      print('Error preprocessing image: $e');
      rethrow;
    }
  }

  /// Run inference on an image
  Future<Map<String, dynamic>> predict(String imagePath) async {
    if (!_isInitialized || _model == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }

    try {
      // Preprocess image
      final imageBytes = await _preprocessImage(imagePath);

      // Run inference - returns String with format "label score"
      final result = await _model!.getImagePrediction(imageBytes);

      // Parse result string
      String predictedLabel = 'Unknown';
      double confidence = 0.0;

      if (result.isNotEmpty) {
        final parts = result.split(' ');
        if (parts.length >= 2) {
          // Last part is score, rest is label
          confidence = double.tryParse(parts.last) ?? 0.0;
          predictedLabel = parts.sublist(0, parts.length - 1).join(' ');
        } else {
          predictedLabel = result;
        }
      }

      return {
        'diseaseClass': predictedLabel,
        'confidence': confidence,
        'timestamp': DateTime.now().toIso8601String(),
        'imagePath': imagePath,
      };
    } catch (e) {
      print('Error during prediction: $e');
      throw Exception('Failed to run prediction: $e');
    }
  }

  /// Get top K predictions - simplified to use single prediction and return mock top K
  Future<List<Map<String, dynamic>>> predictTopK(
    String imagePath, {
    int k = 3,
  }) async {
    if (!_isInitialized || _model == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }

    try {
      // Get single prediction first
      final mainResult = await predict(imagePath);

      // For now, return just the top prediction
      // pytorch_lite's getImagePredictionList has issues, so we use single prediction
      return [
        {
          'class': mainResult['diseaseClass'],
          'confidence': mainResult['confidence'],
          'index': 0,
        },
      ];
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
