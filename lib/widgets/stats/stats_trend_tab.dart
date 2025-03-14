/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 10:20:15
 * @ Description: 血壓記錄 App 趨勢圖標籤頁組件 - 顯示血壓和心率的趨勢圖
 */

import 'package:flutter/material.dart';
import '../../models/blood_pressure_record.dart';
import '../../themes/app_theme.dart';
import '../../widgets/trend_chart.dart';
import '../../widgets/bp_category_pie_chart.dart';
import '../../widgets/stats/statistics_card.dart';
import '../../services/mock_data_service.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 4, height: 20, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text('血壓趨勢', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                // 添加心率顯示切換
                Row(
                  children: [
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
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(height: 250, child: TrendChart(records: widget.records, showPulse: _showPulse)),
          ],
        ),
      ),
    );
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
