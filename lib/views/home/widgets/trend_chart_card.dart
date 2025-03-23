/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 首頁趨勢圖卡片組件 - 顯示血壓和心率趨勢圖
 */

import 'package:flutter/material.dart';
import '../../../models/blood_pressure_record.dart';
// import '../../../themes/app_theme.dart'; // 移除不必要的引用
import '../../../widgets/charts/trend_chart.dart';
import '../../../widgets/charts/bar_chart.dart';
import '../../../services/mock_data_service.dart';
import '../../../l10n/app_localizations_extension.dart';

// 圖表類型枚舉
enum ChartType {
  line, // 折線圖
  bar, // 長條圖
}

class TrendChartCard extends StatefulWidget {
  final List<BloodPressureRecord> records;
  final TimeRange selectedTimeRange;
  final VoidCallback onViewDetails;

  const TrendChartCard({super.key, required this.records, required this.selectedTimeRange, required this.onViewDetails});

  @override
  State<TrendChartCard> createState() => _TrendChartCardState();
}

class _TrendChartCardState extends State<TrendChartCard> {
  bool _showPulse = true; // 默認顯示心率
  ChartType _chartType = ChartType.line; // 默認顯示折線圖

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: theme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // 控制項行 - 使用 Wrap 避免水平溢出
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // 圖表類型切換
                SegmentedButton<ChartType>(
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
                // 在兩種圖表模式下都顯示心率切換
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.tr('顯示心率'), style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 13)),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _showPulse,
                        onChanged: (value) {
                          setState(() {
                            _showPulse = value;
                          });
                        },
                        activeColor: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 220, padding: const EdgeInsets.only(top: 8), child: _buildChart()),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Wrap(spacing: 16, runSpacing: 8, children: _buildLegendItems())),
                TextButton(
                  onPressed: widget.onViewDetails,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(context.tr('查看詳情')), const SizedBox(width: 4), const Icon(Icons.arrow_forward, size: 16)],
                  ),
                ),
              ],
            ),
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

  // 構建圖例項目
  List<Widget> _buildLegendItems() {
    final theme = Theme.of(context);
    final List<Widget> items = [];

    // 定義顏色
    final systolicColor = theme.primaryColor;
    final diastolicColor = theme.colorScheme.secondary;
    final pulseColor = theme.colorScheme.tertiary;

    // 折線圖和長條圖使用相同的圖例
    items.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: systolicColor, borderRadius: BorderRadius.circular(6))),
          const SizedBox(width: 4),
          Text(context.tr('收縮壓'), style: theme.textTheme.bodySmall),
        ],
      ),
    );

    items.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: diastolicColor, borderRadius: BorderRadius.circular(6))),
          const SizedBox(width: 4),
          Text(context.tr('舒張壓'), style: theme.textTheme.bodySmall),
        ],
      ),
    );

    if (_showPulse) {
      items.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: pulseColor, borderRadius: BorderRadius.circular(6))),
            const SizedBox(width: 4),
            Text(context.tr('心率'), style: theme.textTheme.bodySmall),
          ],
        ),
      );
    }

    return items;
  }
}
