/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 10:18:20
 * @ Description: 血壓記錄 App 統計數據卡片組件 - 顯示血壓和心率的統計數據
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/blood_pressure_record.dart';
import '../../themes/app_theme.dart';
import '../../services/mock_data_service.dart';
import '../../l10n/app_localizations_extension.dart';

class StatisticsCard extends StatelessWidget {
  final List<BloodPressureRecord> records;
  final TimeRange selectedTimeRange;
  final DateTime? startDate;
  final DateTime? endDate;

  const StatisticsCard({super.key, required this.records, required this.selectedTimeRange, this.startDate, this.endDate});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Card(
        elevation: 2,
        shadowColor: AppTheme.primaryColor.withAlpha(77),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(child: Text(context.tr('暫無數據'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey))),
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
                Text(context.tr('統計數據'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatRow(context, context.tr('平均收縮壓'), '$avgSystolic mmHg', AppTheme.primaryColor),
            _buildStatRow(context, context.tr('平均舒張壓'), '$avgDiastolic mmHg', AppTheme.successColor),
            _buildStatRow(context, context.tr('平均心率'), '$avgPulse bpm', Colors.orange),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
            _buildStatRow(context, context.tr('最高收縮壓'), '$maxSystolic mmHg', AppTheme.primaryColor),
            _buildStatRow(context, context.tr('最低收縮壓'), '$minSystolic mmHg', AppTheme.primaryColor),
            _buildStatRow(context, context.tr('最高舒張壓'), '$maxDiastolic mmHg', AppTheme.successColor),
            _buildStatRow(context, context.tr('最低舒張壓'), '$minDiastolic mmHg', AppTheme.successColor),
            _buildStatRow(context, context.tr('最高心率'), '$maxPulse bpm', Colors.orange),
            _buildStatRow(context, context.tr('最低心率'), '$minPulse bpm', Colors.orange),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
            _buildStatRow(context, context.tr('記錄總數'), '${records.length} 筆', Colors.grey[700]!),
            _buildStatRow(context, context.tr('記錄時間範圍'), _getTimeRangeText(context), Colors.grey[700]!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 15, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
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
          return '${dateFormat.format(startDate!)} 至 ${dateFormat.format(endDate!)}';
        }
        return context.tr('自定義日期範圍');
    }
  }
}
