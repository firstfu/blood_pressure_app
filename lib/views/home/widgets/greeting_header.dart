/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 首頁問候頭部組件 - 顯示用戶問候語和當前日期
 */

import 'package:flutter/material.dart';
import '../../../utils/date_time_utils.dart';
// import '../../../themes/app_theme.dart'; // 移除不必要的引用
import '../../../l10n/app_localizations_extension.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = DateTimeUtils.getGreeting(context);
    final currentDate = DateTimeUtils.getFullCurrentDate(context);
    final theme = Theme.of(context);
    // 獲取狀態欄高度
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // 為較小螢幕設備增加額外的頂部間距
    final double topPadding = statusBarHeight + 16; // 增加到至少 16 的間距

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 12),
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark
                ? const Color(0xFF121212) // 深色模式使用標準深灰色
                : theme.primaryColor,
        boxShadow: [BoxShadow(color: theme.shadowColor.withAlpha(20), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting，${context.tr('用戶')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white)),
          const SizedBox(height: 4),
          Text(currentDate, style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 15)),
        ],
      ),
    );
  }
}
