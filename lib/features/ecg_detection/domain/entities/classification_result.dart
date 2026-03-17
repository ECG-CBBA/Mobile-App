import 'package:equatable/equatable.dart';

class ClassificationResult extends Equatable {
  final String id;
  final String sessionId;
  final String classification;
  final String arrhythmiaName;
  final double confidence;
  final int processingTimeMs;
  final Map<String, double> allProbabilities;
  final DateTime timestamp;
  final List<double>? ecgData;
  final int? samplingRate;

  const ClassificationResult({
    required this.id,
    required this.sessionId,
    required this.classification,
    required this.arrhythmiaName,
    required this.confidence,
    required this.processingTimeMs,
    required this.allProbabilities,
    required this.timestamp,
    this.ecgData,
    this.samplingRate,
  });

  bool get isNormal => classification == 'Normal';
  bool get isCritical => classification == 'VEB' || classification == 'Unknown';
  bool get isWarning => classification == 'SVEB' || classification == 'Fusion';

  @override
  List<Object?> get props => [
        id,
        sessionId,
        classification,
        arrhythmiaName,
        confidence,
        processingTimeMs,
        allProbabilities,
        timestamp,
      ];
}