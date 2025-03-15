// 血壓記錄 App 血壓卡片元件
// 用於顯示血壓記錄

import 'package:flutter/material.dart';
import '../../models/blood_pressure_record.dart';
import '../../utils/date_time_utils.dart';
import '../common/status_badge.dart';

class BloodPressureCard extends StatelessWidget {
  final BloodPressureRecord record;

  const BloodPressureCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = record.getBloodPressureStatus();
    final statusColor = Color(record.getStatusColorCode());

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateTimeUtils.getRelativeTimeDescription(record.measureTime), style: theme.textTheme.bodyMedium),
                StatusBadge(text: status, color: statusColor),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildValueColumn(context, '${record.systolic}', 'SYS', 'mmHg'),
                const SizedBox(width: 8),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                const SizedBox(width: 8),
                _buildValueColumn(context, '${record.diastolic}', 'DIA', 'mmHg'),
                const SizedBox(width: 8),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                const SizedBox(width: 8),
                _buildValueColumn(context, '${record.pulse}', 'PULSE', 'bpm'),
              ],
            ),
            if (record.note != null && record.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('備註: ${record.note}', style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip(context, record.position),
                const SizedBox(width: 8),
                _buildInfoChip(context, record.arm),
                if (record.isMedicated) ...[const SizedBox(width: 8), _buildInfoChip(context, '服藥後')],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn(BuildContext context, String value, String label, String unit) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Text(value, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall),
          Text(unit, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
