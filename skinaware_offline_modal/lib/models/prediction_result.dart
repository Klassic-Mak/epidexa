class PredictionResult {
  final String diseaseClass;
  final double confidence;
  final DateTime timestamp;
  final String imagePath;

  PredictionResult({
    required this.diseaseClass,
    required this.confidence,
    required this.timestamp,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'diseaseClass': diseaseClass,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
    'imagePath': imagePath,
  };

  factory PredictionResult.fromJson(Map<String, dynamic> json) =>
      PredictionResult(
        diseaseClass: json['diseaseClass'],
        confidence: json['confidence'],
        timestamp: DateTime.parse(json['timestamp']),
        imagePath: json['imagePath'],
      );
}

class DetectionResponse {
  final PredictionResult? prediction;
  final String? precautions;
  final bool success;
  final String? error;

  DetectionResponse({
    this.prediction,
    this.precautions,
    required this.success,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'prediction': prediction?.toJson(),
    'precautions': precautions,
    'success': success,
    'error': error,
  };
}
