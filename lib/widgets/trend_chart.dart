// 血壓記錄 App 趨勢圖表元件
// 用於顯示血壓趨勢

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/blood_pressure_record.dart';
import '../utils/date_time_utils.dart';
import '../themes/app_theme.dart';

class TrendChart extends StatelessWidget {
  final List<BloodPressureRecord> records;
  final bool showLabels;

  const TrendChart({super.key, required this.records, this.showLabels = true});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('暫無數據'));
    }

    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => a.measureTime.compareTo(b.measureTime));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.grey[300], strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.grey[300], strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showLabels,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= sortedRecords.length || value.toInt() < 0) {
                    return const SizedBox();
                  }

                  final record = sortedRecords[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(DateTimeUtils.formatDateMMDD(record.measureTime), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showLabels,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10));
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[300]!)),
          minX: 0,
          maxX: sortedRecords.length - 1.0,
          minY: _getMinY(),
          maxY: _getMaxY(),
          lineBarsData: [
            // 收縮壓線
            LineChartBarData(
              spots: _getSystolicSpots(sortedRecords),
              isCurved: true,
              color: AppTheme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            // 舒張壓線
            LineChartBarData(
              spots: _getDiastolicSpots(sortedRecords),
              isCurved: true,
              color: AppTheme.successColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: AppTheme.successColor.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getSystolicSpots(List<BloodPressureRecord> sortedRecords) {
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedRecords.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedRecords[i].systolic.toDouble()));
    }
    return spots;
  }

  List<FlSpot> _getDiastolicSpots(List<BloodPressureRecord> sortedRecords) {
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedRecords.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedRecords[i].diastolic.toDouble()));
    }
    return spots;
  }

  double _getMinY() {
    if (records.isEmpty) return 60;

    final minSystolic = records.map((e) => e.systolic).reduce((a, b) => a < b ? a : b);
    final minDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a < b ? a : b);

    return (minDiastolic - 10).toDouble().clamp(60, double.infinity);
  }

  double _getMaxY() {
    if (records.isEmpty) return 180;

    final maxSystolic = records.map((e) => e.systolic).reduce((a, b) => a > b ? a : b);
    final maxDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a > b ? a : b);

    return (maxSystolic + 10).toDouble().clamp(0, 200);
  }
}
