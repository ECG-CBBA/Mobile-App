import '../../domain/entities/classification_result.dart';

class ClassificationResultModel extends ClassificationResult {
  const ClassificationResultModel({
    required super.id,
    required super.sessionId,
    required super.classification,
    required super.arrhythmiaName,
    required super.confidence,
    required super.processingTimeMs,
    required super.allProbabilities,
    required super.timestamp,
    super.ecgData,
    super.samplingRate,
  });

  factory ClassificationResultModel.fromJson(Map<String, dynamic> json) {
    return ClassificationResultModel(
      id: json['id'] ?? '',
      sessionId: json['session_id'] ?? '',
      classification: json['classification'] ?? '',
      arrhythmiaName: json['arrhythmia_name'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      processingTimeMs: json['processing_time_ms'] ?? 0,
      allProbabilities: Map<String, double>.from(
        (json['all_probabilities'] ?? {}).map(
          (key, value) => MapEntry(key, (value ?? 0.0).toDouble()),
        ),
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      ecgData: json['ecg_data'] != null
          ? List<double>.from(json['ecg_data'].map((e) => (e as num).toDouble()))
          : null,
      samplingRate: json['sampling_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'classification': classification,
      'arrhythmia_name': arrhythmiaName,
      'confidence': confidence,
      'processing_time_ms': processingTimeMs,
      'all_probabilities': allProbabilities,
      'timestamp': timestamp.toIso8601String(),
      'ecg_data': ecgData,
      'sampling_rate': samplingRate,
    };
  }

  factory ClassificationResultModel.fromEntity(ClassificationResult entity) {
    return ClassificationResultModel(
      id: entity.id,
      sessionId: entity.sessionId,
      classification: entity.classification,
      arrhythmiaName: entity.arrhythmiaName,
      confidence: entity.confidence,
      processingTimeMs: entity.processingTimeMs,
      allProbabilities: entity.allProbabilities,
      timestamp: entity.timestamp,
      ecgData: entity.ecgData,
      samplingRate: entity.samplingRate,
    );
  }
}