/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 10:16:45
 * @ Description: 血壓記錄 App 日期範圍選擇器組件 - 用於選擇自定義日期範圍
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../l10n/app_localizations_extension.dart';
import '../../providers/locale_provider.dart';

class DateRangeSelector extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final VoidCallback onSearch;

  const DateRangeSelector({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    // 獲取當前語系，用於強制重新構建
    final locale = Provider.of<LocaleProvider>(context).locale;

    final dateFormat = DateFormat('yyyy/MM/dd');
    final startDateText = startDate != null ? dateFormat.format(startDate!) : context.tr('選擇開始日期');
    final endDateText = endDate != null ? dateFormat.format(endDate!) : context.tr('選擇結束日期');

    // 提前獲取翻譯文本
    final searchText = context.tr('查詢');

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, isStartDate: true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.dividerColor), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          startDateText,
                          style: TextStyle(
                            color: startDate != null ? Colors.black87 : Colors.grey,
                            fontWeight: startDate != null ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(context.tr('至'), style: const TextStyle(color: Colors.grey))),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, isStartDate: false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.dividerColor), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          endDateText,
                          style: TextStyle(
                            color: endDate != null ? Colors.black87 : Colors.grey,
                            fontWeight: endDate != null ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 120.0,
              // 使用 Key 強制重新構建按鈕
              child: ElevatedButton.icon(
                key: ValueKey('search_button_${locale.toString()}'),
                onPressed: startDate != null && endDate != null ? onSearch : null,
                icon: const Icon(Icons.search, size: 18),
                label: Text(searchText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  shadowColor: AppTheme.primaryColor.withAlpha(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final initialDate = isStartDate ? startDate ?? DateTime.now().subtract(const Duration(days: 30)) : endDate ?? DateTime.now();
    final firstDate = isStartDate ? DateTime(2020) : (startDate ?? DateTime(2020));
    final lastDate = isStartDate ? (endDate ?? DateTime.now()) : DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor, onPrimary: Colors.white, onSurface: Colors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (isStartDate) {
        onStartDateChanged(pickedDate);
        // 如果開始日期晚於結束日期，或結束日期未設置，則將結束日期設為開始日期
        if (endDate == null || pickedDate.isAfter(endDate!)) {
          onEndDateChanged(pickedDate);
        }
      } else {
        onEndDateChanged(pickedDate);
        // 如果結束日期早於開始日期，或開始日期未設置，則將開始日期設為結束日期
        if (startDate == null || pickedDate.isBefore(startDate!)) {
          onStartDateChanged(pickedDate);
        }
      }
    }
  }
}
