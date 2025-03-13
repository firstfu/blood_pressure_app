// 血壓記錄 App 日期時間工具類
// 提供日期時間相關的功能

import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateTimeUtils {
  // 獲取當前日期的格式化字符串
  static String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy 年 MM 月 dd 日');
    return formatter.format(now);
  }

  // 獲取當前日期的星期幾
  static String getCurrentWeekday() {
    final now = DateTime.now();
    final weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return weekdays[now.weekday - 1];
  }

  // 獲取完整的當前日期和星期
  static String getFullCurrentDate() {
    return '${getCurrentDate()} ${getCurrentWeekday()}';
  }

  // 根據時間獲取問候語
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return AppConstants.morningGreeting;
    } else if (hour >= 12 && hour < 18) {
      return AppConstants.afternoonGreeting;
    } else {
      return AppConstants.eveningGreeting;
    }
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
  static String getRelativeTimeDescription(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = today.difference(targetDate).inDays;

    if (difference == 0) {
      return '今天 ${formatTimeHHMM(dateTime)}';
    } else if (difference == 1) {
      return '昨天 ${formatTimeHHMM(dateTime)}';
    } else if (difference == 2) {
      return '前天 ${formatTimeHHMM(dateTime)}';
    } else {
      return formatFullDateTime(dateTime);
    }
  }
}
