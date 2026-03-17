import 'package:equatable/equatable.dart';
import '../../../domain/entities/classification_result.dart';

enum HistoryStatus { initial, loading, loaded, error }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<ClassificationResult> detections;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.detections = const [],
    this.errorMessage,
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<ClassificationResult>? detections,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      detections: detections ?? this.detections,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, detections, errorMessage];
}