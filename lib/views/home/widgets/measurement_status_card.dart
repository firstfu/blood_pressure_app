/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 首頁測量狀態卡片組件 - 顯示用戶當日測量狀態
 */

import 'package:flutter/material.dart';
// import '../../../themes/app_theme.dart'; // 移除不必要的引用
import '../../../l10n/app_localizations_extension.dart';

class MeasurementStatusCard extends StatelessWidget {
  final bool isMeasuredToday;

  const MeasurementStatusCard({super.key, required this.isMeasuredToday});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final successColor = theme.colorScheme.secondary; // 使用主題中的 secondary 作為成功顏色
    final alertColor = theme.colorScheme.error; // 使用主題中的 error 作為警示顏色

    final successColorLight = successColor.withAlpha(20);
    final alertColorLight = alertColor.withAlpha(20);
    final successColorBorder = successColor.withAlpha(77);
    final alertColorBorder = alertColor.withAlpha(77);

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
              color: isMeasuredToday ? successColor.withAlpha(38) : alertColor.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isMeasuredToday ? Icons.check_circle : Icons.notifications_none,
              color: isMeasuredToday ? successColor : alertColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMeasuredToday ? context.tr('已完成今日測量') : context.tr('今日尚未測量'),
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: isMeasuredToday ? successColor : alertColor),
                ),
                if (!isMeasuredToday) Text(context.tr('建議每日測量血壓以保持健康追蹤'), style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
