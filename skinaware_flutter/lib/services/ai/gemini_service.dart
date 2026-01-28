import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dermatology_prompts.dart';

/// Message model for chat history
class ChatMessage {
  final String role; // 'user', 'assistant', 'system'
  final String content;
  final String? imageBase64;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    this.imageBase64,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'role': role,
      'content': content,
    };
    return map;
  }

  /// Convert to AIML API message format
  Map<String, dynamic> toAIMLFormat({bool includeImage = false}) {
    if (imageBase64 != null && includeImage) {
      return {
        'role': role,
        'content': [
          {
            'type': 'file',
            'file': {
              'filename': 'skin_image.jpg',
              'file_data': 'data:image/jpeg;base64,$imageBase64',
            },
          },
          {
            'type': 'text',
            'text': content,
          },
        ],
      };
    }
    return {
      'role': role,
      'content': content,
    };
  }

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

/// Result of image validation
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

/// Analysis result from AI
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

  /// Factory for invalid image result
  factory AnalysisResult.invalidImage({bool isVietnamese = false}) {
    final message = isVietnamese
        ? DermatologyPrompts.invalidImageResponseVi
        : DermatologyPrompts.invalidImageResponseEn;
    return AnalysisResult(
      diagnosis: isVietnamese
          ? 'Ảnh không phù hợp để phân tích'
          : 'Image not suitable for analysis',
      confidence: 0.0,
      differentialDiagnosis: [],
      recommendations: message,
      fullResponse: message,
      requiresUrgentCare: false,
      isInvalidImage: true,
    );
  }
}

/// Gemini AI Service via AIML API for dermatological analysis
class GeminiService {
  final String apiKey;
  final String baseUrl;
  final String model;
  final Duration timeout;

  List<ChatMessage> _chatHistory = [];
  bool _isInitialized = false;
  String _userProfileContext = '';

  /// Set user profile for personalization
  void setUserProfile(String profileContext) {
    _userProfileContext = profileContext;
    // Reinitialize chat history with updated system prompt
    if (_isInitialized) {
      _chatHistory = [
        ChatMessage(
          role: 'system',
          content: _getPersonalizedSystemPrompt(),
        ),
      ];
    }
  }

  /// Get the personalized system prompt
  String _getPersonalizedSystemPrompt() {
    if (_userProfileContext.isEmpty) {
      return _baseSystemPrompt;
    }
    return '$_baseSystemPrompt\n\n$_userProfileContext';
  }

  /// Base system prompt for the dermatology AI
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

  GeminiService({
    this.apiKey = '34bc1a39049b47c7a5f88692895ef25d',
    this.baseUrl = 'https://api.aimlapi.com/v1/chat/completions',
    this.model = 'google/gemini-2.5-flash',
    this.timeout = const Duration(seconds: 120),
  });

  /// Initialize the service
  Future<bool> initialize() async {
    try {
      // Test the API connection with a simple request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': 'Hello'},
          ],
          'max_tokens': 10,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        _isInitialized = true;
        // Initialize chat history with system prompt
        _chatHistory = [
          ChatMessage(
            role: 'system',
            content: _getPersonalizedSystemPrompt(),
          ),
        ];
        print('✅ Gemini service initialized successfully');
        return true;
      }
      print('❌ Gemini API test failed: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Failed to initialize Gemini service: $e');
      return false;
    }
  }

  /// Check if service is ready
  bool get isInitialized => _isInitialized;

  /// Get chat history
  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  /// Clear chat history (keeps system prompt)
  void clearHistory() {
    _chatHistory = [
      ChatMessage(
        role: 'system',
        content: _getPersonalizedSystemPrompt(),
      ),
    ];
  }

  /// Convert image file to base64
  Future<String> _imageToBase64(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  /// Convert Uint8List to base64
  String _bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  /// Validate if image contains skin suitable for dermatological analysis
  Future<ImageValidationResult> validateImage(String imagePath) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    print('🔍 Validating image for skin content...');

    // Convert image to base64
    final imageBase64 = await _imageToBase64(imagePath);
    print('📸 Image converted to base64 (${imageBase64.length} chars)');

    // Send to Gemini for validation
    final response = await _sendRequestWithImage(
      prompt: DermatologyPrompts.imageValidationPrompt,
      imageBase64: imageBase64,
    );

    print('📝 Validation response: $response');

    // Parse the response
    final upperResponse = response.toUpperCase().trim();
    if (upperResponse.startsWith('VALID')) {
      // Extract description after "VALID:"
      final description = response.contains(':')
          ? response.substring(response.indexOf(':') + 1).trim()
          : 'Skin image detected';
      print('✅ Image validated: $description');
      return ImageValidationResult(
        isValid: true,
        message: 'Image contains skin suitable for analysis',
        skinAreaDescription: description,
      );
    } else {
      // Extract reason after "INVALID:"
      final reason = response.contains(':')
          ? response.substring(response.indexOf(':') + 1).trim()
          : 'Image does not contain analyzable skin';
      print('❌ Image invalid: $reason');
      return ImageValidationResult(
        isValid: false,
        message: reason,
      );
    }
  }

  /// Validate image from bytes
  Future<ImageValidationResult> validateImageBytes(Uint8List imageBytes) async {
    // Save bytes to temp file
    final tempDir = Directory.systemTemp;
    final tempFile = File(
      '${tempDir.path}/validate_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(imageBytes);

    try {
      return await validateImage(tempFile.path);
    } finally {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// Analyze image using Gemini vision model (with validation)
  Future<String> analyzeImage(
    String imagePath, {
    String? customPrompt,
    bool skipValidation = false,
  }) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    final imageBase64 = await _imageToBase64(imagePath);
    print('📸 Image converted to base64 (${imageBase64.length} chars)');

    // Validate image first unless skipped
    if (!skipValidation) {
      print('🔍 Validating image before analysis...');
      final validationResponse = await _sendRequestWithImage(
        prompt: DermatologyPrompts.imageValidationPrompt,
        imageBase64: imageBase64,
      );

      final upperResponse = validationResponse.toUpperCase().trim();
      if (!upperResponse.startsWith('VALID')) {
        print('❌ Image validation failed');
        return DermatologyPrompts.invalidImageResponseEn;
      }
      print('✅ Image validation passed');
    }

    final prompt = customPrompt ?? DermatologyPrompts.visionAnalysisPrompt;

    final response = await _sendRequestWithImage(
      prompt: prompt,
      imageBase64: imageBase64,
    );

    return response;
  }

  /// Analyze image from bytes
  Future<String> analyzeImageBytes(
    Uint8List imageBytes, {
    String? customPrompt,
  }) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    final imageBase64 = _bytesToBase64(imageBytes);
    print('📸 Image converted to base64 (${imageBase64.length} chars)');

    final prompt = customPrompt ?? DermatologyPrompts.visionAnalysisPrompt;

    final response = await _sendRequestWithImage(
      prompt: prompt,
      imageBase64: imageBase64,
    );

    return response;
  }

  /// Send text-only message
  Future<String> sendMessage(String message) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    // Add user message to history
    _chatHistory.add(
      ChatMessage(
        role: 'user',
        content: message,
      ),
    );

    // Build messages for API
    final messages = _chatHistory.map((m) => m.toJson()).toList();

    final response = await _sendChatRequest(messages: messages);

    // Add assistant response to history
    _chatHistory.add(
      ChatMessage(
        role: 'assistant',
        content: response,
      ),
    );

    return response;
  }

  /// Send message with image (combined vision + text analysis)
  Future<String> sendMessageWithImage(
    String message,
    String imagePath, {
    bool isVietnamese = false,
  }) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    // Validate image first
    print('🔍 Validating image before chat analysis...');
    final validation = await validateImage(imagePath);

    if (!validation.isValid) {
      print('❌ Image validation failed: ${validation.message}');
      final invalidResponse = isVietnamese
          ? DermatologyPrompts.invalidImageResponseVi
          : DermatologyPrompts.invalidImageResponseEn;

      // Add to history
      _chatHistory.add(ChatMessage(role: 'user', content: message));
      _chatHistory.add(
        ChatMessage(role: 'assistant', content: invalidResponse),
      );

      return invalidResponse;
    }
    print('✅ Image validated: ${validation.skinAreaDescription}');

    // Convert image to base64
    final imageBase64 = await _imageToBase64(imagePath);
    print('📸 Image converted to base64 (${imageBase64.length} chars)');

    // Analyze image with vision model
    final visionAnalysis = await _sendRequestWithImage(
      prompt: DermatologyPrompts.visionAnalysisPrompt,
      imageBase64: imageBase64,
    );

    // Combine with user question for comprehensive response
    final combinedPrompt = DermatologyPrompts.getCombinedAnalysisPrompt(
      visionAnalysis,
      message,
    );

    // Add to history
    _chatHistory.add(
      ChatMessage(
        role: 'user',
        content: message,
        imageBase64: imageBase64,
      ),
    );

    // Build messages with chat history for context
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': _getPersonalizedSystemPrompt()},
    ];

    // Add previous context (without images to save tokens)
    for (var i = 1; i < _chatHistory.length - 1; i++) {
      messages.add(_chatHistory[i].toJson());
    }

    // Add the combined analysis prompt
    messages.add({
      'role': 'user',
      'content': combinedPrompt,
    });

    final response = await _sendChatRequest(messages: messages);

    // Add response to history
    _chatHistory.add(
      ChatMessage(
        role: 'assistant',
        content: response,
      ),
    );

    return response;
  }

  /// Stream response for real-time display
  Stream<String> streamMessage(String message) async* {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    _chatHistory.add(
      ChatMessage(
        role: 'user',
        content: message,
      ),
    );

    final messages = _chatHistory.map((m) => m.toJson()).toList();

    final fullResponse = StringBuffer();

    await for (final chunk in _streamChatRequest(messages: messages)) {
      fullResponse.write(chunk);
      yield chunk;
    }

    _chatHistory.add(
      ChatMessage(
        role: 'assistant',
        content: fullResponse.toString(),
      ),
    );
  }

  /// Full skin analysis with image and optional symptoms
  Future<AnalysisResult> performFullAnalysis({
    required String imagePath,
    String? symptoms,
    String? duration,
    String? previousTreatments,
    bool isVietnamese = false,
  }) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    print('🔬 Starting full analysis with Gemini...');

    // Step 0: Validate image first
    print('🔍 Step 0: Validating image contains skin...');
    final validation = await validateImage(imagePath);

    if (!validation.isValid) {
      print('❌ Image validation failed: ${validation.message}');
      return AnalysisResult.invalidImage(isVietnamese: isVietnamese);
    }
    print('✅ Image validated: ${validation.skinAreaDescription}');

    // Step 1: Vision analysis (skip validation since we already did it)
    print('📷 Step 1: Analyzing image with Gemini vision...');
    final visionResult = await analyzeImage(imagePath, skipValidation: true);
    print('✅ Vision analysis complete (${visionResult.length} chars)');

    // Step 2: Build comprehensive query
    final queryParts = <String>[];
    queryParts.add(
      'Based on the image analysis, provide a comprehensive assessment.',
    );

    if (symptoms != null && symptoms.isNotEmpty) {
      queryParts.add('Patient-described symptoms: $symptoms');
    }
    if (duration != null && duration.isNotEmpty) {
      queryParts.add('Duration: $duration');
    }
    if (previousTreatments != null && previousTreatments.isNotEmpty) {
      queryParts.add('Treatments tried: $previousTreatments');
    }

    final combinedPrompt = DermatologyPrompts.getCombinedAnalysisPrompt(
      visionResult,
      queryParts.join('\n'),
    );

    // Step 3: Get comprehensive analysis
    print('💬 Step 2: Getting comprehensive analysis from Gemini...');
    final messages = [
      {'role': 'system', 'content': _getPersonalizedSystemPrompt()},
      {'role': 'user', 'content': combinedPrompt},
    ];

    final response = await _sendChatRequest(messages: messages);
    print('✅ Analysis complete (${response.length} chars)');

    // Step 4: Parse response into structured result
    print('📊 Step 3: Parsing results...');
    final result = _parseAnalysisResult(response, visionResult);
    print('✅ Full analysis complete!');
    return result;
  }

  /// Parse AI response into structured AnalysisResult
  AnalysisResult _parseAnalysisResult(String response, String visionOutput) {
    final lowerResponse = response.toLowerCase();

    // Check for urgent care indicators
    final urgentKeywords = [
      'immediately',
      'urgent',
      'emergency',
      'melanoma',
      'cancer',
      'spreading rapidly',
      'severe',
      'critical',
    ];
    final requiresUrgentCare = urgentKeywords.any(
      (k) => lowerResponse.contains(k),
    );

    // Extract diagnosis
    String diagnosis = 'Further evaluation needed';
    final diagnosisPatterns = [
      RegExp(r'diagnosis[:\s]+([^\.]+)', caseSensitive: false),
      RegExp(r'likely[:\s]+([^\.]+)', caseSensitive: false),
      RegExp(r'condition[:\s]+([^\.]+)', caseSensitive: false),
      RegExp(r'consistent with[:\s]+([^\.]+)', caseSensitive: false),
      RegExp(r'appears to be[:\s]+([^\.]+)', caseSensitive: false),
    ];

    for (final pattern in diagnosisPatterns) {
      final match = pattern.firstMatch(response);
      if (match != null) {
        diagnosis = match.group(1)?.trim() ?? diagnosis;
        break;
      }
    }

    return AnalysisResult(
      diagnosis: diagnosis,
      confidence: 0.75,
      differentialDiagnosis: [],
      recommendations: response,
      fullResponse: response,
      requiresUrgentCare: requiresUrgentCare,
    );
  }

  /// Internal: Send request with image to AIML API
  Future<String> _sendRequestWithImage({
    required String prompt,
    required String imageBase64,
  }) async {
    print('🚀 Sending vision request to AIML API...');

    final body = {
      'model': model,
      'messages': [
        {'role': 'system', 'content': _getPersonalizedSystemPrompt()},
        {
          'role': 'user',
          'content': [
            {
              'type': 'file',
              'file': {
                'filename': 'skin_image.jpg',
                'file_data': 'data:image/jpeg;base64,$imageBase64',
              },
            },
            {
              'type': 'text',
              'text': prompt,
            },
          ],
        },
      ],
      'max_tokens': 2048,
      'temperature': 0.7,
    };

    final response = await http
        .post(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(timeout);

    print('✅ AIML API response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      print('📝 Response length: ${content.length} characters');
      return content;
    } else {
      print('❌ AIML API error: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      throw Exception(
        'AIML API error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Internal: Send chat request to AIML API
  Future<String> _sendChatRequest({
    required List<Map<String, dynamic>> messages,
  }) async {
    print('🚀 Sending text request to AIML API...');
    print('📦 Model: $model');

    final body = {
      'model': model,
      'messages': messages,
      'max_tokens': 2048,
      'temperature': 0.7,
    };

    final response = await http
        .post(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(timeout);

    print('✅ AIML API response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      print('📝 Response length: ${content.length} characters');
      return content;
    } else {
      print('❌ AIML API error: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      throw Exception(
        'AIML API error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Internal: Stream chat request
  Stream<String> _streamChatRequest({
    required List<Map<String, dynamic>> messages,
  }) async* {
    final client = http.Client();

    try {
      final request = http.Request('POST', Uri.parse(baseUrl));
      request.headers['Authorization'] = 'Bearer $apiKey';
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'model': model,
        'messages': messages,
        'max_tokens': 2048,
        'temperature': 0.7,
        'stream': true,
      });

      final streamedResponse = await client.send(request).timeout(timeout);

      await for (final chunk in streamedResponse.stream.transform(
        utf8.decoder,
      )) {
        for (final line in chunk.split('\n')) {
          if (line.trim().isEmpty || line.startsWith('data: [DONE]')) continue;
          if (line.startsWith('data: ')) {
            try {
              final data = jsonDecode(line.substring(6));
              final delta = data['choices']?[0]?['delta']?['content'];
              if (delta != null) {
                yield delta as String;
              }
            } catch (_) {
              // Skip malformed JSON lines
            }
          }
        }
      }
    } finally {
      client.close();
    }
  }

  /// Dispose resources
  void dispose() {
    _chatHistory.clear();
    _isInitialized = false;
  }
}
