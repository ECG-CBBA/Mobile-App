import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/arrhythmia_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/classification_result.dart';
import '../widgets/classification_card.dart';
import '../widgets/ecg_chart_widget.dart';

class DetectionDetailPage extends StatelessWidget {
  final ClassificationResult detection;

  const DetectionDetailPage({super.key, required this.detection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Detección'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            if (detection.ecgData != null && detection.ecgData!.isNotEmpty)
              _buildECGSection(),
            const SizedBox(height: 16),
            ClassificationCard(result: detection),
            const SizedBox(height: 16),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final color = _getStatusColor();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(),
                color: color,
                size: 40,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detection.classification,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMMM yyyy - HH:mm')
                        .format(detection.timestamp),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildECGSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Señal ECG',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${detection.samplingRate ?? 360} Hz',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ECGChartWidget(
              data: detection.ecgData!,
              height: 250,
              samplingRate: detection.samplingRate ?? 360,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    final description =
        ArrhythmiaConstants.classDescriptions[detection.classification] ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.secondary),
                SizedBox(width: 8),
                Text(
                  'Acerca de esta clasificación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('ID de sesión', detection.sessionId),
            _buildInfoRow(
                'Tiempo de procesamiento', '${detection.processingTimeMs} ms'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (detection.isNormal) return AppColors.normal;
    if (detection.isCritical) return AppColors.critical;
    if (detection.isWarning) return AppColors.warning;
    return AppColors.textSecondary;
  }

  IconData _getStatusIcon() {
    if (detection.isNormal) return Icons.check_circle;
    if (detection.isCritical) return Icons.warning;
    if (detection.isWarning) return Icons.info;
    return Icons.help_outline;
  }
}