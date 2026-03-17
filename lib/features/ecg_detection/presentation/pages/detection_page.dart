import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/detection/detection_bloc.dart';
import '../bloc/detection/detection_event.dart';
import '../bloc/detection/detection_state.dart';
import '../widgets/classification_card.dart';
import '../widgets/ecg_chart_widget.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetectionBloc>().add(const ResetDetectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return const _DetectionPageContent();
  }
}

class _DetectionPageContent extends StatelessWidget {
  const _DetectionPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Detección'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<DetectionBloc>().add(const ResetDetectionEvent());
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<DetectionBloc, DetectionState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard(state),
                const SizedBox(height: 16),
                if (state.status == DetectionStatus.collecting ||
                    state.status == DetectionStatus.processing ||
                    state.status == DetectionStatus.completed)
                  _buildECGSection(state),
                if (state.status == DetectionStatus.completed &&
                    state.result != null)
                  ClassificationCard(result: state.result!),
                const SizedBox(height: 24),
                _buildActionButton(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(DetectionState state) {
    final statusInfo = _getStatusInfo(state.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (state.status == DetectionStatus.processing)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                statusInfo.icon,
                color: statusInfo.color,
                size: 24,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusInfo.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    statusInfo.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (state.status == DetectionStatus.collecting)
              Text(
                '${(state.progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildECGSection(DetectionState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Señal ECG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ECGChartWidget(
              data: state.ecgData,
              height: 250,
              samplingRate: 360,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, DetectionState state) {
    final bloc = context.read<DetectionBloc>();

    if (state.status == DetectionStatus.initial ||
        state.status == DetectionStatus.error ||
        state.status == DetectionStatus.completed) {
      return ElevatedButton.icon(
        onPressed: () => bloc.add(const StartDetectionEvent(durationSeconds: 5)),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Iniciar Detección'),
      );
    }

    if (state.status == DetectionStatus.collecting) {
      return ElevatedButton.icon(
        onPressed: () => bloc.add(const StopDetectionEvent()),
        icon: const Icon(Icons.stop),
        label: const Text('Procesar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
        ),
      );
    }

    if (state.status == DetectionStatus.processing) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
        label: const Text('Procesando...'),
      );
    }

    return const SizedBox.shrink();
  }

  _StatusInfo _getStatusInfo(DetectionStatus status) {
    switch (status) {
      case DetectionStatus.initial:
        return _StatusInfo(
          icon: Icons.favorite_border,
          title: 'Listo para comenzar',
          subtitle: 'Presione el botón para iniciar la detección',
          color: AppColors.textSecondary,
        );
      case DetectionStatus.collecting:
        return _StatusInfo(
          icon: Icons.monitor_heart,
          title: 'Capturando datos ECG',
          subtitle: 'Mantenga el sensor conectado',
          color: AppColors.primary,
        );
      case DetectionStatus.processing:
        return _StatusInfo(
          icon: Icons.hourglass_empty,
          title: 'Procesando',
          subtitle: 'Analizando señal...',
          color: AppColors.warning,
        );
      case DetectionStatus.completed:
        return _StatusInfo(
          icon: Icons.check_circle,
          title: 'Detección completada',
          subtitle: 'Resultado disponible',
          color: AppColors.normal,
        );
      case DetectionStatus.error:
        return _StatusInfo(
          icon: Icons.error,
          title: 'Error',
          subtitle: 'Ha ocurrido un error',
          color: AppColors.critical,
        );
    }
  }
}

class _StatusInfo {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  _StatusInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}