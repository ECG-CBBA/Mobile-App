enum ConnectionMode { mock, production }

class ApiConfig {
  static const ConnectionMode mode = ConnectionMode.mock;
  
  static const String wsUrl = 'ws://localhost:8000/ws';
  
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  static const int wsPingIntervalSeconds = 30;
  static const int wsReconnectMaxAttempts = 5;
}