import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ECGChartWidget extends StatelessWidget {
  final List<double> data;
  final double height;
  final bool showGrid;
  final int maxPointsToShow;
  final int samplingRate;

  const ECGChartWidget({
    super.key,
    required this.data,
    this.height = 200,
    this.showGrid = true,
    this.maxPointsToShow = 1800,
    this.samplingRate = 360,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'Sin datos ECG',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final displayData = _getDisplayData();

    if (displayData.length < 2) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'Recopilando datos...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final spots = displayData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    final minVal = displayData.reduce(min);
    final maxVal = displayData.reduce(max);
    final range = (maxVal - minVal).clamp(0.01, double.infinity);
    final padding = range * 0.12;
    final minY = minVal - padding;
    final maxY = maxVal + padding;

    final yInterval = _niceInterval((maxY - minY) / 4);

    final xGridInterval = samplingRate / 2.0;
    final xLabelInterval = samplingRate.toDouble();

    final chartWidth = _calculateChartWidth(displayData.length);

    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: chartWidth,
          height: height,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: showGrid,
                drawVerticalLine: true,
                horizontalInterval: yInterval,
                verticalInterval: xGridInterval,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.ecgGrid,
                  strokeWidth: 0.5,
                ),
                getDrawingVerticalLine: (_) => FlLine(
                  color: AppColors.ecgGrid,
                  strokeWidth: 0.5,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: xLabelInterval,
                    getTitlesWidget: (value, meta) {
                      final seconds = (value / samplingRate).floor();
                      return Text(
                        '${seconds}s',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 40,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: AppColors.ecgGrid, width: 1),
              ),
              minX: 0,
              maxX: (displayData.length - 1).toDouble(),
              minY: minY,
              maxY: maxY,
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: AppColors.ecgLine,
                  barWidth: 1.5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
            duration: Duration.zero,
          ),
        ),
      ),
    );
  }

  List<double> _getDisplayData() {
    if (data.length <= maxPointsToShow) return data;
    return data.sublist(data.length - maxPointsToShow);
  }

  double _calculateChartWidth(int dataLength) {
    const double pixelsPerPoint = 1.5;
    const double minWidth = 300.0;
    final calculatedWidth = dataLength * pixelsPerPoint;
    return calculatedWidth < minWidth ? minWidth : calculatedWidth;
  }

  double _niceInterval(double rawInterval) {
    if (rawInterval <= 0.05) return 0.05;
    if (rawInterval <= 0.1) return 0.1;
    if (rawInterval <= 0.2) return 0.2;
    if (rawInterval <= 0.25) return 0.25;
    if (rawInterval <= 0.5) return 0.5;
    if (rawInterval <= 1.0) return 1.0;
    return (rawInterval / 0.5).ceil() * 0.5;
  }
}