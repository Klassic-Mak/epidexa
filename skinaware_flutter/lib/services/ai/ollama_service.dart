import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../cloudinary_service.dart';
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
    if (imageBase64 != null) {
      map['images'] = [imageBase64];
    }
    return map;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
      imageBase64: json['images'] != null
          ? (json['images'] as List).first as String
          : null,
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

/// Ollama API Service for LLaVA-Med and OpenBioLLM
class OllamaService {
  final String baseUrl;
  final String visionModel;
  final String textModel;
  final Duration timeout;

  List<ChatMessage> _chatHistory = [];
  bool _isInitialized = false;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  OllamaService({
    this.baseUrl = 'http://118.70.222.145:11434',
    this.visionModel = 'rohithbojja/llava-med-v1.6:latest', // LLaVA-Med v1.6
    this.textModel = 'charlestang06/openbiollm:latest', // OpenBioLLM-Derm
    this.timeout = const Duration(seconds: 120),
  });

  /// Initialize the service and verify connection
  Future<bool> initialize() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/tags'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isInitialized = true;
        // Add system prompt to chat history
        _chatHistory = [
          ChatMessage(
            role: 'system',
            content: DermatologyPrompts.systemPrompt,
          ),
        ];
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to connect to Ollama server: $e');
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
        content: DermatologyPrompts.systemPrompt,
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

    // Upload image to Cloudinary
    final imageUrl = await _cloudinaryService.uploadImage(imagePath);
    print('📸 Cloudinary image URL: $imageUrl');

    // Send to vision model for validation
    final response = await _sendChatRequestWithImage(
      model: visionModel,
      prompt: DermatologyPrompts.imageValidationPrompt,
      imageUrl: imageUrl,
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

  /// Analyze image using LLaVA-Med vision model (with validation)
  Future<String> analyzeImage(
    String imagePath, {
    String? customPrompt,
    bool skipValidation = false,
  }) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    // Upload image to Cloudinary first
    final imageUrl = await _cloudinaryService.uploadImage(imagePath);
    print('📸 Cloudinary image URL: $imageUrl');

    // Validate image first unless skipped
    if (!skipValidation) {
      print('🔍 Validating image before analysis...');
      final validationResponse = await _sendChatRequestWithImage(
        model: visionModel,
        prompt: DermatologyPrompts.imageValidationPrompt,
        imageUrl: imageUrl,
      );

      final upperResponse = validationResponse.toUpperCase().trim();
      if (!upperResponse.startsWith('VALID')) {
        print('❌ Image validation failed');
        return DermatologyPrompts.invalidImageResponseEn;
      }
      print('✅ Image validation passed');
    }

    final prompt = customPrompt ?? DermatologyPrompts.visionAnalysisPrompt;

    final response = await _sendChatRequestWithImage(
      model: visionModel,
      prompt: prompt,
      imageUrl: imageUrl,
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

    // Save bytes to temp file, upload to Cloudinary, then delete temp file
    final tempDir = Directory.systemTemp;
    final tempFile = File(
      '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(imageBytes);

    try {
      final imageUrl = await _cloudinaryService.uploadImage(tempFile.path);
      print('📸 Cloudinary image URL: $imageUrl');
      final prompt = customPrompt ?? DermatologyPrompts.visionAnalysisPrompt;

      final response = await _sendChatRequestWithImage(
        model: visionModel,
        prompt: prompt,
        imageUrl: imageUrl,
      );

      return response;
    } finally {
      // Clean up temp file
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  /// Send text-only message to OpenBioLLM
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

    final response = await _sendChatRequest(
      model: textModel,
      messages: messages,
      stream: false,
    );

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

    // Upload image to Cloudinary
    final imageUrl = await _cloudinaryService.uploadImage(imagePath);
    print('📸 Cloudinary image URL: $imageUrl');

    // Analyze image with vision model using URL
    final visionAnalysis = await _sendChatRequestWithImage(
      model: visionModel,
      prompt: DermatologyPrompts.visionAnalysisPrompt,
      imageUrl: imageUrl,
    );

    // Then, combine with user question for text model
    final combinedPrompt = DermatologyPrompts.getCombinedAnalysisPrompt(
      visionAnalysis,
      message,
    );

    // Add to history with image URL
    _chatHistory.add(
      ChatMessage(
        role: 'user',
        content: message,
        imageBase64: imageUrl, // Store URL instead of base64
      ),
    );

    // Build messages with full chat history for context
    final messages = _chatHistory.map((m) => m.toJson()).toList();

    // Add the combined prompt as the latest user message
    messages.add({
      'role': 'user',
      'content': combinedPrompt,
    });

    final response = await _sendChatRequest(
      model: textModel,
      messages: messages,
      stream: false,
    );

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

    await for (final chunk in _streamChatRequest(
      model: textModel,
      messages: messages,
    )) {
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

    print('🔬 Starting full analysis...');

    // Step 0: Validate image first
    print('🔍 Step 0: Validating image contains skin...');
    final validation = await validateImage(imagePath);

    if (!validation.isValid) {
      print('❌ Image validation failed: ${validation.message}');
      return AnalysisResult.invalidImage(isVietnamese: isVietnamese);
    }
    print('✅ Image validated: ${validation.skinAreaDescription}');

    // Step 1: Vision analysis (skip validation since we already did it)
    print('📷 Step 1: Analyzing image with vision model...');
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
    print('💬 Step 2: Sending to text model for comprehensive analysis...');
    final messages = [
      {'role': 'system', 'content': DermatologyPrompts.systemPrompt},
      {'role': 'user', 'content': combinedPrompt},
    ];

    final response = await _sendChatRequest(
      model: textModel,
      messages: messages,
      stream: false,
    );
    print('✅ Text analysis complete (${response.length} chars)');

    // Step 4: Parse response into structured result
    print('📊 Step 3: Parsing results...');
    final result = _parseAnalysisResult(response, visionResult);
    print('✅ Full analysis complete!');
    return result;
  }

  /// Parse AI response into structured AnalysisResult
  AnalysisResult _parseAnalysisResult(String response, String visionOutput) {
    // Extract key information from response
    // This is a simplified parser - can be enhanced with more sophisticated NLP

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

    // Extract diagnosis (simplified - look for common patterns)
    String diagnosis = 'Further evaluation needed';
    final diagnosisPatterns = [
      RegExp(r'diagnosis[:\s]+([^\.]+)', caseSensitive: false),
      RegExp(r'likely[:\s]+([^\.]+)', caseSensitive: false),
      RegExp(r'condition[:\s]+([^\.]+)', caseSensitive: false),
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
      confidence: 0.75, // Default confidence
      differentialDiagnosis: [],
      recommendations: response,
      fullResponse: response,
      requiresUrgentCare: requiresUrgentCare,
    );
  }

  /// Internal: Send chat request with image URL to Ollama
  Future<String> _sendChatRequestWithImage({
    required String model,
    required String prompt,
    required String imageUrl,
  }) async {
    // Download image from Cloudinary URL and convert to base64
    print('⬇️ Downloading image from Cloudinary: $imageUrl');
    final imageResponse = await http.get(Uri.parse(imageUrl));

    if (imageResponse.statusCode != 200) {
      throw Exception(
        'Failed to download image from Cloudinary: ${imageResponse.statusCode}',
      );
    }

    final imageBase64 = base64Encode(imageResponse.bodyBytes);
    print(
      '✅ Image downloaded and converted to base64 (${imageBase64.length} chars)',
    );

    final body = {
      'model': model,
      'messages': [
        {
          'role': 'user',
          'content': prompt,
          'images': [imageBase64], // Send base64, not URL
        },
      ],
      'stream': false,
    };

    print('🚀 Sending request to Ollama: $baseUrl/api/chat');
    print('📦 Model: $model');

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/chat'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);

    print('✅ Ollama response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['message']['content'] as String;
      print('📝 Response length: ${content.length} characters');
      return content;
    } else {
      print('❌ Ollama API error: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      throw Exception(
        'Ollama API error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Internal: Send chat request to Ollama
  Future<String> _sendChatRequest({
    required String model,
    required List<Map<String, dynamic>> messages,
    bool stream = false,
  }) async {
    final body = {
      'model': model,
      'messages': messages,
      'stream': stream,
      'options': {
        'num_predict': 2048, // Increase max tokens for longer responses
        'temperature': 0.7,
        'top_p': 0.9,
      },
    };

    print('🚀 Sending text request to Ollama: $baseUrl/api/chat');
    print('📦 Model: $model');
    print('📊 Max tokens: 2048');

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/chat'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);

    print('✅ Text model response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['message']['content'] as String;
      print('📝 Text response length: ${content.length} characters');
      return content;
    } else {
      print('❌ Text model error: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
      throw Exception(
        'Ollama API error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Internal: Stream chat request
  Stream<String> _streamChatRequest({
    required String model,
    required List<Map<String, dynamic>> messages,
  }) async* {
    final client = http.Client();

    try {
      final request = http.Request(
        'POST',
        Uri.parse('$baseUrl/api/chat'),
      );
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'model': model,
        'messages': messages,
        'stream': true,
      });

      final streamedResponse = await client.send(request).timeout(timeout);

      await for (final chunk in streamedResponse.stream.transform(
        utf8.decoder,
      )) {
        for (final line in chunk.split('\n')) {
          if (line.trim().isEmpty) continue;
          try {
            final data = jsonDecode(line);
            if (data['message'] != null && data['message']['content'] != null) {
              yield data['message']['content'] as String;
            }
          } catch (_) {
            // Skip malformed JSON lines
          }
        }
      }
    } finally {
      client.close();
    }
  }

  /// Check available models on server
  Future<List<String>> getAvailableModels() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/tags'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = (data['models'] as List)
            .map((m) => m['name'] as String)
            .toList();
        return models;
      }
      return [];
    } catch (e) {
      print('Error fetching models: $e');
      return [];
    }
  }

  /// Dispose resources
  void dispose() {
    _chatHistory.clear();
    _isInitialized = false;
  }
}
