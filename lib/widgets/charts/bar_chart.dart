/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-16 16:16:42
 * @ Description: 血壓記錄 App 長條圖組件 - 顯示血壓和心率數據
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../../models/blood_pressure_record.dart';
// import '../../themes/app_theme.dart'; // 移除不必要的引用
import '../../utils/date_time_utils.dart';
import '../../l10n/app_localizations_extension.dart';

class BloodPressureBarChart extends StatelessWidget {
  final List<BloodPressureRecord> records;
  final bool showPulse;

  const BloodPressureBarChart({super.key, required this.records, this.showPulse = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tertiaryColor = theme.colorScheme.tertiary; // 定義第三色調，用於心率

    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(context.tr('暫無數據'), style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
          ],
        ),
      );
    }

    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => a.measureTime.compareTo(b.measureTime));

    // 根據記錄數量調整顯示間隔
    final interval = _calculateInterval(sortedRecords.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          minY: 0,
          groupsSpace: 35,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: theme.cardColor,
              tooltipRoundedRadius: 8,
              tooltipBorder: BorderSide(color: theme.primaryColor.withAlpha(51), width: 1),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final record = sortedRecords[groupIndex];
                String title;
                int value;
                Color color;

                if (rodIndex == 0) {
                  title = '收縮壓';
                  value = record.systolic;
                  color = theme.primaryColor;
                } else if (rodIndex == 1) {
                  title = '舒張壓';
                  value = record.diastolic;
                  color = theme.colorScheme.secondary;
                } else {
                  title = '心率';
                  value = record.pulse;
                  color = tertiaryColor;
                }

                final date = DateTimeUtils.formatDateMMDD(record.measureTime);
                final time = DateTimeUtils.formatTimeHHMM(record.measureTime);
                final unit = rodIndex == 2 ? 'bpm' : 'mmHg';

                return BarTooltipItem('$title: $value $unit\n$date $time', TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12));
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {},
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= sortedRecords.length || index < 0) {
                    return const SizedBox();
                  }

                  // 根據記錄數量決定是否顯示所有標籤
                  if (sortedRecords.length > 7 && index % interval.toInt() != 0) {
                    return const SizedBox();
                  }

                  final record = sortedRecords[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateTimeUtils.formatDateMMDD(record.measureTime),
                      style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 10, fontWeight: FontWeight.w500),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
              left: BorderSide(color: theme.dividerColor),
              top: BorderSide.none,
              right: BorderSide.none,
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              // 只在特定值處顯示網格線
              if (value % 20 == 0 && value > 0) {
                return FlLine(color: theme.dividerColor.withOpacity(0.5), strokeWidth: 0.5);
              }
              return FlLine(color: Colors.transparent);
            },
          ),
          barGroups: _getBarGroups(sortedRecords, theme),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              // 高血壓參考線
              HorizontalLine(
                y: 140,
                color: theme.colorScheme.error.withAlpha(128),
                strokeWidth: 0.8,
                dashArray: [4, 4],
                label: HorizontalLineLabel(
                  show: false, // 移除標籤以更接近圖片樣式
                ),
              ),
              // 正常血壓上限參考線
              HorizontalLine(
                y: 120,
                color: theme.colorScheme.secondary.withAlpha(128),
                strokeWidth: 0.8,
                dashArray: [4, 4],
                label: HorizontalLineLabel(
                  show: false, // 移除標籤以更接近圖片樣式
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 根據記錄數量計算顯示間隔
  double _calculateInterval(int recordCount) {
    if (recordCount <= 7) {
      return 1; // 7天內顯示所有點
    } else if (recordCount <= 14) {
      return 2; // 2週顯示每隔一天
    } else {
      return 3; // 1個月顯示每隔兩天
    }
  }

  // 獲取長條圖組
  List<BarChartGroupData> _getBarGroups(List<BloodPressureRecord> sortedRecords, ThemeData theme) {
    final List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < sortedRecords.length; i++) {
      final record = sortedRecords[i];
      final rods = <BarChartRodData>[];

      // 收縮壓長條
      rods.add(
        BarChartRodData(
          toY: record.systolic.toDouble(),
          color: theme.primaryColor,
          width: 5.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      );

      // 舒張壓長條
      rods.add(
        BarChartRodData(
          toY: record.diastolic.toDouble(),
          color: theme.colorScheme.secondary,
          width: 5.5,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      );

      // 心率長條 (僅在 showPulse 為 true 時顯示)
      if (showPulse) {
        rods.add(
          BarChartRodData(
            toY: record.pulse.toDouble(),
            color: Colors.orange,
            width: 5.5,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            backDrawRodData: BackgroundBarChartRodData(show: false),
          ),
        );
      }

      barGroups.add(BarChartGroupData(x: i, barRods: rods, groupVertically: false, barsSpace: 1.5, showingTooltipIndicators: []));
    }

    return barGroups;
  }

  double _getMaxY() {
    if (records.isEmpty) return 180;

    final maxSystolic = records.map((e) => e.systolic).reduce((a, b) => a > b ? a : b);

    // 如果顯示心率，考慮心率的最大值
    if (showPulse) {
      final maxPulse = records.map((e) => e.pulse).reduce((a, b) => a > b ? a : b);
      return (max(maxSystolic, maxPulse) + 30).toDouble().clamp(double.negativeInfinity, 200);
    }

    return (maxSystolic + 30).toDouble().clamp(double.negativeInfinity, 200);
  }
}
