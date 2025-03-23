/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-16 10:20:15
 * @ Description: 血壓記錄 App 趨勢圖標籤頁組件 - 顯示血壓和心率的趨勢圖
 */

import 'package:flutter/material.dart';
import '../../../../models/blood_pressure_record.dart';
import '../../../../widgets/charts/trend_chart.dart';
import '../../../../widgets/charts/bar_chart.dart';
import '../../../../widgets/charts/bp_category_pie_chart.dart';
import 'statistics_card.dart';
import '../../../../services/mock_data_service.dart';
import '../../../../l10n/app_localizations_extension.dart';

// 圖表類型枚舉
enum ChartType {
  line, // 折線圖
  bar, // 長條圖
}

class StatsTrendTab extends StatefulWidget {
  final List<BloodPressureRecord> records;
  final TimeRange selectedTimeRange;
  final DateTime? startDate;
  final DateTime? endDate;

  const StatsTrendTab({super.key, required this.records, required this.selectedTimeRange, this.startDate, this.endDate});

  @override
  State<StatsTrendTab> createState() => _StatsTrendTabState();
}

class _StatsTrendTabState extends State<StatsTrendTab> {
  bool _showPulse = true; // 默認顯示心率
  ChartType _chartType = ChartType.line; // 默認顯示折線圖

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBloodPressureTrendCard(),
          const SizedBox(height: 16),
          _buildBloodPressureCategoryCard(),
          const SizedBox(height: 16),
          StatisticsCard(records: widget.records, selectedTimeRange: widget.selectedTimeRange, startDate: widget.startDate, endDate: widget.endDate),
        ],
      ),
    );
  }

  Widget _buildBloodPressureTrendCard() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shadowColor: theme.primaryColor.withAlpha(77),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDarkMode ? BorderSide(color: Colors.white.withAlpha(51), width: 1) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 4, height: 20, decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(context.tr('近 2 週趨勢'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                // 心率切換開關
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.tr('顯示心率'), style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 14)),
                    const SizedBox(width: 4),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _showPulse,
                        onChanged: (value) {
                          setState(() {
                            _showPulse = value;
                          });
                        },
                        activeColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 圖表類型切換 - 單獨一行
            Align(
              alignment: Alignment.centerRight,
              child: SegmentedButton<ChartType>(
                segments: [
                  ButtonSegment<ChartType>(
                    value: ChartType.line,
                    icon: const Icon(Icons.show_chart, size: 16),
                    label: Text(context.tr('折線圖'), style: const TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment<ChartType>(
                    value: ChartType.bar,
                    icon: const Icon(Icons.bar_chart, size: 16),
                    label: Text(context.tr('長條圖'), style: const TextStyle(fontSize: 12)),
                  ),
                ],
                selected: {_chartType},
                onSelectionChanged: (Set<ChartType> newSelection) {
                  setState(() {
                    _chartType = newSelection.first;
                  });
                },
                style: ButtonStyle(visualDensity: VisualDensity.compact, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 250, child: _buildChart()),
          ],
        ),
      ),
    );
  }

  // 根據選擇的圖表類型構建對應的圖表
  Widget _buildChart() {
    final theme = Theme.of(context);

    if (widget.records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline_outlined, size: 48, color: theme.textTheme.bodySmall?.color?.withAlpha(128)),
            const SizedBox(height: 16),
            Text(context.tr('暫無數據'), style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodySmall?.color?.withAlpha(179))),
          ],
        ),
      );
    }

    switch (_chartType) {
      case ChartType.line:
        return TrendChart(records: widget.records, showPulse: _showPulse);
      case ChartType.bar:
        return BloodPressureBarChart(records: widget.records, showPulse: _showPulse);
    }
  }

  Widget _buildBloodPressureCategoryCard() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shadowColor: theme.primaryColor.withAlpha(77),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDarkMode ? BorderSide(color: Colors.white.withAlpha(51), width: 1) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 4, height: 20, decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text(context.tr('血壓分類統計'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            BPCategoryPieChart(records: widget.records),
          ],
        ),
      ),
    );
  }
}
