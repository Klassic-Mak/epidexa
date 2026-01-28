import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tflite_inference_service.dart';
import '../services/disease_guidance.dart';
import '../services/ai/ollama_service.dart';

/// Provider for the TFLite inference service
final tfliteServiceProvider = Provider<TfliteInferenceService>((ref) {
  return TfliteInferenceService();
});

/// State for offline analysis
class OfflineAnalysisState {
  final bool isAnalyzing;
  final bool isModelLoaded;
  final OfflineAnalysisResult? result;
  final String? error;
  final List<String> selectedImages;

  const OfflineAnalysisState({
    this.isAnalyzing = false,
    this.isModelLoaded = false,
    this.result,
    this.error,
    this.selectedImages = const [],
  });

  OfflineAnalysisState copyWith({
    bool? isAnalyzing,
    bool? isModelLoaded,
    OfflineAnalysisResult? result,
    String? error,
    List<String>? selectedImages,
  }) {
    return OfflineAnalysisState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      result: result ?? this.result,
      error: error,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }
}

/// Notifier for managing offline analysis
class OfflineAnalysisNotifier extends Notifier<OfflineAnalysisState> {
  late TfliteInferenceService _tfliteService;

  @override
  OfflineAnalysisState build() {
    _tfliteService = ref.watch(tfliteServiceProvider);
    return const OfflineAnalysisState();
  }

  /// Initialize the TFLite model
  Future<bool> initializeModel() async {
    if (state.isModelLoaded) return true;

    try {
      await _tfliteService.initialize();
      state = state.copyWith(isModelLoaded: true, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(
        isModelLoaded: false,
        error: 'Failed to load offline model: $e',
      );
      return false;
    }
  }

  /// Add an image to analyze
  void addImage(String imagePath) {
    state = state.copyWith(
      selectedImages: [...state.selectedImages, imagePath],
    );
  }

  /// Remove an image
  void removeImage(int index) {
    final images = List<String>.from(state.selectedImages);
    images.removeAt(index);
    state = state.copyWith(selectedImages: images);
  }

  /// Clear all selected images
  void clearImages() {
    state = state.copyWith(selectedImages: [], result: null, error: null);
  }

  /// Analyze the selected image offline
  Future<OfflineAnalysisResult?> analyzeImageOffline() async {
    if (state.selectedImages.isEmpty) {
      state = state.copyWith(error: 'Please select an image first');
      return null;
    }

    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      // Initialize model if needed
      if (!state.isModelLoaded) {
        final success = await initializeModel();
        if (!success) {
          state = state.copyWith(
            isAnalyzing: false,
            error: 'Failed to initialize offline model',
          );
          return null;
        }
      }

      // Run prediction on the first image
      final result = await _tfliteService.predict(state.selectedImages.first);

      state = state.copyWith(
        isAnalyzing: false,
        result: result,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: 'Analysis failed: $e',
      );
      return null;
    }
  }

  /// Convert offline result to AnalysisResult format for UI compatibility
  AnalysisResult? toOnlineFormat() {
    if (state.result == null) return null;

    final r = state.result!;
    return AnalysisResult(
      diagnosis: r.disease,
      confidence: r.confidence,
      differentialDiagnosis: r.allPredictions.skip(1).map((p) => p.disease).toList(),
      recommendations: r.guidance.recommendations,
      requiresUrgentCare: r.guidance.requiresUrgentCare,
      fullResponse: _buildFullResponse(r),
      isInvalidImage: false,
    );
  }

  /// Build full response text from offline result
  String _buildFullResponse(OfflineAnalysisResult result) {
    final buffer = StringBuffer();
    buffer.writeln('**Clinical Impression:** ${result.disease}');
    buffer.writeln('**Confidence:** ${(result.confidence * 100).toStringAsFixed(1)}%');
    buffer.writeln();
    buffer.writeln('**Description:**');
    buffer.writeln(result.guidance.description);
    buffer.writeln();
    buffer.writeln('**Common Causes:**');
    for (final cause in result.guidance.causes) {
      buffer.writeln('- $cause');
    }
    buffer.writeln();
    buffer.writeln('**Typical Symptoms:**');
    for (final symptom in result.guidance.symptoms) {
      buffer.writeln('- $symptom');
    }
    buffer.writeln();
    buffer.writeln('**Recommendations:**');
    buffer.writeln(result.guidance.recommendations);
    buffer.writeln();
    buffer.writeln('**Home Remedies:**');
    for (final remedy in result.guidance.homeRemedies) {
      buffer.writeln('- $remedy');
    }
    buffer.writeln();
    buffer.writeln('**When to See a Doctor:**');
    buffer.writeln(result.guidance.whenToSeeDoctor);

    if (result.guidance.requiresUrgentCare) {
      buffer.writeln();
      buffer.writeln('**IMPORTANT:** This condition may require urgent medical attention.');
    }

    return buffer.toString();
  }

  /// Clear the result
  void clearResult() {
    state = state.copyWith(result: null, error: null);
  }

  /// Clear any errors
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Check if offline mode is available (model loaded)
  bool get isOfflineAvailable => state.isModelLoaded;
}

/// Provider for offline analysis
final offlineAnalysisProvider =
    NotifierProvider<OfflineAnalysisNotifier, OfflineAnalysisState>(() {
  return OfflineAnalysisNotifier();
});

/// Notifier for offline mode toggle
class OfflineModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setOfflineMode(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}

/// Provider for checking if offline mode should be used
/// Returns true when network is unavailable or user prefers offline
final useOfflineModeProvider = NotifierProvider<OfflineModeNotifier, bool>(() {
  return OfflineModeNotifier();
});

/// Provider that returns the available disease labels
final diseaseLabelsProvider = Provider<List<String>>((ref) {
  return TfliteInferenceService.labels;
});

/// Provider for getting disease guidance
final diseaseGuidanceProvider = Provider.family<DiseaseGuidanceInfo, String>((ref, disease) {
  return DiseaseGuidance.getGuidance(disease);
});
