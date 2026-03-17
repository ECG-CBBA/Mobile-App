import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/classify_ecg.dart';
import 'detection_event.dart';
import 'detection_state.dart';

class DetectionBloc extends Bloc<DetectionEvent, DetectionState> {
  final ClassifyECG classifyECG;
  final Random _random = Random();

  Timer? _collectionTimer;
  static const int _sampleRate = 360;
  List<double> _accumulatedData = [];
  double _currentProgress = 0.0;
  double _ecgPhase = 0.0;

  DetectionBloc({required this.classifyECG}) : super(const DetectionState()) {
    on<StartDetectionEvent>(_onStartDetection);
    on<StopDetectionEvent>(_onStopDetection);
    on<ResetDetectionEvent>(_onResetDetection);
    on<UpdateECGDataEvent>(_onUpdateECGData);
  }

  Future<void> _onStartDetection(
    StartDetectionEvent event,
    Emitter<DetectionState> emit,
  ) async {
    _accumulatedData = [];
    _currentProgress = 0.0;
    _ecgPhase = 0.0;

    emit(state.copyWith(
      status: DetectionStatus.collecting,
      ecgData: [],
      progress: 0.0,
    ));

    final totalSamples = event.durationSeconds * _sampleRate;
    final samplesPerTick = _sampleRate ~/ 10;
    var collectedSamples = 0;

    _collectionTimer?.cancel();
    _collectionTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        final batch = _generateMockECGData(samplesPerTick);

        _accumulatedData.addAll(batch);

        collectedSamples += samplesPerTick;
        _currentProgress = (collectedSamples / totalSamples).clamp(0.0, 1.0);

        if (collectedSamples >= totalSamples) {
          timer.cancel();
          add(const StopDetectionEvent());
        } else {
          add(UpdateECGDataEvent(
            ecgData: List<double>.from(_accumulatedData),
            progress: _currentProgress,
          ));
        }
      },
    );
  }

  Future<void> _onStopDetection(
    StopDetectionEvent event,
    Emitter<DetectionState> emit,
  ) async {
    _collectionTimer?.cancel();

    emit(state.copyWith(
      status: DetectionStatus.processing,
      ecgData: List<double>.from(_accumulatedData),
    ));

    final result = await classifyECG(
      ecgData: _accumulatedData,
      samplingRate: _sampleRate,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: DetectionStatus.error,
        errorMessage: failure.message,
      )),
      (classification) => emit(state.copyWith(
        status: DetectionStatus.completed,
        result: classification,
        progress: 1.0,
        ecgData: List<double>.from(_accumulatedData),
      )),
    );
  }

  void _onUpdateECGData(
    UpdateECGDataEvent event,
    Emitter<DetectionState> emit,
  ) {
    emit(state.copyWith(
      ecgData: event.ecgData,
      progress: event.progress,
    ));
  }

  void _onResetDetection(
    ResetDetectionEvent event,
    Emitter<DetectionState> emit,
  ) {
    _collectionTimer?.cancel();
    _accumulatedData = [];
    _currentProgress = 0.0;
    _ecgPhase = 0.0;
    emit(const DetectionState());
  }

  List<double> _generateMockECGData(int count) {
    final List<double> data = [];
    const double dt = 1.0 / _sampleRate;
    const double heartPeriod = 60.0 / 72.0;

    for (int i = 0; i < count; i++) {
      final t = _ecgPhase + i * dt;

      final pWave = sin(2 * pi * 1.2 * t) * 0.15;

      final tInCycle = t % heartPeriod;
      final qrs = exp(-pow(tInCycle - 0.08, 2) / 0.0005) * 1.2;

      final tWave = exp(-pow(tInCycle - 0.35, 2) / 0.008) * 0.3;

      final baseline = sin(2 * pi * 0.25 * t) * 0.05;
      final noise = (_random.nextDouble() - 0.5) * 0.04;

      data.add((pWave + qrs + tWave + baseline + noise) * 0.45 + 0.5);
    }

    _ecgPhase += count * dt;
    return data;
  }

  @override
  Future<void> close() {
    _collectionTimer?.cancel();
    return super.close();
  }
}

class UpdateECGDataEvent extends DetectionEvent {
  final List<double> ecgData;
  final double progress;

  const UpdateECGDataEvent({
    required this.ecgData,
    required this.progress,
  });

  @override
  List<Object?> get props => [ecgData, progress];
}