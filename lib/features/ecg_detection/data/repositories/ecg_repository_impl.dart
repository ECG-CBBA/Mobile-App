import 'package:dartz/dartz.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/classification_result.dart';
import '../../domain/repositories/ecg_repository.dart';
import '../datasources/ecg_datasource.dart';
import '../models/classification_result_model.dart';

class ECGRepositoryImpl implements ECGRepository {
  late final ECGDataSource _dataSource;
  final List<ClassificationResult> _historyCache = [];

  ECGRepositoryImpl() {
    _dataSource = ApiConfig.mode == ConnectionMode.mock
        ? ECGMockDataSource()
        : ECGRemoteDataSource();
  }

  @override
  Future<Either<Failure, ClassificationResult>> classifyECG({
    required List<double> ecgData,
    required int samplingRate,
  }) async {
    try {
      final result = await _dataSource.classifyECG(
        ecgData: ecgData,
        samplingRate: samplingRate,
      );
      _historyCache.insert(0, result);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClassificationResult>>> getDetectionHistory() async {
    try {
      final history = _dataSource.getHistory();
      return Right(history);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassificationResult>> getDetectionById(String id) async {
    try {
      final result = _dataSource.getById(id);
      if (result == null) {
        return const Left(InvalidDataFailure('Detection not found'));
      }
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<void> saveDetection(ClassificationResult result) async {
    final model = ClassificationResultModel.fromEntity(result);
    _dataSource.saveToHistory(model);
  }

  @override
  Stream<ClassificationResult> get classificationStream => throw UnimplementedError();

  @override
  void dispose() {
    _dataSource.dispose();
  }
}