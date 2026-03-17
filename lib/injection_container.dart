import 'package:get_it/get_it.dart';

import 'features/ecg_detection/data/repositories/ecg_repository_impl.dart';
import 'features/ecg_detection/domain/repositories/ecg_repository.dart';
import 'features/ecg_detection/domain/usecases/classify_ecg.dart';
import 'features/ecg_detection/domain/usecases/get_detection_history.dart';
import 'features/ecg_detection/presentation/bloc/detection/detection_bloc.dart';
import 'features/ecg_detection/presentation/bloc/history/history_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Repositories
  getIt.registerLazySingleton<ECGRepository>(
    () => ECGRepositoryImpl(),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => ClassifyECG(getIt<ECGRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetDetectionHistory(getIt<ECGRepository>()),
  );

  // BLoCs
  getIt.registerFactory(
    () => DetectionBloc(classifyECG: getIt<ClassifyECG>()),
  );
  getIt.registerFactory(
    () => HistoryBloc(getDetectionHistory: getIt<GetDetectionHistory>()),
  );
}