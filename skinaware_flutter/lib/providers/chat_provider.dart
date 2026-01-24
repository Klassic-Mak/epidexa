import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai/ollama_service.dart';

// Ollama service provider
final ollamaServiceProvider = Provider<OllamaService>((ref) {
  return OllamaService(
    baseUrl: 'http://118.70.222.145:11434',
    visionModel: 'rohithbojja/llava-med-v1.6:latest',
    textModel: 'charlestang06/openbiollm:latest',
  );
});

// Chat state
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isInitialized;
  final String? error;
  final String? currentImagePath;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
    this.currentImagePath,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isInitialized,
    String? error,
    String? currentImagePath,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
      currentImagePath: currentImagePath ?? this.currentImagePath,
    );
  }
}

// Chat notifier for managing chat state (Riverpod 3.x style)
class ChatNotifier extends Notifier<ChatState> {
  late OllamaService _ollamaService;

  @override
  ChatState build() {
    _ollamaService = ref.watch(ollamaServiceProvider);
    return const ChatState();
  }

  Future<void> initialize() async {
    if (state.isInitialized) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _ollamaService.initialize();
      if (success) {
        state = state.copyWith(
          isInitialized: true,
          isLoading: false,
          messages: [],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error:
              'Unable to connect to AI server. Please check your network connection.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Connection error: $e',
      );
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    if (!state.isInitialized) {
      await initialize();
      if (!state.isInitialized) return;
    }

    // Add user message immediately
    final userMessage = ChatMessage(
      role: 'user',
      content: message,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      String response;

      if (state.currentImagePath != null) {
        // Send with image
        response = await _ollamaService.sendMessageWithImage(
          message,
          state.currentImagePath!,
        );
        // Clear image after sending
        state = state.copyWith(currentImagePath: null);
      } else {
        // Text only
        response = await _ollamaService.sendMessage(message);
      }

      final assistantMessage = ChatMessage(
        role: 'assistant',
        content: response,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error: $e',
      );
    }
  }

  Future<void> sendMessageWithImage(String message, String imagePath) async {
    state = state.copyWith(currentImagePath: imagePath);
    await sendMessage(message);
  }

  Future<AnalysisResult?> analyzeImage({
    required String imagePath,
    String? symptoms,
    String? duration,
    String? previousTreatments,
  }) async {
    if (!state.isInitialized) {
      await initialize();
      if (!state.isInitialized) return null;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _ollamaService.performFullAnalysis(
        imagePath: imagePath,
        symptoms: symptoms,
        duration: duration,
        previousTreatments: previousTreatments,
      );

      // Add analysis to chat history
      final userMessage = ChatMessage(
        role: 'user',
        content: symptoms ?? 'Analyze skin image',
        imageBase64: imagePath,
      );

      final assistantMessage = ChatMessage(
        role: 'assistant',
        content: result.fullResponse,
      );

      state = state.copyWith(
        messages: [...state.messages, userMessage, assistantMessage],
        isLoading: false,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Analysis error: $e',
      );
      return null;
    }
  }

  void setCurrentImage(String? imagePath) {
    state = state.copyWith(currentImagePath: imagePath);
  }

  void clearChat() {
    _ollamaService.clearHistory();
    state = state.copyWith(
      messages: [],
      currentImagePath: null,
      error: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Chat provider
final chatProvider = NotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});

// Analysis state for scan screen
class AnalysisState {
  final bool isAnalyzing;
  final AnalysisResult? result;
  final String? error;
  final List<String> selectedImages;

  const AnalysisState({
    this.isAnalyzing = false,
    this.result,
    this.error,
    this.selectedImages = const [],
  });

  AnalysisState copyWith({
    bool? isAnalyzing,
    AnalysisResult? result,
    String? error,
    List<String>? selectedImages,
  }) {
    return AnalysisState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      result: result ?? this.result,
      error: error,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }
}

class AnalysisNotifier extends Notifier<AnalysisState> {
  late OllamaService _ollamaService;

  @override
  AnalysisState build() {
    _ollamaService = ref.watch(ollamaServiceProvider);
    return const AnalysisState();
  }

  void addImage(String imagePath) {
    state = state.copyWith(
      selectedImages: [...state.selectedImages, imagePath],
    );
  }

  void removeImage(int index) {
    final images = List<String>.from(state.selectedImages);
    images.removeAt(index);
    state = state.copyWith(selectedImages: images);
  }

  void clearImages() {
    state = state.copyWith(selectedImages: [], result: null, error: null);
  }

  Future<AnalysisResult?> analyzeSelectedImages({
    String? symptoms,
    String? duration,
  }) async {
    if (state.selectedImages.isEmpty) {
      state = state.copyWith(error: 'Choose at least one image');
      return null;
    }

    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      // Initialize service if needed
      if (!_ollamaService.isInitialized) {
        await _ollamaService.initialize();
      }

      // Analyze first image (can be extended for multiple images)
      final result = await _ollamaService.performFullAnalysis(
        imagePath: state.selectedImages.first,
        symptoms: symptoms,
        duration: duration,
      );

      state = state.copyWith(
        isAnalyzing: false,
        result: result,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: 'Lỗi phân tích: $e',
      );
      return null;
    }
  }

  void clearResult() {
    state = state.copyWith(result: null, error: null);
  }
}

// Analysis provider for scan screen
final analysisProvider = NotifierProvider<AnalysisNotifier, AnalysisState>(() {
  return AnalysisNotifier();
});
