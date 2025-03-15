/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 首頁時間範圍選擇器組件 - 用於選擇趨勢圖的時間範圍
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_theme.dart';
import '../../services/mock_data_service.dart';
import '../../l10n/app_localizations_extension.dart';

class HomeTimeRangeSelector extends StatelessWidget {
  final TimeRange selectedTimeRange;
  final Function(TimeRange) onTimeRangeChanged;

  const HomeTimeRangeSelector({super.key, required this.selectedTimeRange, required this.onTimeRangeChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeRangeButton(context, TimeRange.week, context.tr('7天')),
          _buildTimeRangeButton(context, TimeRange.twoWeeks, context.tr('2週')),
          _buildTimeRangeButton(context, TimeRange.month, context.tr('1月')),
        ],
      ),
    );
  }

  // 構建時間範圍按鈕
  Widget _buildTimeRangeButton(BuildContext context, TimeRange timeRange, String label) {
    final isSelected = selectedTimeRange == timeRange;

    return GestureDetector(
      onTap: () {
        if (selectedTimeRange != timeRange) {
          HapticFeedback.lightImpact();
          onTimeRangeChanged(timeRange);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? AppTheme.primaryColor : Colors.transparent, borderRadius: BorderRadius.circular(14)),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
