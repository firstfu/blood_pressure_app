/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 10:15:30
 * @ Description: 血壓記錄 App 時間範圍選擇器組件 - 用於選擇統計數據的時間範圍
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_theme.dart';
import '../../services/mock_data_service.dart';

class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedTimeRange;
  final Function(TimeRange) onTimeRangeChanged;

  const TimeRangeSelector({super.key, required this.selectedTimeRange, required this.onTimeRangeChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeRangeButton(context, TimeRange.week, '7天'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.twoWeeks, '2週'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.month, '1月'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.custom, '自訂'),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(BuildContext context, TimeRange timeRange, String label) {
    final isSelected = selectedTimeRange == timeRange;

    return GestureDetector(
      onTap: () {
        if (selectedTimeRange != timeRange) {
          HapticFeedback.lightImpact();
          onTimeRangeChanged(timeRange);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor, width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withAlpha(77), blurRadius: 8, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
