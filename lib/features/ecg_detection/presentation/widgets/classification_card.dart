import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/classification_result.dart';

class ClassificationCard extends StatelessWidget {
  final ClassificationResult result;

  const ClassificationCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final icon = _getStatusIcon();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.classification,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        result.arrhythmiaName,
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoChip(
                  'Confianza',
                  '${(result.confidence * 100).toStringAsFixed(1)}%',
                  color,
                ),
                _buildInfoChip(
                  'Tiempo',
                  '${result.processingTimeMs}ms',
                  AppColors.secondary,
                ),
              ],
            ),
            if (result.allProbabilities.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Probabilidades',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              ...result.allProbabilities.entries.map(
                (entry) => _buildProbabilityBar(entry.key, entry.value),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilityBar(String label, double probability) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '${(probability * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          LinearProgressIndicator(
            value: probability,
            backgroundColor: AppColors.ecgGrid,
            valueColor: AlwaysStoppedAnimation<Color>(
              probability > 0.5 ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (result.isNormal) return AppColors.normal;
    if (result.isCritical) return AppColors.critical;
    if (result.isWarning) return AppColors.warning;
    return AppColors.textSecondary;
  }

  IconData _getStatusIcon() {
    if (result.isNormal) return Icons.check_circle;
    if (result.isCritical) return Icons.warning;
    if (result.isWarning) return Icons.info;
    return Icons.help_outline;
  }
}