import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart' as dotenv;

class GeminiEndpoint extends Endpoint {
  static const String _baseUrl = 'https://api.aimlapi.com/v1/chat/completions';
  static const String _model = 'google/gemini-2.5-flash';

  String _systemPrompt(String userProfileContext) {
    const base = '''
You are **Dr. Epi**, an expert AI dermatology consultant for the **Epidexa** platform.

- Be warm, professional, and clear.
- Provide educational info, not definitive diagnosis.
- Mention red flags for urgent care when relevant.
- Respond in English language.
''';
    if (userProfileContext.trim().isEmpty) return base;
    return '$base\n\n$userProfileContext';
  }

  String _apiKeyOrThrow() {
    final key = '34bc1a39049b47c7a5f88692895ef25d';

    if (key == null || key.isEmpty) {
      throw StateError(
        'AIML_API_KEY is missing. '
        'Add it to your server .env file and restart the server.',
      );
    }

    return key;
  }

  Future<Map<String, dynamic>> _post(Map<String, dynamic> body) async {
    final apiKey = _apiKeyOrThrow();

    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 120));

    final text = response.body;

    if (response.statusCode == 200) {
      return jsonDecode(text) as Map<String, dynamic>;
    }

    throw Exception('AIML API error: ${response.statusCode} - $text');
  }

  Future<bool> ping(Session session) async {
    try {
      final data = await _post({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': 'Hello'},
        ],
        'max_tokens': 10,
      });

      return data.isNotEmpty;
    } catch (e) {
      session.log('Gemini ping failed: $e');
      return false;
    }
  }

  String _extractContent(Map<String, dynamic> data) {
    // OpenAI-style response shape (AIML generally mimics this)
    final choices = data['choices'];
    if (choices is List && choices.isNotEmpty) {
      final msg = choices[0]['message'];
      if (msg is Map && msg['content'] is String) {
        return msg['content'] as String;
      }
    }
    return '';
  }

  List<Map<String, dynamic>> _historyFromJson(String? historyJson) {
    if (historyJson == null || historyJson.trim().isEmpty) return [];
    final decoded = jsonDecode(historyJson);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
          .toList();
    }
    return [];
  }

  Map<String, dynamic> _filePart(String imageBase64) {
    return {
      'type': 'file',
      'file': {
        'filename': 'skin_image.jpg',
        'file_data': 'data:image/jpeg;base64,$imageBase64',
      },
    };
  }

  Map<String, dynamic> _textPart(String text) {
    return {'type': 'text', 'text': text};
  }

  /// ------------------------------------------------------------
  /// 2) sendMessage (non-stream)
  /// - historyJson is optional: JSON list of {role, content}
  /// ------------------------------------------------------------
  Future<String> sendMessage(
    Session session, {
    required String message,
    String? historyJson,
    String userProfileContext = '',
  }) async {
    final history = _historyFromJson(historyJson);

    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': _systemPrompt(userProfileContext)},
      ...history,
      {'role': 'user', 'content': message},
    ];

    final data = await _post({
      'model': _model,
      'messages': messages,
      'max_tokens': 2048,
      'temperature': 0.7,
    });

    return _extractContent(data);
  }

  /// ------------------------------------------------------------
  /// 3) streamMessage
  /// ------------------------------------------------------------
  Stream<String> streamMessage(
    Session session, {
    required String message,
    String? historyJson,
    String userProfileContext = '',
  }) async* {
    final apiKey = _apiKeyOrThrow();
    final history = _historyFromJson(historyJson);

    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': _systemPrompt(userProfileContext)},
      ...history,
      {'role': 'user', 'content': message},
    ];

    final request = http.Request('POST', Uri.parse(_baseUrl));
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'model': _model,
      'messages': messages,
      'max_tokens': 2048,
      'temperature': 0.7,
      'stream': true,
    });

    final client = http.Client();
    try {
      final streamed = await client.send(request);

      // AIML streams "data: {json}\n\n" lines similar to OpenAI
      await for (final chunk in streamed.stream.transform(utf8.decoder)) {
        for (final line in chunk.split('\n')) {
          final t = line.trim();
          if (t.isEmpty) continue;
          if (t.startsWith('data: [DONE]')) continue;
          if (!t.startsWith('data: ')) continue;

          final jsonStr = t.substring(6);
          try {
            final data = jsonDecode(jsonStr);
            final delta = data['choices']?[0]?['delta']?['content'];
            if (delta is String && delta.isNotEmpty) {
              yield delta;
            }
          } catch (_) {
            // ignore malformed lines
          }
        }
      }
    } finally {
      client.close();
    }
  }

  /// ------------------------------------------------------------
  /// 4) validateImageBase64
  /// Returns: String starting with "VALID: ..." or "INVALID: ..."
  /// ------------------------------------------------------------
  Future<String> validateImageBase64(
    Session session, {
    required String imageBase64,
    String userProfileContext = '',
  }) async {
    // You can swap this prompt with your DermatologyPrompts.imageValidationPrompt
    const validationPrompt = '''
You will receive an image.
Reply with:
VALID: <short description of skin area>
OR
INVALID: <short reason>
Only output VALID/INVALID line.
''';

    final data = await _post({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': _systemPrompt(userProfileContext)},
        {
          'role': 'user',
          'content': [
            _filePart(imageBase64),
            _textPart(validationPrompt),
          ],
        },
      ],
      'max_tokens': 200,
      'temperature': 0.2,
    });

    return _extractContent(data).trim();
  }

  /// ------------------------------------------------------------
  /// 5) analyzeImageBase64
  /// ------------------------------------------------------------
  Future<String> analyzeImageBase64(
    Session session, {
    required String imageBase64,
    String? prompt,
    bool skipValidation = false,
    String userProfileContext = '',
  }) async {
    if (!skipValidation) {
      final v = await validateImageBase64(
        session,
        imageBase64: imageBase64,
        userProfileContext: userProfileContext,
      );
      if (!v.toUpperCase().startsWith('VALID')) {
        return 'Image not suitable for analysis.';
      }
    }

    final analysisPrompt =
        prompt ??
        '''
Analyze the skin image. Provide:
Assessment Summary
Possible Conditions (primary + differential)
Recommended Actions
Prevention & Maintenance
Include red flags for urgent care.
''';

    final data = await _post({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': _systemPrompt(userProfileContext)},
        {
          'role': 'user',
          'content': [
            _filePart(imageBase64),
            _textPart(analysisPrompt),
          ],
        },
      ],
      'max_tokens': 2048,
      'temperature': 0.7,
    });

    return _extractContent(data);
  }

  /// ------------------------------------------------------------
  /// 6) sendMessageWithImageBase64
  /// - validates image
  /// - runs vision analysis
  /// - combines with message
  /// ------------------------------------------------------------
  Future<String> sendMessageWithImageBase64(
    Session session, {
    required String message,
    required String imageBase64,
    bool isVietnamese = false,
    String? historyJson,
    String userProfileContext = '',
  }) async {
    final validation = await validateImageBase64(
      session,
      imageBase64: imageBase64,
      userProfileContext: userProfileContext,
    );

    if (!validation.toUpperCase().startsWith('VALID')) {
      return 'This image is not suitable for skin analysis. Please take a clear, well-lit photo of the skin area.';
    }

    final vision = await analyzeImageBase64(
      session,
      imageBase64: imageBase64,
      skipValidation: true,
      userProfileContext: userProfileContext,
    );

    final combinedPrompt =
        '''
IMAGE ANALYSIS:
$vision

USER QUESTION:
$message

Now answer the user, using the image analysis. Keep it safe and medical-educational.
''';

    final history = _historyFromJson(historyJson);

    final data = await _post({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': _systemPrompt(userProfileContext)},
        ...history,
        {'role': 'user', 'content': combinedPrompt},
      ],
      'max_tokens': 2048,
      'temperature': 0.7,
    });

    return _extractContent(data);
  }

  /// ------------------------------------------------------------
  /// 7) performFullAnalysisBase64 -> returns JSON string
  /// (so you can parse into your AnalysisResult on Flutter)
  /// ------------------------------------------------------------
  Future<String> performFullAnalysisBase64(
    Session session, {
    required String imageBase64,
    String? symptoms,
    String? duration,
    String? previousTreatments,
    bool isVietnamese = false,
    String userProfileContext = '',
  }) async {
    final validation = await validateImageBase64(
      session,
      imageBase64: imageBase64,
      userProfileContext: userProfileContext,
    );

    if (!validation.toUpperCase().startsWith('VALID')) {
      final msg = 'Image not suitable for analysis';

      return jsonEncode({
        'diagnosis': msg,
        'confidence': 0.0,
        'differentialDiagnosis': <String>[],
        'recommendations': msg,
        'fullResponse': msg,
        'requiresUrgentCare': false,
        'isInvalidImage': true,
      });
    }

    final vision = await analyzeImageBase64(
      session,
      imageBase64: imageBase64,
      skipValidation: true,
      userProfileContext: userProfileContext,
    );

    final parts = <String>[
      'Based on the image analysis, provide a comprehensive assessment.',
      if (symptoms != null && symptoms.trim().isNotEmpty)
        'Patient-described symptoms: $symptoms',
      if (duration != null && duration.trim().isNotEmpty) 'Duration: $duration',
      if (previousTreatments != null && previousTreatments.trim().isNotEmpty)
        'Treatments tried: $previousTreatments',
    ];

    final prompt =
        '''
IMAGE ANALYSIS:
$vision

${parts.join('\n')}

Return:
- Most likely condition (1 line)
- Confidence (0-1)
- Differential diagnoses (list)
- Recommendations (bullets)
- Red flags for urgent care
''';

    final data = await _post({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': _systemPrompt(userProfileContext)},
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 2048,
      'temperature': 0.7,
    });

    final response = _extractContent(data);

    // simple urgent keyword detection (same spirit as your Flutter code)
    final lower = response.toLowerCase();
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
    final requiresUrgentCare = urgentKeywords.any(lower.contains);

    return jsonEncode({
      'diagnosis': 'Further evaluation needed',
      'confidence': 0.75,
      'differentialDiagnosis': <String>[],
      'recommendations': response,
      'fullResponse': response,
      'requiresUrgentCare': requiresUrgentCare,
      'isInvalidImage': false,
    });
  }
}
