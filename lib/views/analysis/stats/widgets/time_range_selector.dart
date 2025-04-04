/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-16 10:15:30
 * @ Description: 血壓記錄 App 時間範圍選擇器組件 - 用於選擇統計數據的時間範圍
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/mock_data_service.dart';
import '../../../../l10n/app_localizations_extension.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedTimeRange;
  final Function(TimeRange) onTimeRangeChanged;

  const TimeRangeSelector({super.key, required this.selectedTimeRange, required this.onTimeRangeChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2))],
        border: isDarkMode ? Border(bottom: BorderSide(color: Colors.white.withAlpha(38), width: 0.5)) : null,
      ),
      child: Row(
        children: [
          Expanded(child: _buildTimeRangeButton(context, TimeRange.week, context.tr('7天'))),
          const SizedBox(width: 8),
          Expanded(child: _buildTimeRangeButton(context, TimeRange.twoWeeks, context.tr('2週'))),
          const SizedBox(width: 8),
          Expanded(child: _buildTimeRangeButton(context, TimeRange.month, context.tr('1月'))),
          const SizedBox(width: 8),
          Expanded(child: _buildTimeRangeButton(context, TimeRange.custom, context.tr('自訂'))),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(BuildContext context, TimeRange timeRange, String label) {
    final theme = Theme.of(context);
    final isSelected = selectedTimeRange == timeRange;
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (selectedTimeRange != timeRange) {
          HapticFeedback.lightImpact();
          onTimeRangeChanged(timeRange);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? theme.primaryColor : (isDarkMode ? Colors.white.withAlpha(51) : theme.dividerColor), width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: theme.primaryColor.withAlpha(77), blurRadius: 8, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
