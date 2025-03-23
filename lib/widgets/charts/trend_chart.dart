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
    final tertiaryColor = theme.colorScheme.tertiary; // 定義第三色調，用於心率
    final pulseColor = Colors.orange; // 新增心率顏色定義，與長條圖保持一致

    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline_outlined, size: 48, color: theme.textTheme.bodyMedium?.color?.withAlpha(128)),
            const SizedBox(height: 16),
            Text(context.tr('暫無數據'), style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodyMedium?.color?.withAlpha(179))),
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
    final cardColor = theme.cardColor;

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
              return FlLine(color: dividerColor.withAlpha(128), strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: dividerColor.withAlpha(128), strokeWidth: 1);
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
              tooltipBgColor: cardColor,
              tooltipRoundedRadius: 8,
              tooltipBorder: BorderSide(color: primaryColor.withAlpha(51), width: 1),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              maxContentWidth: 160,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final record = sortedRecords[barSpot.x.toInt()];
                  String title;
                  int value;
                  Color color;

                  if (barSpot.barIndex == 0) {
                    title = context.tr("SYS");
                    value = record.systolic;
                    color = primaryColor;
                  } else if (barSpot.barIndex == 1) {
                    title = context.tr("DIA");
                    value = record.diastolic;
                    color = secondaryColor;
                  } else {
                    title = context.tr("PULSE");
                    value = record.pulse;
                    color = pulseColor;
                  }

                  final date = DateTimeUtils.formatDateMMDD(record.measureTime);
                  final time = DateTimeUtils.formatTimeHHMM(record.measureTime);
                  final unit = barSpot.barIndex == 2 ? context.tr("bpm") : context.tr("mmHg");

                  return LineTooltipItem(
                    '$title: $value $unit',
                    TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                    textAlign: TextAlign.left,
                    children: [
                      TextSpan(
                        text: '\n$date $time',
                        style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 10, fontWeight: FontWeight.normal),
                      ),
                    ],
                  );
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
                    (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: cardColor, strokeWidth: 2, strokeColor: primaryColor),
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
                    (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: cardColor, strokeWidth: 2, strokeColor: secondaryColor),
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
            // 心率線
            if (showPulse)
              LineChartBarData(
                spots: _getPulseSpots(sortedRecords),
                isCurved: true,
                color: pulseColor,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, barData) {
                    // 根據記錄數量決定是否顯示所有點
                    return records.length <= 14 || spot.x.toInt() % interval.toInt() == 0;
                  },
                  getDotPainter:
                      (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: cardColor, strokeWidth: 2, strokeColor: pulseColor),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: pulseColor.withAlpha(26),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [pulseColor.withAlpha(51), pulseColor.withAlpha(13)],
                  ),
                ),
              ),
          ],
          // 標記線
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              // 收縮壓正常範圍上限線
              HorizontalLine(
                y: 120,
                color: primaryColor.withAlpha(102),
                strokeWidth: 1,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 10),
                  labelResolver: (line) => context.tr('正常上限'),
                  alignment: Alignment.topRight,
                ),
              ),
              // 高血壓一期線
              HorizontalLine(
                y: 140,
                color: theme.colorScheme.error.withAlpha(102),
                strokeWidth: 1,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 10),
                  labelResolver: (line) => context.tr('高血壓'),
                  alignment: Alignment.topRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 計算顯示間隔
  double _calculateInterval(int recordCount) {
    if (recordCount <= 7) {
      return 1;
    } else if (recordCount <= 14) {
      return 2;
    } else {
      return (recordCount / 7).ceil().toDouble();
    }
  }

  // 獲取收縮壓點
  List<FlSpot> _getSystolicSpots(List<BloodPressureRecord> records) {
    return records.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble())).toList();
  }

  // 獲取舒張壓點
  List<FlSpot> _getDiastolicSpots(List<BloodPressureRecord> records) {
    return records.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble())).toList();
  }

  // 獲取心率點
  List<FlSpot> _getPulseSpots(List<BloodPressureRecord> records) {
    return records.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.pulse.toDouble())).toList();
  }

  // 獲取Y軸最小值
  double _getMinY() {
    if (records.isEmpty) return 40;

    final minSystolic = records.map((r) => r.systolic).reduce((a, b) => a < b ? a : b).toDouble() - 10;
    final minDiastolic = records.map((r) => r.diastolic).reduce((a, b) => a < b ? a : b).toDouble() - 10;
    final minPulse = showPulse ? records.map((r) => r.pulse).reduce((a, b) => a < b ? a : b).toDouble() - 10 : double.infinity;

    return [minSystolic, minDiastolic, minPulse, 40].reduce((a, b) => a < b ? a : b).toDouble();
  }

  // 獲取Y軸最大值
  double _getMaxY() {
    if (records.isEmpty) return 180;

    final maxSystolic = records.map((r) => r.systolic).reduce((a, b) => a > b ? a : b).toDouble() + 10;
    final maxDiastolic = records.map((r) => r.diastolic).reduce((a, b) => a > b ? a : b).toDouble() + 10;
    final maxPulse = showPulse ? records.map((r) => r.pulse).reduce((a, b) => a > b ? a : b).toDouble() + 10 : 0;

    return [maxSystolic, maxDiastolic, maxPulse, 180].reduce((a, b) => a > b ? a : b).toDouble();
  }
}
