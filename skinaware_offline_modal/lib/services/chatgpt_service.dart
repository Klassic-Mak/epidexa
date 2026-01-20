import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/prediction_result.dart';

class ChatGPTService {
  final Dio _dio;

  ChatGPTService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.openAiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

  Future<String> getPrecautions(PredictionResult prediction) async {
    if (!ApiConfig.isConfigured()) {
      throw Exception(
        'API key not configured. Call ApiConfig.setApiKey() first.',
      );
    }

    final prompt = _buildPrecautionPrompt(prediction);

    try {
      final response = await _makeRequest(prompt, ApiConfig.gptModel);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429 || e.response?.statusCode == 503) {
        return await _retryWithFallbackModel(prompt);
      }
      throw Exception('Failed to get precautions: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<String> _makeRequest(String prompt, String model) async {
    final response = await _dio.post(
      ApiConfig.chatCompletionEndpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConfig.getApiKey()}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': model,
        'messages': [
          {'role': 'system', 'content': ApiConfig.systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': ApiConfig.maxTokens,
        'temperature': ApiConfig.temperature,
      },
    );

    if (response.statusCode == 200) {
      final content = response.data['choices'][0]['message']['content'];
      return content.toString().trim();
    } else {
      throw Exception('API request failed with status: ${response.statusCode}');
    }
  }

  Future<String> _retryWithFallbackModel(String prompt) async {
    try {
      print('Retrying with fallback model: ${ApiConfig.gptModelFallback}');
      return await _makeRequest(prompt, ApiConfig.gptModelFallback);
    } catch (e) {
      throw Exception('Both primary and fallback models failed: $e');
    }
  }

  String _buildPrecautionPrompt(PredictionResult prediction) {
    return '''
I have detected a skin condition from an image analysis:

Detected Condition: ${prediction.diseaseClass}
Confidence Level: ${(prediction.confidence * 100).toStringAsFixed(1)}%
Detection Time: ${prediction.timestamp.toLocal()}

Please provide comprehensive guidance for this condition including:
1. A brief overview of what this condition is
2. Immediate care steps to take
3. Daily management recommendations
4. Things to avoid
5. When to seek professional medical help
6. Important disclaimers about AI detection limitations

Please be thorough but concise, and remember to emphasize the importance of professional medical consultation.
''';
  }

  Future<String> askQuestion(
    String question, {
    PredictionResult? context,
  }) async {
    if (!ApiConfig.isConfigured()) {
      throw Exception(
        'API key not configured. Call ApiConfig.setApiKey() first.',
      );
    }

    String prompt = question;

    if (context != null) {
      prompt =
          '''
Context: Previously detected skin condition - ${context.diseaseClass} 
(Confidence: ${(context.confidence * 100).toStringAsFixed(1)}%)

User Question: $question

Please provide a helpful, medically-informed response while maintaining appropriate boundaries and emphasizing the need for professional medical consultation when necessary.
''';
    }

    try {
      final response = await _makeRequest(prompt, ApiConfig.gptModel);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429 || e.response?.statusCode == 503) {
        return await _retryWithFallbackModel(prompt);
      }
      throw Exception('Failed to get response: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  void dispose() {
    _dio.close();
  }
}
