// 血壓記錄 App 主題檔案
// 定義應用程式的顏色方案、字體和其他主題設定
// 遵循 Material Design 3 設計規範

import 'package:flutter/material.dart';
import 'typography_theme.dart';

/// AppTheme 類別
///
/// 定義應用程式的所有視覺風格和主題設定
/// 包含顏色、字體、元件樣式等
class AppTheme {
  // 主色調
  /// 主要顏色 - 專業醫療藍
  static const Color primaryColor = Color(0xFF1976D2);

  /// 淺色主色調 - 清新淺藍色
  static const Color primaryLightColor = Color(0xFF4FC3F7);

  /// 深色主色調 - 深沉藍色
  static const Color primaryDarkColor = Color(0xFF0D47A1);

  // 功能色彩
  /// 成功狀態顏色 - 沉穩綠色
  static const Color successColor = Color(0xFF2E7D32);

  /// 淺色成功狀態 - 淺綠色
  static const Color successLightColor = Color(0xFF81C784);

  /// 警告狀態顏色 - 醒目紅色
  static const Color warningColor = Color(0xFFD32F2F);

  /// 淺色警告狀態 - 淺紅色
  static const Color warningLightColor = Color(0xFFEF5350);

  /// 提醒狀態顏色 - 溫暖橙色
  static const Color alertColor = Color(0xFFEF6C00);

  /// 淺色提醒狀態 - 淺橙色
  static const Color alertLightColor = Color(0xFFFFB74D);

  // 中性色彩
  /// 主要文字顏色 - 深灰色
  static const Color textPrimaryColor = Color(0xFF212121);

  /// 次要文字顏色 - 中灰色
  static const Color textSecondaryColor = Color(0xFF757575);

  /// 背景顏色 - 柔和灰白色
  static const Color backgroundColor = Color(0xFFF8F9FA);

  /// 卡片顏色 - 純白色
  static const Color cardColor = Color(0xFFFFFFFF);

  /// 分隔線顏色 - 淺灰色
  static const Color dividerColor = Color(0xFFEEEEEE);

  /// 獲取淺色主題
  ///
  /// 返回一個完整配置的 ThemeData 對象，用於應用程式的淺色主題
  /// 包含所有元件的樣式設定
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      fontFamily: 'NotoSansTC',
      // 使用新的排版主題
      textTheme: TypographyTheme.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // 使用新的頁面標題樣式
        titleTextStyle: TypographyTheme.pageTitle,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        // 使用新的底部導航欄樣式
        selectedLabelStyle: TypographyTheme.bottomNavSelected,
        unselectedLabelStyle: TypographyTheme.bottomNavUnselected,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, 52),
          elevation: 2,
          // 使用新的按鈕文字樣式
          textStyle: TypographyTheme.buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, 52),
          // 使用新的按鈕文字樣式 (需要覆蓋顏色)
          textStyle: TypographyTheme.buttonText.copyWith(color: primaryColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TypographyTheme.emphasized,
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 1,
        shadowColor: primaryColor.withAlpha(26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryColor, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: warningColor, width: 1.0)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: warningColor, width: 1.5)),
        // 使用新的輸入提示樣式
        hintStyle: TypographyTheme.inputHint,
        // 使用新的表單標籤樣式
        labelStyle: TypographyTheme.formLabel,
        errorStyle: TextStyle(color: warningColor, fontSize: 12),
      ),
      dividerTheme: const DividerThemeData(color: dividerColor, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        refreshBackgroundColor: backgroundColor,
        linearTrackColor: primaryLightColor.withAlpha(77),
        circularTrackColor: primaryLightColor.withAlpha(51),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withAlpha(51),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withAlpha(51),
        valueIndicatorColor: primaryDarkColor,
        valueIndicatorTextStyle: TypographyTheme.small.copyWith(color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withAlpha(128);
          }
          return Colors.grey.shade300;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: textSecondaryColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: primaryLightColor,
        error: warningColor,
        surface: backgroundColor,
        onSurface: textPrimaryColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        surfaceTint: primaryColor.withAlpha(13),
        surfaceContainerHighest: backgroundColor.withAlpha(204),
        onSurfaceVariant: textSecondaryColor,
        outline: dividerColor,
        shadow: Colors.black.withAlpha(26),
        inverseSurface: textPrimaryColor,
        onInverseSurface: Colors.white,
        inversePrimary: primaryLightColor,
        scrim: Colors.black.withAlpha(77),
      ),
    );
  }

  /// 獲取深色主題（待實現）
  ///
  /// 未來可實現深色主題模式
  static ThemeData get darkTheme {
    // TODO: 實現深色主題
    return lightTheme;
  }
}
