import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:skinaware_client/skinaware_client.dart' as sp;
import 'dermatology_prompts.dart';

class ChatMessage {
  final String role;
  final String content;
  final String? imageBase64;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    this.imageBase64,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
      imageBase64: json['imageBase64'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}

class ImageValidationResult {
  final bool isValid;
  final String message;
  final String? skinAreaDescription;

  ImageValidationResult({
    required this.isValid,
    required this.message,
    this.skinAreaDescription,
  });
}

class AnalysisResult {
  final String diagnosis;
  final double confidence;
  final List<String> differentialDiagnosis;
  final String recommendations;
  final String fullResponse;
  final bool requiresUrgentCare;
  final bool isInvalidImage;

  AnalysisResult({
    required this.diagnosis,
    required this.confidence,
    required this.differentialDiagnosis,
    required this.recommendations,
    required this.fullResponse,
    this.requiresUrgentCare = false,
    this.isInvalidImage = false,
  });

  factory AnalysisResult.invalidImage({bool isVietnamese = false}) {
    final message = isVietnamese
        ? DermatologyPrompts.invalidImageResponseVi
        : DermatologyPrompts.invalidImageResponseEn;

    return AnalysisResult(
      diagnosis: isVietnamese
          ? 'Ảnh không phù hợp để phân tích'
          : 'Image not suitable for analysis',
      confidence: 0.0,
      differentialDiagnosis: const [],
      recommendations: message,
      fullResponse: message,
      requiresUrgentCare: false,
      isInvalidImage: true,
    );
  }

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      diagnosis: (json['diagnosis'] ?? 'Further evaluation needed').toString(),
      confidence: (json['confidence'] is num)
          ? (json['confidence'] as num).toDouble()
          : 0.0,
      differentialDiagnosis: (json['differentialDiagnosis'] is List)
          ? (json['differentialDiagnosis'] as List)
                .map((e) => e.toString())
                .toList()
          : const [],
      recommendations: (json['recommendations'] ?? '').toString(),
      fullResponse: (json['fullResponse'] ?? '').toString(),
      requiresUrgentCare: json['requiresUrgentCare'] == true,
      isInvalidImage: json['isInvalidImage'] == true,
    );
  }
}

class GeminiService {
  final sp.Client client;

  List<ChatMessage> _chatHistory = [];
  bool _isInitialized = false;
  String _userProfileContext = '';

  GeminiService({required this.client});

  void setUserProfile(String profileContext) {
    _userProfileContext = profileContext;

    if (_isInitialized) {
      _chatHistory = [
        ChatMessage(role: 'system', content: _getPersonalizedSystemPrompt()),
      ];
    }
  }

  String _getPersonalizedSystemPrompt() {
    if (_userProfileContext.trim().isEmpty) return _baseSystemPrompt;
    return '$_baseSystemPrompt\n\n$_userProfileContext';
  }

  static const String _baseSystemPrompt = '''
You are **Dr. Epi**, an expert AI dermatology consultant for the **Epidexa** platform. You specialize in skin health analysis, dermatological consultation, and personalized skincare guidance.

## Core Capabilities
- Analyze skin images to identify potential conditions, lesions, and abnormalities
- Assess lesion morphology: shape, color, borders, texture, symmetry
- Provide differential diagnoses based on visual findings and patient history
- Recognize red flag symptoms requiring immediate medical attention
- Explain conditions in clear, accessible language
- Provide evidence-based skincare recommendations

## Communication Style
- **Warm and Professional**: Be friendly yet authoritative
- **Empathetic**: Acknowledge patient concerns and anxieties
- **Clear**: Use simple language, explain medical terms when used
- **Thorough**: Provide comprehensive answers immediately
- **Bilingual**: Respond in the language the patient uses (English or Vietnamese)

## Response Guidelines
1. **Always Provide Value**: Never refuse to help. Even if uncertain, provide general guidance and recommend professional consultation.
2. **Safety First**: Always mention warning signs that require urgent care (rapidly changing moles, signs of skin cancer, severe allergic reactions, signs of infection).
3. **Evidence-Based**: Base recommendations on established dermatological guidelines.
4. **Complete Answers**: Provide comprehensive responses immediately. Don't ask excessive follow-up questions before giving useful information.
5. **Realistic Expectations**: Be honest about limitations of visual-only diagnosis.

## Response Format for Skin Consultations
**Assessment Summary**: Brief overview of observations
**Possible Conditions**: Primary and differential diagnoses
**Recommended Actions**: Immediate care, home treatment, when to see a doctor
**Prevention & Maintenance**: Tips to prevent recurrence

## Medical Context
- You provide educational information, not definitive medical diagnoses
- Visual analysis has limitations without physical examination
- Professional dermatological consultation is recommended for concerning findings
- Emergency symptoms require immediate medical care
''';

  // ---------------------------
  // Initialization
  // ---------------------------
  Future<bool> initialize() async {
    try {
      final ok = await client.gemini.ping();
      _isInitialized = ok;

      if (ok) {
        // Start local history with system message
        _chatHistory = [
          ChatMessage(role: 'system', content: _getPersonalizedSystemPrompt()),
        ];
      }
      return ok;
    } catch (_) {
      _isInitialized = false;
      return false;
    }
  }

  bool get isInitialized => _isInitialized;

  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  void clearHistory() {
    _chatHistory = [
      ChatMessage(role: 'system', content: _getPersonalizedSystemPrompt()),
    ];
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      final success = await initialize();
      if (!success) {
        throw Exception(
          'Failed to initialize Gemini service. Please check your server connection.',
        );
      }
    }
  }

  // ---------------------------
  // Encoding helpers
  // ---------------------------
  Future<String> _imageToBase64(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  String _bytesToBase64(Uint8List bytes) => base64Encode(bytes);

  String _historyToJson(List<ChatMessage> history) {
    // IMPORTANT: endpoint expects list of {role, content}
    final list = history.map((m) => m.toJson()).toList();
    return jsonEncode(list);
  }

  // ---------------------------
  // VALIDATION
  // ---------------------------
  Future<ImageValidationResult> validateImage(String imagePath) async {
    await _ensureInitialized();

    final imageBase64 = await _imageToBase64(imagePath);

    final response = await client.gemini.validateImageBase64(
      imageBase64: imageBase64,
      userProfileContext: _userProfileContext,
    );

    final upper = response.toUpperCase().trim();
    if (upper.startsWith('VALID')) {
      final description = response.contains(':')
          ? response.substring(response.indexOf(':') + 1).trim()
          : 'Skin image detected';

      return ImageValidationResult(
        isValid: true,
        message: 'Image contains skin suitable for analysis',
        skinAreaDescription: description,
      );
    } else {
      final reason = response.contains(':')
          ? response.substring(response.indexOf(':') + 1).trim()
          : 'Image does not contain analyzable skin';

      return ImageValidationResult(
        isValid: false,
        message: reason,
      );
    }
  }

  Future<ImageValidationResult> validateImageBytes(Uint8List imageBytes) async {
    await _ensureInitialized();

    final imageBase64 = _bytesToBase64(imageBytes);

    final response = await client.gemini.validateImageBase64(
      imageBase64: imageBase64,
      userProfileContext: _userProfileContext,
    );

    final upper = response.toUpperCase().trim();
    if (upper.startsWith('VALID')) {
      final description = response.contains(':')
          ? response.substring(response.indexOf(':') + 1).trim()
          : 'Skin image detected';

      return ImageValidationResult(
        isValid: true,
        message: 'Image contains skin suitable for analysis',
        skinAreaDescription: description,
      );
    } else {
      final reason = response.contains(':')
          ? response.substring(response.indexOf(':') + 1).trim()
          : 'Image does not contain analyzable skin';

      return ImageValidationResult(
        isValid: false,
        message: reason,
      );
    }
  }

  // ---------------------------
  // IMAGE ANALYSIS
  // ---------------------------
  Future<String> analyzeImage(
    String imagePath, {
    String? customPrompt,
    bool skipValidation = false,
  }) async {
    await _ensureInitialized();

    final imageBase64 = await _imageToBase64(imagePath);

    final response = await client.gemini.analyzeImageBase64(
      imageBase64: imageBase64,
      prompt: customPrompt,
      skipValidation: skipValidation,
      userProfileContext: _userProfileContext,
    );

    return response;
  }

  Future<String> analyzeImageBytes(
    Uint8List imageBytes, {
    String? customPrompt,
  }) async {
    await _ensureInitialized();

    final imageBase64 = _bytesToBase64(imageBytes);

    final response = await client.gemini.analyzeImageBase64(
      imageBase64: imageBase64,
      prompt: customPrompt,
      skipValidation: true,
      userProfileContext: _userProfileContext,
    );

    return response;
  }

  // ---------------------------
  // CHAT (text)
  // ---------------------------
  Future<String> sendMessage(String message) async {
    await _ensureInitialized();

    _chatHistory.add(ChatMessage(role: 'user', content: message));

    // Pass history excluding any local-only fields
    final historyJson = _historyToJson(_chatHistory);

    final response = await client.gemini.sendMessage(
      message: message,
      historyJson: historyJson,
      userProfileContext: _userProfileContext,
    );

    _chatHistory.add(ChatMessage(role: 'assistant', content: response));
    return response;
  }

  Stream<String> streamMessage(String message) async* {
    await _ensureInitialized();

    _chatHistory.add(ChatMessage(role: 'user', content: message));

    final historyJson = _historyToJson(_chatHistory);
    final full = StringBuffer();

    final stream = client.gemini.streamMessage(
      message: message,
      historyJson: historyJson,
      userProfileContext: _userProfileContext,
    );

    await for (final chunk in stream) {
      full.write(chunk);
      yield chunk;
    }

    _chatHistory.add(ChatMessage(role: 'assistant', content: full.toString()));
  }

  // ---------------------------
  // CHAT (with image)
  // ---------------------------
  Future<String> sendMessageWithImage(
    String message,
    String imagePath, {
    bool isVietnamese = false,
  }) async {
    await _ensureInitialized();

    // Local validation to keep your current behavior consistent
    final validation = await validateImage(imagePath);
    if (!validation.isValid) {
      final invalidResponse = isVietnamese
          ? DermatologyPrompts.invalidImageResponseVi
          : DermatologyPrompts.invalidImageResponseEn;

      _chatHistory.add(ChatMessage(role: 'user', content: message));
      _chatHistory.add(
        ChatMessage(role: 'assistant', content: invalidResponse),
      );
      return invalidResponse;
    }

    final imageBase64 = await _imageToBase64(imagePath);

    // Keep local history consistent (store the base64 if you want)
    _chatHistory.add(
      ChatMessage(role: 'user', content: message, imageBase64: imageBase64),
    );

    // Send server request (server will do its own vision+combine logic)
    final historyJson = _historyToJson(_chatHistory);

    final response = await client.gemini.sendMessageWithImageBase64(
      message: message,
      imageBase64: imageBase64,
      isVietnamese: isVietnamese,
      historyJson: historyJson,
      userProfileContext: _userProfileContext,
    );

    _chatHistory.add(ChatMessage(role: 'assistant', content: response));
    return response;
  }

  // ---------------------------
  // FULL ANALYSIS
  // ---------------------------
  Future<AnalysisResult> performFullAnalysis({
    required String imagePath,
    String? symptoms,
    String? duration,
    String? previousTreatments,
    bool isVietnamese = false,
  }) async {
    await _ensureInitialized();

    // Keep same behavior: validate first
    final validation = await validateImage(imagePath);
    if (!validation.isValid) {
      return AnalysisResult.invalidImage(isVietnamese: isVietnamese);
    }

    final imageBase64 = await _imageToBase64(imagePath);

    final jsonStr = await client.gemini.performFullAnalysisBase64(
      imageBase64: imageBase64,
      symptoms: symptoms,
      duration: duration,
      previousTreatments: previousTreatments,
      isVietnamese: isVietnamese,
      userProfileContext: _userProfileContext,
    );

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AnalysisResult.fromJson(map);
    } catch (_) {
      // Fallback if server returns plain text for any reason
      return AnalysisResult(
        diagnosis: 'Further evaluation needed',
        confidence: 0.0,
        differentialDiagnosis: const [],
        recommendations: jsonStr,
        fullResponse: jsonStr,
        requiresUrgentCare: false,
        isInvalidImage: false,
      );
    }
  }

  // ---------------------------
  // Dispose
  // ---------------------------
  void dispose() {
    _chatHistory.clear();
    _isInitialized = false;
  }
}
