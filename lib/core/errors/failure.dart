import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class WebSocketFailure extends Failure {
  const WebSocketFailure([super.message = 'WebSocket connection failed']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Connection timeout']);
}

class InvalidDataFailure extends Failure {
  const InvalidDataFailure([super.message = 'Invalid data received']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error occurred']);
}