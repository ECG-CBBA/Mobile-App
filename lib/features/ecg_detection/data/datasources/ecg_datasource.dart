import 'dart:async';
import 'dart:math';

import 'package:uuid/uuid.dart';

import '../models/classification_result_model.dart';

abstract class ECGDataSource {
  Future<ClassificationResultModel> classifyECG({
    required List<double> ecgData,
    required int samplingRate,
  });
  
  List<ClassificationResultModel> getHistory();
  ClassificationResultModel? getById(String id);
  void saveToHistory(ClassificationResultModel result);
  void dispose();
}

class ECGMockDataSource implements ECGDataSource {
  final List<ClassificationResultModel> _history = [];
  final Uuid _uuid = const Uuid();
  final Random _random = Random();
  
  static const List<String> _classes = ['Normal', 'SVEB', 'VEB', 'Fusion', 'Unknown'];
  static const Map<String, String> _classNames = {
    'Normal': 'Ritmo sinusal normal',
    'SVEB': 'Latido ectópico supraventricular',
    'VEB': 'Latido ectópico ventricular',
    'Fusion': 'Latido de fusión',
    'Unknown': 'No clasificable / Marcapasos',
  };

  @override
  Future<ClassificationResultModel> classifyECG({
    required List<double> ecgData,
    required int samplingRate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final selectedClass = _classes[_random.nextInt(_classes.length)];
    final confidence = 0.65 + (_random.nextDouble() * 0.30);
    final processingTimeMs = 50 + _random.nextInt(100);
    
    final allProbs = <String, double>{};
    for (final cls in _classes) {
      if (cls == selectedClass) {
        allProbs[_classNames[cls]!] = confidence;
      } else {
        allProbs[_classNames[cls]!] = (1 - confidence) / (_classes.length - 1);
      }
    }
    
    final result = ClassificationResultModel(
      id: _uuid.v4(),
      sessionId: _uuid.v4(),
      classification: selectedClass,
      arrhythmiaName: _classNames[selectedClass]!,
      confidence: double.parse(confidence.toStringAsFixed(2)),
      processingTimeMs: processingTimeMs,
      allProbabilities: allProbs,
      timestamp: DateTime.now(),
      ecgData: ecgData,
      samplingRate: samplingRate,
    );
    
    _history.insert(0, result);
    return result;
  }

  @override
  List<ClassificationResultModel> getHistory() {
    return List.unmodifiable(_history);
  }

  @override
  ClassificationResultModel? getById(String id) {
    try {
      return _history.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void saveToHistory(ClassificationResultModel result) {
    _history.insert(0, result);
  }

  @override
  void dispose() {
    _history.clear();
  }
}

class ECGRemoteDataSource implements ECGDataSource {
  final List<ClassificationResultModel> _history = [];
  
  @override
  Future<ClassificationResultModel> classifyECG({
    required List<double> ecgData,
    required int samplingRate,
  }) async {
    throw UnimplementedError('WebSocket not implemented yet');
  }

  @override
  List<ClassificationResultModel> getHistory() => _history;

  @override
  ClassificationResultModel? getById(String id) {
    try {
      return _history.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void saveToHistory(ClassificationResultModel result) {
    _history.insert(0, result);
  }

  @override
  void dispose() {
    _history.clear();
  }
}