#!/usr/bin/env dart

/// Test TFLite model accuracy on test dataset
///
/// Usage: dart test/test_tflite_model.dart

import 'dart:io';
import 'package:path/path.dart' as path;
import '../lib/services/model_inference_service.dart';
import '../lib/services/image_preprocessor.dart';
import '../lib/config/model_config.dart';

class TestResult {
  final String imagePath;
  final String trueLabel;
  final String predictedLabel;
  final double confidence;
  final bool correct;

  TestResult({
    required this.imagePath,
    required this.trueLabel,
    required this.predictedLabel,
    required this.confidence,
    required this.correct,
  });
}

class ModelTester {
  final ModelInferenceService _modelService;
  final String testDatasetPath;
  final String modelPath;

  ModelTester({
    required this.testDatasetPath,
    required this.modelPath,
  }) : _modelService = ModelInferenceService();

  Future<void> initialize() async {
    print('Initializing TFLite model...');
    await _modelService.initialize(modelPath: modelPath);
    print('✓ Model initialized successfully\n');
  }

  Future<List<TestResult>> runTests() async {
    final results = <TestResult>[];
    final testDir = Directory(testDatasetPath);

    if (!await testDir.exists()) {
      throw Exception('Test dataset directory not found: $testDatasetPath');
    }

    print('Loading test dataset from: $testDatasetPath\n');

    int totalImages = 0;
    final classDirs = await testDir.list().where((entity) {
      return entity is Directory && !path.basename(entity.path).startsWith('.');
    }).toList();

    print('Found ${classDirs.length} classes\n');

    for (final classDir in classDirs) {
      final className = path.basename(classDir.path);
      final images = await Directory(classDir.path).list().where((file) {
        final ext = path.extension(file.path).toLowerCase();
        return ext == '.jpg' ||
            ext == '.jpeg' ||
            ext == '.png' ||
            ext == '.bmp';
      }).toList();

      print('Testing class: $className (${images.length} images)');

      for (final imageFile in images) {
        totalImages++;
        final imagePath = imageFile.path;

        try {
          final prediction = await _modelService.predict(imagePath);

          final result = TestResult(
            imagePath: imagePath,
            trueLabel: className,
            predictedLabel: prediction.diseaseClass,
            confidence: prediction.confidence,
            correct: prediction.diseaseClass == className,
          );

          results.add(result);

          if (totalImages % 10 == 0) {
            stdout.write('\rProcessed: $totalImages images');
          }
        } catch (e) {
          print('\nError processing $imagePath: $e');
        }
      }
    }

    print('\n\n✓ Completed testing $totalImages images\n');
    return results;
  }

  void printResults(List<TestResult> results) {
    if (results.isEmpty) {
      print('No test results available');
      return;
    }

    final correctPredictions = results.where((r) => r.correct).length;
    final totalPredictions = results.length;
    final accuracy = (correctPredictions / totalPredictions) * 100;

    print('=' * 60);
    print('TEST RESULTS SUMMARY');
    print('=' * 60);
    print('Total images tested: $totalPredictions');
    print('Correct predictions: $correctPredictions');
    print('Incorrect predictions: ${totalPredictions - correctPredictions}');
    print('Overall Accuracy: ${accuracy.toStringAsFixed(2)}%');
    print('=' * 60);

    // Per-class accuracy
    final classResults = <String, List<TestResult>>{};
    for (final result in results) {
      classResults.putIfAbsent(result.trueLabel, () => []).add(result);
    }

    print('\nPER-CLASS ACCURACY:');
    print('-' * 60);

    final sortedClasses = classResults.keys.toList()..sort();
    for (final className in sortedClasses) {
      final classTestResults = classResults[className]!;
      final classCorrect = classTestResults.where((r) => r.correct).length;
      final classTotal = classTestResults.length;
      final classAccuracy = (classCorrect / classTotal) * 100;

      print(
          '${className.padRight(50)} ${classAccuracy.toStringAsFixed(1)}% ($classCorrect/$classTotal)');
    }

    // Show some misclassifications
    final misclassified = results.where((r) => !r.correct).take(10).toList();
    if (misclassified.isNotEmpty) {
      print('\n' + '=' * 60);
      print('SAMPLE MISCLASSIFICATIONS (first 10):');
      print('=' * 60);
      for (final result in misclassified) {
        print('\nImage: ${path.basename(result.imagePath)}');
        print('  True label: ${result.trueLabel}');
        print('  Predicted: ${result.predictedLabel}');
        print('  Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%');
      }
    }

    // Confidence statistics
    final avgConfidence =
        results.map((r) => r.confidence).reduce((a, b) => a + b) /
            results.length;
    final correctConfidence = results
            .where((r) => r.correct)
            .map((r) => r.confidence)
            .reduce((a, b) => a + b) /
        correctPredictions;
    final incorrectResults = results.where((r) => !r.correct).toList();
    final incorrectConfidence = incorrectResults.isNotEmpty
        ? incorrectResults.map((r) => r.confidence).reduce((a, b) => a + b) /
            incorrectResults.length
        : 0.0;

    print('\n' + '=' * 60);
    print('CONFIDENCE STATISTICS:');
    print('=' * 60);
    print(
        'Average confidence (all): ${(avgConfidence * 100).toStringAsFixed(2)}%');
    print(
        'Average confidence (correct): ${(correctConfidence * 100).toStringAsFixed(2)}%');
    print(
        'Average confidence (incorrect): ${(incorrectConfidence * 100).toStringAsFixed(2)}%');
  }

  void dispose() {
    _modelService.dispose();
  }
}

Future<void> main(List<String> arguments) async {
  // Get script directory
  final scriptDir = Directory.current.path;
  final projectDir = path.dirname(scriptDir);

  // Paths
  final testDatasetPath = arguments.isNotEmpty
      ? arguments[0]
      : path.join(projectDir, 'dataset_test');

  final modelPath = arguments.length > 1
      ? arguments[1]
      : path.join(projectDir, 'models', 'skin_disease_model.tflite');

  print('=' * 60);
  print('TFLite Model Testing');
  print('=' * 60);
  print('Test dataset: $testDatasetPath');
  print('Model path: $modelPath');
  print('=' * 60);
  print('');

  // Check if model exists
  if (!await File(modelPath).exists()) {
    print('ERROR: Model file not found at: $modelPath');
    print('\nPlease ensure you have:');
    print(
        '1. Trained the model using: python python_scripts/train_custom_model.py');
    print(
        '2. Converted to TFLite using: python python_scripts/convert_to_tflite.py');
    exit(1);
  }

  // Check if test dataset exists
  if (!await Directory(testDatasetPath).exists()) {
    print('ERROR: Test dataset not found at: $testDatasetPath');
    print('\nPlease create a test dataset directory with structure:');
    print('dataset_test/');
    print('  ├── class1/');
    print('  │   ├── image1.jpg');
    print('  │   └── image2.jpg');
    print('  ├── class2/');
    print('  │   └── image3.jpg');
    print('  ...');
    exit(1);
  }

  final tester = ModelTester(
    testDatasetPath: testDatasetPath,
    modelPath: modelPath,
  );

  try {
    await tester.initialize();
    final results = await tester.runTests();
    tester.printResults(results);
  } catch (e, stackTrace) {
    print('\nERROR: $e');
    print('Stack trace: $stackTrace');
    exit(1);
  } finally {
    tester.dispose();
  }

  print('\n✓ Testing completed successfully!\n');
}
