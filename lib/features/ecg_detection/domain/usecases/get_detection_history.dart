import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/classification_result.dart';
import '../repositories/ecg_repository.dart';

class GetDetectionHistory {
  final ECGRepository repository;

  GetDetectionHistory(this.repository);

  Future<Either<Failure, List<ClassificationResult>>> call() {
    return repository.getDetectionHistory();
  }
}