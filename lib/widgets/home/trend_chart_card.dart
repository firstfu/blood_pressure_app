/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 14:40:30
 * @ Description: 血壓記錄 App 首頁趨勢圖卡片組件 - 顯示血壓和心率趨勢圖
 */

import 'package:flutter/material.dart';
import '../../models/blood_pressure_record.dart';
import '../../themes/app_theme.dart';
import '../../widgets/trend_chart.dart';
import '../../services/mock_data_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: AppTheme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_getTrendTitle(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Text('顯示心率', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13)),
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
            const SizedBox(height: 8),
            Container(height: 220, padding: const EdgeInsets.only(top: 8), child: TrendChart(records: widget.records, showPulse: _showPulse)),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(6)),
                          ),
                          const SizedBox(width: 4),
                          Text('收縮壓', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: AppTheme.successColor, borderRadius: BorderRadius.circular(6)),
                          ),
                          const SizedBox(width: 4),
                          Text('舒張壓', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(6))),
                          const SizedBox(width: 4),
                          Text('心率', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: widget.onViewDetails,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('查看詳情'), const SizedBox(width: 4), const Icon(Icons.arrow_forward, size: 16)],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 根據選擇的時間範圍獲取標題
  String _getTrendTitle() {
    switch (widget.selectedTimeRange) {
      case TimeRange.week:
        return '最近7天趨勢';
      case TimeRange.twoWeeks:
        return '最近2週趨勢';
      case TimeRange.month:
        return '最近1個月趨勢';
      default:
        return '血壓趨勢';
    }
  }
}
