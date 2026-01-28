import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai/gemini_service.dart';
import 'onboarding_data_provider.dart';

// Gemini service provider (via AIML API)
final geminiServiceProvider = Provider<GeminiService>((ref) {
  final service = GeminiService(
    apiKey: '34bc1a39049b47c7a5f88692895ef25d',
    baseUrl: 'https://api.aimlapi.com/v1/chat/completions',
    model: 'google/gemini-2.5-flash',
  );

  // Load user profile for personalization
  final onboardingData = ref.watch(onboardingDataProvider);
  final profilePrompt = onboardingData.toPersonalizationPrompt();
  if (profilePrompt.isNotEmpty) {
    service.setUserProfile(profilePrompt);
  }

  return service;
});

// Legacy alias for backwards compatibility
final ollamaServiceProvider = geminiServiceProvider;

// TODO: Uncomment when app localization is implemented
// Supported languages enum
// enum AppLanguage {
//   english,
//   vietnamese,
// }

// Language provider - can be updated based on app locale
// final appLanguageProvider = StateProvider<AppLanguage>((ref) {
//   // Default to English, will be updated by app based on locale
//   return AppLanguage.english;
// });

// Helper extension
// extension AppLanguageExtension on AppLanguage {
//   bool get isVietnamese => this == AppLanguage.vietnamese;
//
//   String get code {
//     switch (this) {
//       case AppLanguage.vietnamese:
//         return 'vi';
//       case AppLanguage.english:
//         return 'en';
//     }
//   }
//
//   static AppLanguage fromLocale(String localeCode) {
//     if (localeCode.startsWith('vi')) {
//       return AppLanguage.vietnamese;
//     }
//     return AppLanguage.english;
//   }
// }

// Default language setting (change to true for Vietnamese)
const bool _defaultIsVietnamese = false;

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
  late GeminiService _geminiService;

  @override
  ChatState build() {
    _geminiService = ref.watch(geminiServiceProvider);
    return const ChatState();
  }

  // Get current language setting
  bool get _isVietnamese => _defaultIsVietnamese;

  Future<void> initialize() async {
    if (state.isInitialized) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load user profile for personalization
      await ref.read(onboardingDataProvider.notifier).loadFromPrefs();
      final onboardingData = ref.read(onboardingDataProvider);
      final profilePrompt = onboardingData.toPersonalizationPrompt();
      if (profilePrompt.isNotEmpty) {
        _geminiService.setUserProfile(profilePrompt);
      }

      final success = await _geminiService.initialize();
      if (success) {
        state = state.copyWith(
          isInitialized: true,
          isLoading: false,
          messages: [],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: _isVietnamese
              ? 'Không thể kết nối đến máy chủ AI. Vui lòng kiểm tra kết nối mạng.'
              : 'Unable to connect to AI server. Please check your network connection.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _isVietnamese ? 'Lỗi kết nối: $e' : 'Connection error: $e',
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
        // Send with image (with language preference)
        response = await _geminiService.sendMessageWithImage(
          message,
          state.currentImagePath!,
          isVietnamese: _isVietnamese,
        );
        // Clear image after sending
        state = state.copyWith(currentImagePath: null);
      } else {
        // Text only
        response = await _geminiService.sendMessage(message);
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
        error: _isVietnamese ? 'Lỗi: $e' : 'Error: $e',
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
      final result = await _geminiService.performFullAnalysis(
        imagePath: imagePath,
        symptoms: symptoms,
        duration: duration,
        previousTreatments: previousTreatments,
        isVietnamese: _isVietnamese,
      );

      // Add analysis to chat history
      final userMessage = ChatMessage(
        role: 'user',
        content: symptoms ??
            (_isVietnamese ? 'Phân tích ảnh da' : 'Analyze skin image'),
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
        error: _isVietnamese ? 'Lỗi phân tích: $e' : 'Analysis error: $e',
      );
      return null;
    }
  }

  void setCurrentImage(String? imagePath) {
    state = state.copyWith(currentImagePath: imagePath);
  }

  void clearChat() {
    _geminiService.clearHistory();
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
  late GeminiService _geminiService;

  @override
  AnalysisState build() {
    _geminiService = ref.watch(geminiServiceProvider);
    return const AnalysisState();
  }

  // Get current language setting
  bool get _isVietnamese => _defaultIsVietnamese;

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
      state = state.copyWith(
        error: _isVietnamese
            ? 'Vui lòng chọn ít nhất một ảnh'
            : 'Please choose at least one image',
      );
      return null;
    }

    state = state.copyWith(isAnalyzing: true, error: null);

    try {
      // Initialize service if needed
      if (!_geminiService.isInitialized) {
        await _geminiService.initialize();
      }

      // Analyze first image (can be extended for multiple images)
      final result = await _geminiService.performFullAnalysis(
        imagePath: state.selectedImages.first,
        symptoms: symptoms,
        duration: duration,
        isVietnamese: _isVietnamese,
      );

      state = state.copyWith(
        isAnalyzing: false,
        result: result,
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: _isVietnamese ? 'Lỗi phân tích: $e' : 'Analysis error: $e',
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
