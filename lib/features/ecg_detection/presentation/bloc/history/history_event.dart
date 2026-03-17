import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {
  const LoadHistoryEvent();
}

class RefreshHistoryEvent extends HistoryEvent {
  const RefreshHistoryEvent();
}

class DeleteHistoryItemEvent extends HistoryEvent {
  final String id;

  const DeleteHistoryItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}