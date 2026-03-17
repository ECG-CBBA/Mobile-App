import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/ecg_detection/presentation/bloc/detection/detection_bloc.dart';
import 'features/ecg_detection/presentation/bloc/history/history_bloc.dart';
import 'features/ecg_detection/presentation/pages/home_page.dart';
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const ECGApp());
}

class ECGApp extends StatelessWidget {
  const ECGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetectionBloc>(
          create: (_) => getIt<DetectionBloc>(),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => getIt<HistoryBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'ECG Monitor',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}