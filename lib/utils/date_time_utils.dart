// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓記錄 App 日期時間工具類，提供日期時間相關的功能

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

class DateTimeUtils {
  // 獲取當前日期的格式化字符串
  static String getCurrentDate(BuildContext? context) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final dateStr = formatter.format(now);

    if (context == null) {
      return '$dateStr';
    }

    final locale = Localizations.localeOf(context);
    final isEnglish = locale.languageCode == 'en';

    if (isEnglish) {
      return dateStr;
    } else {
      final year = now.year;
      final month = now.month;
      final day = now.day;

      final yearText = AppLocalizations.of(context).translate('年');
      final monthText = AppLocalizations.of(context).translate('月');
      final dayText = AppLocalizations.of(context).translate('日');

      return '$year $yearText $month $monthText $day $dayText';
    }
  }

  // 獲取當前日期的星期幾
  static String getCurrentWeekday(BuildContext? context) {
    final now = DateTime.now();

    if (context == null) {
      final weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
      return weekdays[now.weekday - 1];
    }

    final weekdayKey = '星期${_getChineseWeekdayNumber(now.weekday)}';
    return AppLocalizations.of(context).translate(weekdayKey);
  }

  // 獲取中文星期數字
  static String _getChineseWeekdayNumber(int weekday) {
    final numbers = ['一', '二', '三', '四', '五', '六', '日'];
    return numbers[weekday - 1];
  }

  // 獲取完整的當前日期和星期
  static String getFullCurrentDate(BuildContext? context) {
    if (context == null) {
      return '${getCurrentDate(null)} ${getCurrentWeekday(null)}';
    }
    return '${getCurrentDate(context)} ${getCurrentWeekday(context)}';
  }

  // 根據時間獲取問候語
  static String getGreeting(BuildContext? context) {
    final hour = DateTime.now().hour;

    String greetingKey;
    if (hour >= 5 && hour < 12) {
      greetingKey = '早安';
    } else if (hour >= 12 && hour < 18) {
      greetingKey = '午安';
    } else {
      greetingKey = '晚安';
    }

    if (context == null) {
      return greetingKey;
    }

    return AppLocalizations.of(context).translate(greetingKey);
  }

  // 格式化時間為 HH:mm 格式
  static String formatTimeHHMM(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  // 格式化日期為 MM-dd 格式
  static String formatDateMMDD(DateTime dateTime) {
    final formatter = DateFormat('MM-dd');
    return formatter.format(dateTime);
  }

  // 格式化完整日期時間
  static String formatFullDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  // 獲取相對時間描述（今天、昨天、前天或日期）
  static String getRelativeTimeDescription(BuildContext? context, DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = today.difference(targetDate).inDays;

    String todayText = '今天';
    String yesterdayText = '昨天';
    String dayBeforeText = '前天';

    if (context != null) {
      todayText = AppLocalizations.of(context).translate('今天');
      yesterdayText = AppLocalizations.of(context).translate('昨天');
      dayBeforeText = AppLocalizations.of(context).translate('前天');
    }

    if (difference == 0) {
      return '$todayText ${formatTimeHHMM(dateTime)}';
    } else if (difference == 1) {
      return '$yesterdayText ${formatTimeHHMM(dateTime)}';
    } else if (difference == 2) {
      return '$dayBeforeText ${formatTimeHHMM(dateTime)}';
    } else {
      return formatFullDateTime(dateTime);
    }
  }
}
