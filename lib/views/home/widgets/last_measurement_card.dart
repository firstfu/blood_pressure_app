/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 首頁最近測量記錄卡片組件 - 顯示最近一次血壓測量記錄
 */

import 'package:flutter/material.dart';
import '../../../models/blood_pressure_record.dart';
import '../../../utils/date_time_utils.dart';
import '../../../l10n/app_localizations_extension.dart';

class LastMeasurementCard extends StatelessWidget {
  final BloodPressureRecord record;

  const LastMeasurementCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isBPHigh = record.systolic >= 140 || record.diastolic >= 90;
    final isBPNormal = record.systolic < 120 && record.diastolic < 80;

    // 使用 ColorScheme 中的顏色
    final statusColor = isBPHigh ? colorScheme.error : (isBPNormal ? colorScheme.primary : Colors.orange);
    final statusText = isBPHigh ? context.tr('偏高') : (isBPNormal ? context.tr('正常') : context.tr('臨界'));

    // 獲取心率狀態顏色
    final pulseColor = _getPulseStatusColor(context, record.pulse);

    // 根據血壓狀態選擇圖標
    IconData statusIcon;
    if (isBPHigh) {
      statusIcon = Icons.warning_amber_rounded;
    } else if (isBPNormal) {
      statusIcon = Icons.check_circle_outline;
    } else {
      statusIcon = Icons.info_outline;
    }

    return Card(
      elevation: 1,
      shadowColor: theme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateTimeUtils.getRelativeTimeDescription(context, record.measureTime), style: theme.textTheme.bodyMedium),
                GestureDetector(
                  onTap: () {
                    if (statusText == context.tr('臨界')) {
                      _showBorderlineExplanation(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: statusColor.withAlpha(26), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 16),
                        const SizedBox(width: 4),
                        Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14)),
                        if (statusText == context.tr('臨界')) ...[const SizedBox(width: 4), Icon(Icons.help_outline, color: statusColor, size: 14)],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBPValueColumn(
                  context,
                  record.systolic.toString(),
                  'SYS',
                  'mmHg',
                  isBPHigh ? (record.systolic >= 140 ? colorScheme.error : Colors.orange) : theme.textTheme.titleLarge!.color!,
                ),
                Container(height: 50, width: 1, color: theme.dividerColor),
                _buildBPValueColumn(
                  context,
                  record.diastolic.toString(),
                  'DIA',
                  'mmHg',
                  isBPHigh ? (record.diastolic >= 90 ? colorScheme.error : Colors.orange) : theme.textTheme.titleLarge!.color!,
                ),
                Container(height: 50, width: 1, color: theme.dividerColor),
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          record.pulse.toString(),
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: pulseColor, fontSize: 36),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, top: 4),
                          child: Icon(
                            record.pulse > 100 ? Icons.arrow_upward : (record.pulse < 60 ? Icons.arrow_downward : Icons.favorite),
                            color: pulseColor,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('PULSE', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('bpm', style: theme.textTheme.bodySmall),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: pulseColor.withAlpha(26), borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            _getPulseStatusText(context, record.pulse),
                            style: TextStyle(color: pulseColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: theme.dividerColor, height: 1),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (record.position.isNotEmpty) _buildInfoChip(context, context.tr(record.position)),
                if (record.arm.isNotEmpty) _buildInfoChip(context, context.tr(record.arm)),
                if (record.isMedicated) _buildInfoChip(context, context.tr('測量前是否服用降壓藥物')),
                if (record.note != null && record.note!.isNotEmpty) _buildInfoChip(context, '${context.tr('備註')}: ${record.note}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBPValueColumn(BuildContext context, String value, String label, String unit, Color valueColor) {
    final theme = Theme.of(context);

    // 根據數值顏色選擇適當的圖標
    IconData? valueIcon;
    if (valueColor == theme.colorScheme.error) {
      valueIcon = Icons.arrow_upward;
    } else if (valueColor == Colors.orange) {
      valueIcon = Icons.arrow_upward;
    } else if (valueColor == theme.colorScheme.primary) {
      valueIcon = Icons.check;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: valueColor, fontSize: 36)),
            if (valueIcon != null) Padding(padding: const EdgeInsets.only(left: 2, top: 4), child: Icon(valueIcon, color: valueColor, size: 16)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        Text(unit, style: theme.textTheme.bodySmall),
      ],
    );
  }

  // 獲取心率狀態顏色
  Color _getPulseStatusColor(BuildContext context, int pulse) {
    final theme = Theme.of(context);

    if (pulse < 60) {
      return Colors.blue; // 心率過低
    } else if (pulse > 100) {
      return theme.colorScheme.error; // 心率過高
    } else {
      return theme.colorScheme.primary; // 心率正常
    }
  }

  // 獲取心率狀態文字
  String _getPulseStatusText(BuildContext context, int pulse) {
    if (pulse < 60) {
      return context.tr('偏低');
    } else if (pulse > 100) {
      return context.tr('偏高');
    } else {
      return context.tr('正常');
    }
  }

  Widget _buildInfoChip(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: Text(text, style: theme.textTheme.bodySmall),
    );
  }

  // 顯示臨界狀態的解釋
  void _showBorderlineExplanation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('什麼是臨界血壓？'), style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('臨界血壓是指血壓值處於正常值和高血壓之間的狀態：'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              const SizedBox(height: 8),
              Text(context.tr('• 收縮壓在 120-139 mmHg 之間'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              Text(context.tr('• 舒張壓在 80-89 mmHg 之間'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              const SizedBox(height: 12),
              Text(context.tr('處於臨界狀態時，雖然尚未達到高血壓標準，但已有發展為高血壓的風險。建議：'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              const SizedBox(height: 8),
              Text(context.tr('• 定期監測血壓變化'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              Text(context.tr('• 保持健康的生活方式'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              Text(context.tr('• 適當控制鹽分攝入'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              Text(context.tr('• 規律運動'), style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.tr('了解了'), style: TextStyle(color: theme.primaryColor))),
          ],
          backgroundColor: theme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        );
      },
    );
  }
}
