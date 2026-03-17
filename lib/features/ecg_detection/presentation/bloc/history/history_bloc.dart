import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_detection_history.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetDetectionHistory getDetectionHistory;

  HistoryBloc({required this.getDetectionHistory}) : super(const HistoryState()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<RefreshHistoryEvent>(_onRefreshHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));

    final result = await getDetectionHistory();

    result.fold(
      (failure) => emit(state.copyWith(
        status: HistoryStatus.error,
        errorMessage: failure.message,
      )),
      (detections) => emit(state.copyWith(
        status: HistoryStatus.loaded,
        detections: detections,
      )),
    );
  }

  Future<void> _onRefreshHistory(
    RefreshHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    add(const LoadHistoryEvent());
  }
}