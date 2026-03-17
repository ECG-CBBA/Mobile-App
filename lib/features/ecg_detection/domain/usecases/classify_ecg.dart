import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/classification_result.dart';
import '../repositories/ecg_repository.dart';

class ClassifyECG {
  final ECGRepository repository;

  ClassifyECG(this.repository);

  Future<Either<Failure, ClassificationResult>> call({
    required List<double> ecgData,
    required int samplingRate,
  }) {
    return repository.classifyECG(
      ecgData: ecgData,
      samplingRate: samplingRate,
    );
  }
}