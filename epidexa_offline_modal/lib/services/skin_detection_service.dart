import '../models/prediction_result.dart';
import 'model_inference_service.dart';
import 'chatgpt_service.dart';

class SkinDetectionService {
  final ModelInferenceService _modelService;
  final ChatGPTService _chatService;

  SkinDetectionService()
    : _modelService = ModelInferenceService(),
      _chatService = ChatGPTService();

  Future<void> initialize({String? modelPath}) async {
    await _modelService.initialize(modelPath: modelPath);
  }

  Future<DetectionResponse> detectSkinDisease(String imagePath) async {
    try {
      final prediction = await _modelService.predict(imagePath);

      String? precautions;
      try {
        precautions = await _chatService.getPrecautions(prediction);
      } catch (e) {
        print('Warning: Failed to get precautions from ChatGPT: $e');
      }

      return DetectionResponse(
        prediction: prediction,
        precautions: precautions,
        success: true,
      );
    } catch (e) {
      return DetectionResponse(success: false, error: e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getTopPredictions(
    String imagePath, {
    int k = 3,
  }) async {
    return await _modelService.predictTopK(imagePath, k: k);
  }

  Future<String> askDoctorQuestion(
    String question, {
    PredictionResult? context,
  }) async {
    return await _chatService.askQuestion(question, context: context);
  }

  void dispose() {
    _modelService.dispose();
    _chatService.dispose();
  }

  bool get isInitialized => _modelService.isInitialized;
}
