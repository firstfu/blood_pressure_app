// 血壓管家 App 排版主題檔案
// 根據排版指南實現應用程式的文字樣式
// 定義各種文字大小、字重和用途

import 'package:flutter/material.dart';

/// TypographyTheme 類別
///
/// 定義應用程式的所有文字排版樣式
/// 根據 /docs/typography_guidelines.md 文件實現
class TypographyTheme {
  // 主要文字顏色
  static const Color textPrimaryColor = Color(0xFF212121);

  // 次要文字顏色
  static const Color textSecondaryColor = Color(0xFF757575);

  // 主色調
  static const Color primaryColor = Color(0xFF1976D2);

  // 主要字體
  static const String fontFamily = 'NotoSansTC';

  /// 頁面標題樣式 (22sp)
  /// 用於 AppBar 標題
  static const TextStyle pageTitle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: fontFamily);

  /// 大標題樣式 (24sp)
  /// 用於頁面主要標題
  static const TextStyle largeTitle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: fontFamily);

  /// 標題樣式 (20sp)
  /// 用於卡片標題、章節標題
  static const TextStyle title = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: fontFamily);

  /// 副標題樣式 (18sp)
  /// 用於分區標題、設置項標題
  static const TextStyle subtitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textPrimaryColor, fontFamily: fontFamily);

  /// 強調文本樣式 (16sp)
  /// 用於重要數據、按鈕文字
  static const TextStyle emphasized = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimaryColor, fontFamily: fontFamily);

  /// 正文樣式 (14sp)
  /// 用於一般內容、表單文字
  static const TextStyle body = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textPrimaryColor, fontFamily: fontFamily);

  /// 次要文本樣式 (13sp)
  /// 用於標籤、提示文字
  static const TextStyle secondary = TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: textSecondaryColor, fontFamily: fontFamily);

  /// 小字體樣式 (12sp)
  /// 用於註釋、時間戳
  static const TextStyle small = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: textSecondaryColor, fontFamily: fontFamily);

  /// 微小文本樣式 (10sp)
  /// 用於版權信息、法律聲明
  static const TextStyle micro = TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: textSecondaryColor, fontFamily: fontFamily);

  /// 獲取完整的 TextTheme
  /// 用於配置 ThemeData
  static TextTheme get textTheme {
    return const TextTheme(
      // 標題系列
      displayLarge: largeTitle, // 24sp, 大標題
      displayMedium: title, // 20sp, 標題
      displaySmall: subtitle, // 18sp, 副標題
      // 標題系列 (另一組)
      headlineLarge: largeTitle, // 24sp, 大標題 (替代)
      headlineMedium: title, // 20sp, 標題 (替代)
      headlineSmall: subtitle, // 18sp, 副標題 (替代)
      // 標題系列 (第三組)
      titleLarge: subtitle, // 18sp, 用於卡片標題等
      titleMedium: emphasized, // 16sp, 用於強調文本
      titleSmall: body, // 14sp, 用於小標題
      // 正文系列
      bodyLarge: emphasized, // 16sp, 強調正文
      bodyMedium: body, // 14sp, 標準正文
      bodySmall: secondary, // 13sp, 次要文本
      // 標籤系列
      labelLarge: body, // 14sp, 大型標籤
      labelMedium: secondary, // 13sp, 中型標籤
      labelSmall: small, // 12sp, 小型標籤
    );
  }

  /// 頁面元素特定樣式

  /// 底部導航欄選中項樣式
  static const TextStyle bottomNavSelected = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: primaryColor, fontFamily: fontFamily);

  /// 底部導航欄未選中項樣式
  static const TextStyle bottomNavUnselected = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    fontFamily: fontFamily,
  );

  /// 按鈕文字樣式
  static const TextStyle buttonText = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white, fontFamily: fontFamily);

  /// 表單標籤樣式
  static const TextStyle formLabel = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textPrimaryColor, fontFamily: fontFamily);

  /// 輸入提示樣式
  static const TextStyle inputHint = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textSecondaryColor, fontFamily: fontFamily);

  /// 數據值樣式 (用於血壓數值等)
  static const TextStyle dataValue = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: fontFamily);

  /// 數據單位樣式
  static const TextStyle dataUnit = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textSecondaryColor, fontFamily: fontFamily);

  /// 數據摘要值樣式 (用於統計頁面)
  static const TextStyle dataSummaryValue = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: fontFamily);

  /// 數據摘要標籤樣式
  static const TextStyle dataSummaryLabel = TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: textSecondaryColor, fontFamily: fontFamily);

  /// 圖表軸標籤樣式
  static const TextStyle chartAxisLabel = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: textSecondaryColor, fontFamily: fontFamily);

  /// 健康提示標題樣式
  static const TextStyle healthTipTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimaryColor, fontFamily: fontFamily);

  /// 健康提示內容樣式
  static const TextStyle healthTipContent = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textPrimaryColor, fontFamily: fontFamily);

  /// 設置項標題樣式
  static const TextStyle settingItemTitle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textPrimaryColor, fontFamily: fontFamily);

  /// 設置項描述樣式
  static const TextStyle settingItemDescription = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    fontFamily: fontFamily,
  );
}
