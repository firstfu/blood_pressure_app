/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 首頁問候頭部組件 - 顯示用戶問候語和當前日期
 */

import 'package:flutter/material.dart';
import '../../utils/date_time_utils.dart';
import '../../themes/app_theme.dart';
import '../../l10n/app_localizations_extension.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = DateTimeUtils.getGreeting(context);
    final currentDate = DateTimeUtils.getFullCurrentDate(context);
    // 獲取狀態欄高度
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // 為較小螢幕設備增加額外的頂部間距
    final double topPadding = statusBarHeight + 16; // 增加到至少 16 的間距

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting，${context.tr('用戶')}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(currentDate, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withAlpha(204), fontSize: 15)),
        ],
      ),
    );
  }
}
