/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-16 16:16:42
 * @ Description: 血壓記錄 App 趨勢圖表元件 - 用於顯示血壓趨勢
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/blood_pressure_record.dart';
import '../../utils/date_time_utils.dart';
import '../../l10n/app_localizations_extension.dart';

class TrendChart extends StatelessWidget {
  final List<BloodPressureRecord> records;
  final bool showLabels;
  final bool showPulse;

  const TrendChart({super.key, required this.records, this.showLabels = true, this.showPulse = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline_outlined, size: 48, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
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

    // 顏色定義
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;
    final dividerColor = theme.dividerColor;
    final errorColor = theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
            verticalInterval: interval,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: dividerColor.withOpacity(0.5), strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: dividerColor.withOpacity(0.5), strokeWidth: 1);
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
                interval: interval,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= sortedRecords.length || index < 0 || index % interval.toInt() != 0) {
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
                showTitles: showLabels,
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
          borderData: FlBorderData(show: true, border: Border.all(color: dividerColor)),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: theme.cardColor,
              tooltipRoundedRadius: 8,
              tooltipBorder: BorderSide(color: primaryColor.withAlpha(51), width: 1),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final record = sortedRecords[barSpot.x.toInt()];
                  String title;
                  int value;
                  Color color;

                  if (barSpot.barIndex == 0) {
                    title = context.tr('收縮壓');
                    value = record.systolic;
                    color = primaryColor;
                  } else if (barSpot.barIndex == 1) {
                    title = context.tr('舒張壓');
                    value = record.diastolic;
                    color = secondaryColor;
                  } else {
                    title = context.tr('心率');
                    value = record.pulse;
                    color = Colors.orange;
                  }

                  final date = DateTimeUtils.formatDateMMDD(record.measureTime);
                  final time = DateTimeUtils.formatTimeHHMM(record.measureTime);
                  final unit = barSpot.barIndex == 2 ? 'bpm' : 'mmHg';

                  return LineTooltipItem('$title: $value $unit\n$date $time', TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12));
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            touchSpotThreshold: 20,
          ),
          minX: 0,
          maxX: sortedRecords.length - 1.0,
          minY: _getMinY(),
          maxY: _getMaxY(),
          lineBarsData: [
            // 收縮壓線
            LineChartBarData(
              spots: _getSystolicSpots(sortedRecords),
              isCurved: true,
              color: primaryColor,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  // 根據記錄數量決定是否顯示所有點
                  return records.length <= 14 || spot.x.toInt() % interval.toInt() == 0;
                },
                getDotPainter:
                    (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: primaryColor),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: primaryColor.withAlpha(26),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor.withAlpha(51), primaryColor.withAlpha(13)],
                ),
              ),
            ),
            // 舒張壓線
            LineChartBarData(
              spots: _getDiastolicSpots(sortedRecords),
              isCurved: true,
              color: secondaryColor,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  // 根據記錄數量決定是否顯示所有點
                  return records.length <= 14 || spot.x.toInt() % interval.toInt() == 0;
                },
                getDotPainter:
                    (spot, percent, barData, index) =>
                        FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: secondaryColor),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: secondaryColor.withAlpha(26),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [secondaryColor.withAlpha(51), secondaryColor.withAlpha(13)],
                ),
              ),
            ),
            // 心率線 (僅在 showPulse 為 true 時顯示)
            if (showPulse)
              LineChartBarData(
                spots: _getPulseSpots(sortedRecords),
                isCurved: true,
                color: Colors.orange,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    // 根據記錄數量決定是否顯示所有點
                    return records.length <= 14 || spot.x.toInt() % interval.toInt() == 0;
                  },
                  getDotPainter:
                      (spot, percent, barData, index) =>
                          FlDotCirclePainter(radius: 3.5, color: Colors.white, strokeWidth: 2, strokeColor: Colors.orange),
                ),
                dashArray: [4, 4], // 使用虛線表示心率
              ),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              // 正常血壓上限參考線
              HorizontalLine(
                y: 120,
                color: secondaryColor.withAlpha(128),
                strokeWidth: 1,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 8, bottom: 2),
                  style: TextStyle(color: secondaryColor, fontSize: 9, fontWeight: FontWeight.w500),
                  labelResolver: (line) => context.tr('正常上限'),
                ),
              ),
              // 高血壓參考線
              HorizontalLine(
                y: 140,
                color: errorColor.withAlpha(128),
                strokeWidth: 1,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 8, bottom: 2),
                  style: TextStyle(color: errorColor, fontSize: 9, fontWeight: FontWeight.w500),
                  labelResolver: (line) => context.tr('高血壓'),
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

  List<FlSpot> _getPulseSpots(List<BloodPressureRecord> sortedRecords) {
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedRecords.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedRecords[i].pulse.toDouble()));
    }
    return spots;
  }

  double _getMinY() {
    if (records.isEmpty) return 60;

    final minDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a < b ? a : b);
    // 如果顯示心率，考慮心率的最小值
    if (showPulse) {
      final minPulse = records.map((e) => e.pulse).reduce((a, b) => a < b ? a : b);
      return (min(minDiastolic, minPulse) - 10).toDouble().clamp(40, double.infinity);
    }
    return (minDiastolic - 10).toDouble().clamp(60, double.infinity);
  }

  double _getMaxY() {
    if (records.isEmpty) return 180;

    final maxSystolic = records.map((e) => e.systolic).reduce((a, b) => a > b ? a : b);
    // 如果顯示心率，考慮心率的最大值
    if (showPulse) {
      final maxPulse = records.map((e) => e.pulse).reduce((a, b) => a > b ? a : b);
      return (max(maxSystolic, maxPulse) + 10).toDouble().clamp(double.negativeInfinity, 200);
    }
    return (maxSystolic + 10).toDouble().clamp(double.negativeInfinity, 200);
  }

  // 取最小值
  int min(int a, int b) => a < b ? a : b;

  // 取最大值
  int max(int a, int b) => a > b ? a : b;
}
