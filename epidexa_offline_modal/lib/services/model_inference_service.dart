import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../config/model_config.dart';
import '../models/prediction_result.dart';
import 'image_preprocessor.dart';

class ModelInferenceService {
  Interpreter? _interpreter;
  bool _isInitialized = false;

  Future<void> initialize({String? modelPath}) async {
    if (_isInitialized) {
      return;
    }

    try {
      final path = modelPath ?? ModelConfig.tfliteModelPath;

      final options = InterpreterOptions()..threads = 4;

      if (Platform.isAndroid) {
        options.addDelegate(XNNPackDelegate());
      }

      if (Platform.isIOS) {
        options.addDelegate(GpuDelegate());
      }

      _interpreter = await Interpreter.fromAsset(path, options: options);

      _isInitialized = true;
      print('Model initialized successfully');
    } catch (e) {
      print('Error initializing model: $e');
      throw Exception('Failed to initialize model: $e');
    }
  }

  Future<PredictionResult> predict(String imagePath) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }

    final isValid = await ImagePreprocessor.validateImage(imagePath);
    if (!isValid) {
      throw Exception('Invalid image file');
    }

    final input = await ImagePreprocessor.preprocessImage(imagePath);

    final output = List.generate(
      1,
      (_) => List<double>.filled(ModelConfig.numClasses, 0.0),
    );

    _interpreter!.run(input, output);

    final probabilities = output[0];

    int maxIndex = 0;
    double maxConfidence = probabilities[0];

    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxConfidence) {
        maxConfidence = probabilities[i];
        maxIndex = i;
      }
    }

    final diseaseClass = ModelConfig.diseaseClasses[maxIndex];

    return PredictionResult(
      diseaseClass: diseaseClass,
      confidence: maxConfidence,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
  }

  Future<List<Map<String, dynamic>>> predictTopK(
    String imagePath, {
    int k = 3,
  }) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Model not initialized. Call initialize() first.');
    }

    final input = await ImagePreprocessor.preprocessImage(imagePath);
    final output = List.generate(
      1,
      (_) => List<double>.filled(ModelConfig.numClasses, 0.0),
    );

    _interpreter!.run(input, output);

    final probabilities = output[0];

    final results = <Map<String, dynamic>>[];
    for (int i = 0; i < probabilities.length; i++) {
      results.add({
        'class': ModelConfig.diseaseClasses[i],
        'confidence': probabilities[i],
        'index': i,
      });
    }

    results.sort(
      (a, b) =>
          (b['confidence'] as double).compareTo(a['confidence'] as double),
    );

    return results.take(k).toList();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;
}
