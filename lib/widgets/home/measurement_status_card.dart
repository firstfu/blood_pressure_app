/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 14:32:30
 * @ Description: 血壓記錄 App 首頁測量狀態卡片組件 - 顯示用戶當日測量狀態
 */

import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class MeasurementStatusCard extends StatelessWidget {
  final bool isMeasuredToday;

  const MeasurementStatusCard({super.key, required this.isMeasuredToday});

  @override
  Widget build(BuildContext context) {
    final successColorLight = AppTheme.successColor.withAlpha(20);
    final alertColorLight = AppTheme.alertColor.withAlpha(20);
    final successColorBorder = AppTheme.successColor.withAlpha(77);
    final alertColorBorder = AppTheme.alertColor.withAlpha(77);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isMeasuredToday ? successColorLight : alertColorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isMeasuredToday ? successColorBorder : alertColorBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMeasuredToday ? AppTheme.successColor.withAlpha(38) : AppTheme.alertColor.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isMeasuredToday ? Icons.check_circle : Icons.notifications_none,
              color: isMeasuredToday ? AppTheme.successColor : AppTheme.alertColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMeasuredToday ? '已完成今日測量' : '今日尚未測量',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: isMeasuredToday ? AppTheme.successColor : AppTheme.alertColor),
                ),
                if (!isMeasuredToday)
                  Text('建議每日測量血壓以保持健康追蹤', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
