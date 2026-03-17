import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/classification_result.dart';

abstract class ECGRepository {
  Future<Either<Failure, ClassificationResult>> classifyECG({
    required List<double> ecgData,
    required int samplingRate,
  });
  
  Future<Either<Failure, List<ClassificationResult>>> getDetectionHistory();
  
  Future<Either<Failure, ClassificationResult>> getDetectionById(String id);
  
  Future<void> saveDetection(ClassificationResult result);
  
  Stream<ClassificationResult> get classificationStream;
  
  void dispose();
}