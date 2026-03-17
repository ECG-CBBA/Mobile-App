import 'package:equatable/equatable.dart';

abstract class DetectionEvent extends Equatable {
  const DetectionEvent();

  @override
  List<Object?> get props => [];
}

class StartDetectionEvent extends DetectionEvent {
  final int durationSeconds;
  final int samplingRate;

  const StartDetectionEvent({
    this.durationSeconds = 5,
    this.samplingRate = 360,
  });

  @override
  List<Object?> get props => [durationSeconds, samplingRate];
}

class StopDetectionEvent extends DetectionEvent {
  const StopDetectionEvent();
}

class ClassificationReceivedEvent extends DetectionEvent {
  final List<double> ecgData;
  final int samplingRate;

  const ClassificationReceivedEvent({
    required this.ecgData,
    required this.samplingRate,
  });

  @override
  List<Object?> get props => [ecgData, samplingRate];
}

class ResetDetectionEvent extends DetectionEvent {
  const ResetDetectionEvent();
}