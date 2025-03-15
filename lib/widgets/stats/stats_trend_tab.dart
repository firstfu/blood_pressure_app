/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 10:20:15
 * @ Description: 血壓記錄 App 趨勢圖標籤頁組件 - 顯示血壓和心率的趨勢圖
 */

import 'package:flutter/material.dart';
import '../../models/blood_pressure_record.dart';
import '../../themes/app_theme.dart';
import '../../widgets/charts/trend_chart.dart';
import '../../widgets/charts/bar_chart.dart';
import '../../widgets/charts/bp_category_pie_chart.dart';
import '../../widgets/stats/statistics_card.dart';
import '../../services/mock_data_service.dart';

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
    return Card(
      elevation: 2,
      shadowColor: AppTheme.primaryColor.withAlpha(77),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題行
            Row(
              children: [
                Container(width: 4, height: 20, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text('最近2週趨勢', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 12),
            // 控制項行 - 移到下一行以避免水平溢出
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 圖表類型切換
                SegmentedButton<ChartType>(
                  segments: const [
                    ButtonSegment<ChartType>(
                      value: ChartType.line,
                      icon: Icon(Icons.show_chart, size: 16),
                      label: Text('折線圖', style: TextStyle(fontSize: 12)),
                    ),
                    ButtonSegment<ChartType>(
                      value: ChartType.bar,
                      icon: Icon(Icons.bar_chart, size: 16),
                      label: Text('長條圖', style: TextStyle(fontSize: 12)),
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
                const SizedBox(width: 16),
                // 在兩種圖表模式下都顯示心率切換
                Text('顯示心率', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                const SizedBox(width: 8),
                Switch(
                  value: _showPulse,
                  onChanged: (value) {
                    setState(() {
                      _showPulse = value;
                    });
                  },
                  activeColor: Colors.orange,
                ),
              ],
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
    if (widget.records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline_outlined, size: 48, color: AppTheme.textSecondaryColor.withAlpha(128)),
            const SizedBox(height: 16),
            Text('暫無數據', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondaryColor.withAlpha(179))),
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
    return Card(
      elevation: 2,
      shadowColor: AppTheme.primaryColor.withAlpha(77),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 4, height: 20, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text('血壓分類統計', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
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
