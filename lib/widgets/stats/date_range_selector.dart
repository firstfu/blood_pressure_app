/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 日期範圍選擇器組件 - 用於選擇自定義日期範圍
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    // 獲取當前日期
    final now = DateTime.now();

    // 設置初始日期
    DateTime initialDate;
    if (isStartDate) {
      initialDate = startDate ?? now.subtract(const Duration(days: 30));
    } else {
      initialDate = endDate ?? now;
    }

    // 確保初始日期不超過當前日期
    if (initialDate.isAfter(now)) {
      initialDate = now;
    }

    // 設置最小日期
    final DateTime firstDate = DateTime(2020);

    // 設置最大日期
    final DateTime lastDate = now;

    // 用於保存選擇的日期
    DateTime? pickedDate = initialDate;

    // 顯示日期選擇器
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(context.tr('取消')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: Text(context.tr('確定')),
                    onPressed: () {
                      Navigator.of(context).pop(pickedDate);
                    },
                  ),
                ],
              ),
              const Divider(height: 0),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  minimumDate: firstDate,
                  maximumDate: lastDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    pickedDate = newDate;
                    print('選擇的日期: ${newDate.toString()}');
                  },
                  dateOrder: DatePickerDateOrder.ymd,
                  use24hFormat: true,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        print('返回的日期: ${value.toString()}');
        if (isStartDate) {
          onStartDateChanged(value);
          // 如果開始日期晚於結束日期，或結束日期未設置，則將結束日期設為開始日期
          if (endDate == null || value.isAfter(endDate!)) {
            onEndDateChanged(value);
          }
        } else {
          onEndDateChanged(value);
          // 如果結束日期早於開始日期，或開始日期未設置，則將開始日期設為結束日期
          if (startDate == null || value.isBefore(startDate!)) {
            onStartDateChanged(value);
          }
        }
      }
    });
  }
}
