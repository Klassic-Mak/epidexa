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

/// Analysis result from AI
class AnalysisResult {
  final String diagnosis;
  final double confidence;
  final List<String> differentialDiagnosis;
  final String recommendations;
  final String fullResponse;
  final bool requiresUrgentCare;

  AnalysisResult({
    required this.diagnosis,
    required this.confidence,
    required this.differentialDiagnosis,
    required this.recommendations,
    required this.fullResponse,
    this.requiresUrgentCare = false,
  });
}

/// Ollama API Service for LLaVA-Med and OpenBioLLM
class OllamaService {
  final String baseUrl;
  final String visionModel;
  final String textModel;
  final Duration timeout;

  List<ChatMessage> _chatHistory = [];
  bool _isInitialized = false;

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

  /// Analyze image using LLaVA-Med vision model
  Future<String> analyzeImage(String imagePath, {String? customPrompt}) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    final imageBase64 = await _imageToBase64(imagePath);
    final prompt = customPrompt ?? DermatologyPrompts.visionAnalysisPrompt;

    final response = await _sendRequest(
      model: visionModel,
      prompt: prompt,
      images: [imageBase64],
      stream: false,
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
    final prompt = customPrompt ?? DermatologyPrompts.visionAnalysisPrompt;

    final response = await _sendRequest(
      model: visionModel,
      prompt: prompt,
      images: [imageBase64],
      stream: false,
    );

    return response;
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
  Future<String> sendMessageWithImage(String message, String imagePath) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    // First, analyze image with vision model
    final visionAnalysis = await analyzeImage(imagePath);

    // Then, combine with user question for text model
    final combinedPrompt = DermatologyPrompts.getCombinedAnalysisPrompt(
      visionAnalysis,
      message,
    );

    // Add to history with image reference
    final imageBase64 = await _imageToBase64(imagePath);
    _chatHistory.add(
      ChatMessage(
        role: 'user',
        content: message,
        imageBase64: imageBase64,
      ),
    );

    // Send to text model for comprehensive response
    final messages = [
      {'role': 'system', 'content': DermatologyPrompts.systemPrompt},
      {'role': 'user', 'content': combinedPrompt},
    ];

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
  }) async {
    if (!_isInitialized) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    // Step 1: Vision analysis
    final visionResult = await analyzeImage(imagePath);

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
    final messages = [
      {'role': 'system', 'content': DermatologyPrompts.systemPrompt},
      {'role': 'user', 'content': combinedPrompt},
    ];

    final response = await _sendChatRequest(
      model: textModel,
      messages: messages,
      stream: false,
    );

    // Step 4: Parse response into structured result
    return _parseAnalysisResult(response, visionResult);
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

  /// Internal: Send generate request to Ollama
  Future<String> _sendRequest({
    required String model,
    required String prompt,
    List<String>? images,
    bool stream = false,
  }) async {
    final body = <String, dynamic>{
      'model': model,
      'prompt': prompt,
      'stream': stream,
    };

    if (images != null && images.isNotEmpty) {
      body['images'] = images;
    }

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/generate'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] as String;
    } else {
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
    };

    final response = await http
        .post(
          Uri.parse('$baseUrl/api/chat'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message']['content'] as String;
    } else {
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
