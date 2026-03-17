import 'package:equatable/equatable.dart';
import '../../../domain/entities/classification_result.dart';

enum DetectionStatus { initial, collecting, processing, completed, error }

class DetectionState extends Equatable {
  final DetectionStatus status;
  final List<double> ecgData;
  final ClassificationResult? result;
  final String? errorMessage;
  final double progress;

  const DetectionState({
    this.status = DetectionStatus.initial,
    this.ecgData = const [],
    this.result,
    this.errorMessage,
    this.progress = 0.0,
  });

  DetectionState copyWith({
    DetectionStatus? status,
    List<double>? ecgData,
    ClassificationResult? result,
    String? errorMessage,
    double? progress,
  }) {
    return DetectionState(
      status: status ?? this.status,
      ecgData: ecgData ?? this.ecgData,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage, progress];
}
