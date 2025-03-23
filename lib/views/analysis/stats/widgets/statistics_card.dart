/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-16 10:18:20
 * @ Description: 血壓記錄 App 統計數據卡片組件 - 顯示血壓和心率的統計數據
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/blood_pressure_record.dart';
import '../../../../themes/app_theme.dart';
import '../../../../services/mock_data_service.dart';
import '../../../../l10n/app_localizations_extension.dart';

class StatisticsCard extends StatelessWidget {
  final List<BloodPressureRecord> records;
  final TimeRange selectedTimeRange;
  final DateTime? startDate;
  final DateTime? endDate;

  const StatisticsCard({super.key, required this.records, required this.selectedTimeRange, this.startDate, this.endDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (records.isEmpty) {
      return Card(
        elevation: 3,
        shadowColor: theme.primaryColor.withAlpha(100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDarkMode ? BorderSide(color: Colors.white.withAlpha(51), width: 1) : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bar_chart_outlined, size: 48, color: theme.disabledColor),
                const SizedBox(height: 16),
                Text(context.tr('暫無數據'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: theme.disabledColor)),
              ],
            ),
          ),
        ),
      );
    }

    final avgSystolic = records.map((e) => e.systolic).reduce((a, b) => a + b) ~/ records.length;
    final avgDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a + b) ~/ records.length;
    final avgPulse = records.map((e) => e.pulse).reduce((a, b) => a + b) ~/ records.length;

    final maxSystolic = records.map((e) => e.systolic).reduce((a, b) => a > b ? a : b);
    final minSystolic = records.map((e) => e.systolic).reduce((a, b) => a < b ? a : b);
    final maxDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a > b ? a : b);
    final minDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a < b ? a : b);
    final maxPulse = records.map((e) => e.pulse).reduce((a, b) => a > b ? a : b);
    final minPulse = records.map((e) => e.pulse).reduce((a, b) => a < b ? a : b);

    // 獲取「筆」的翻譯
    final recordUnit = context.tr('筆');

    return Card(
      elevation: 3,
      shadowColor: theme.primaryColor.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isDarkMode ? BorderSide(color: Colors.white.withAlpha(51), width: 1) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題區域
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1.5))),
              child: Row(
                children: [
                  Container(width: 4, height: 24, decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      context.tr('統計數據'),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 平均值區塊
            _buildSectionTitle(context, context.tr('平均值')),
            const SizedBox(height: 12),
            SizedBox(
              height: 150, // 增加高度以避免溢出
              child: _buildStatsGrid(context, [
                StatsItem(label: context.tr('平均收縮壓'), value: '$avgSystolic', unit: 'mmHg', color: theme.primaryColor, icon: Icons.arrow_upward),
                StatsItem(label: context.tr('平均舒張壓'), value: '$avgDiastolic', unit: 'mmHg', color: AppTheme.successColor, icon: Icons.arrow_downward),
                StatsItem(label: context.tr('平均心率'), value: '$avgPulse', unit: 'bpm', color: Colors.orange, icon: Icons.favorite),
              ]),
            ),

            const SizedBox(height: 24),

            // 最大最小值區塊
            _buildSectionTitle(context, context.tr('最高/最低值')),
            const SizedBox(height: 12),

            // 收縮壓
            _buildMinMaxRow(
              context,
              title: context.tr('收縮壓'),
              minValue: '$minSystolic',
              maxValue: '$maxSystolic',
              unit: 'mmHg',
              color: theme.primaryColor,
              icon: Icons.arrow_upward,
            ),
            const SizedBox(height: 16),

            // 舒張壓
            _buildMinMaxRow(
              context,
              title: context.tr('舒張壓'),
              minValue: '$minDiastolic',
              maxValue: '$maxDiastolic',
              unit: 'mmHg',
              color: AppTheme.successColor,
              icon: Icons.arrow_downward,
            ),
            const SizedBox(height: 16),

            // 心率
            _buildMinMaxRow(
              context,
              title: context.tr('心率'),
              minValue: '$minPulse',
              maxValue: '$maxPulse',
              unit: 'bpm',
              color: Colors.orange,
              icon: Icons.favorite,
            ),

            const SizedBox(height: 24),

            // 記錄信息區塊
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? theme.cardColor.withAlpha(77) : theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context, icon: Icons.format_list_numbered, label: context.tr('記錄總數'), value: '${records.length} $recordUnit'),
                  const SizedBox(height: 16),
                  _buildInfoRow(context, icon: Icons.date_range, label: context.tr('記錄時間範圍'), value: _getTimeRangeText(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Flexible(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color))),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: theme.dividerColor)),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, List<StatsItem> items) {
    return Row(children: items.map((item) => Expanded(child: _buildStatCard(context, item))).toList());
  }

  Widget _buildStatCard(BuildContext context, StatsItem item) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: item.color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.color.withAlpha(77)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: item.color, size: 22),
          const SizedBox(height: 6),
          Text(item.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: item.color)),
          Text(item.unit, style: TextStyle(fontSize: 12, color: item.color.withAlpha(204))),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(item.label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color)),
          ),
        ],
      ),
    );
  }

  Widget _buildMinMaxRow(
    BuildContext context, {
    required String title,
    required String minValue,
    required String maxValue,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
        border: isDarkMode ? Border.all(color: Colors.white.withAlpha(51), width: 1.0) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Flexible(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(context.tr('最低值'), style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: minValue, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color.withAlpha(204))),
                          TextSpan(text: ' $unit', style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
                        ],
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Container(height: 40, width: 1, color: theme.dividerColor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(context.tr('最高值'), style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: maxValue, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                          TextSpan(text: ' $unit', style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
                        ],
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: theme.textTheme.bodySmall?.color),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 4),
          child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color), softWrap: true),
        ),
      ],
    );
  }

  String _getTimeRangeText(BuildContext context) {
    switch (selectedTimeRange) {
      case TimeRange.week:
        return context.tr('最近 7 天');
      case TimeRange.twoWeeks:
        return context.tr('最近 2 週');
      case TimeRange.month:
        return context.tr('最近 1 個月');
      case TimeRange.custom:
        if (startDate != null && endDate != null) {
          final dateFormat = DateFormat('yyyy/MM/dd');
          return '${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}';
        }
        return context.tr('自定義日期範圍');
    }
  }
}

// 統計項目數據模型
class StatsItem {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  StatsItem({required this.label, required this.value, required this.unit, required this.color, required this.icon});
}
