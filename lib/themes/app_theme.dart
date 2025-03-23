// 血壓記錄 App 主題檔案
// 定義應用程式的顏色方案、字體和其他主題設定
// 遵循 Material Design 3 設計規範

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'typography_theme.dart';

// 顏色常量 - 方便在任何地方使用，無需通過 AppTheme 類別訪問
// 淺色模式
const Color kPrimaryColor = Color(0xFF1976D2);
const Color kPrimaryLightColor = Color(0xFF4FC3F7);
const Color kPrimaryDarkColor = Color(0xFF0D47A1);

const Color kSuccessColor = Color(0xFF2E7D32);
const Color kWarningColor = Color(0xFFD32F2F);
const Color kAlertColor = Color(0xFFEF6C00);

const Color kTextPrimaryColor = Color(0xFF212121);
const Color kTextSecondaryColor = Color(0xFF757575);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kCardColor = Colors.white;
const Color kDividerColor = Color(0xFFBDBDBD);

// 深色模式
const Color kDarkPrimaryColor = Color(0xFF1565C0);
const Color kDarkPrimaryLightColor = Color(0xFF90CAF9);
const Color kDarkPrimaryDarkColor = Color(0xFF0D47A1);

const Color kDarkTextPrimaryColor = Color(0xFFE0E0E0);
const Color kDarkTextSecondaryColor = Color(0xFFB0B0B0);
const Color kDarkBackgroundColor = Color(0xFF121212);
const Color kDarkCardColor = Color(0xFF1E1E1E);
const Color kDarkDividerColor = Color(0xFF424242);

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

  // 淺色模式顏色
  // 中性色彩
  /// 淺色模式主要文字顏色 - 深灰色
  static const Color lightTextPrimaryColor = Color(0xFF212121);

  /// 淺色模式次要文字顏色 - 中灰色
  static const Color lightTextSecondaryColor = Color(0xFF757575);

  /// 淺色模式背景顏色 - 柔和灰白色
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);

  /// 淺色模式卡片顏色 - 純白色
  static const Color lightCardColor = Colors.white;

  /// 淺色模式分隔線顏色 - 淺灰色
  static const Color lightDividerColor = Color(0xFFBDBDBD);

  // 深色模式顏色
  /// 深色模式主要顏色 - 亮藍色
  static const Color darkPrimaryColor = Color(0xFF1565C0);

  /// 深色模式淺色主色調 - 更亮藍色
  static const Color darkPrimaryLightColor = Color(0xFF90CAF9);

  /// 深色模式深色主色調 - 中藍色
  static const Color darkPrimaryDarkColor = Color(0xFF0D47A1);

  /// 深色模式主要文字顏色 - 接近白色
  static const Color darkTextPrimaryColor = Color(0xFFE0E0E0);

  /// 深色模式次要文字顏色 - 淺灰色
  static const Color darkTextSecondaryColor = Color(0xFFB0B0B0);

  /// 深色模式背景顏色 - 深灰色
  static const Color darkBackgroundColor = Color(0xFF121212);

  /// 深色模式卡片顏色 - 稍淺灰色
  static const Color darkCardColor = Color(0xFF1E1E1E);

  /// 深色模式分隔線顏色 - 中灰色
  static const Color darkDividerColor = Color(0xFF424242);

  // 相容層 - 舊的顏色屬性
  /// @deprecated 請使用 lightTextPrimaryColor 替代
  static Color get textPrimaryColor => lightTextPrimaryColor;

  /// @deprecated 請使用 lightTextSecondaryColor 替代
  static Color get textSecondaryColor => lightTextSecondaryColor;

  /// @deprecated 請使用 lightDividerColor 替代
  static Color get dividerColor => lightDividerColor;

  /// @deprecated 請使用 primaryLightColor 替代
  static Color get accentColor => primaryLightColor;

  /// @deprecated 請使用 primaryColor 替代
  static Color get buttonColor => primaryColor;

  /// @deprecated 請使用 lightBackgroundColor 替代
  static Color get backgroundColor => lightBackgroundColor;

  /// @deprecated 請使用 lightCardColor 替代
  static Color get cardColor => lightCardColor;

  /// @deprecated 請使用 warningColor 替代
  static Color get errorColor => warningColor;

  /// 獲取淺色主題
  ///
  /// 返回一個完整配置的 ThemeData 對象，用於應用程式的淺色主題
  /// 包含所有元件的樣式設定
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      cardColor: lightCardColor,
      fontFamily: 'NotoSansTC',
      brightness: Brightness.light,
      // 使用新的排版主題
      textTheme: TypographyTheme.lightTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // 使用新的頁面標題樣式
        titleTextStyle: TypographyTheme.pageTitle,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextSecondaryColor,
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
        color: lightCardColor,
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
      dividerTheme: const DividerThemeData(color: lightDividerColor, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        refreshBackgroundColor: lightBackgroundColor,
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
        side: BorderSide(color: lightTextSecondaryColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: primaryLightColor,
        error: warningColor,
        surface: lightBackgroundColor,
        onSurface: lightTextPrimaryColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        surfaceTint: primaryColor.withAlpha(13),
        surfaceContainerHighest: lightBackgroundColor.withAlpha(204),
        onSurfaceVariant: lightTextSecondaryColor,
        outline: lightDividerColor,
        shadow: Colors.black.withAlpha(26),
        inverseSurface: lightTextPrimaryColor,
        onInverseSurface: Colors.white,
        inversePrimary: primaryLightColor,
        scrim: Colors.black.withAlpha(77),
      ),
    );
  }

  /// 獲取深色主題
  ///
  /// 返回一個完整配置的 ThemeData 對象，用於應用程式的深色主題
  /// 包含所有元件的樣式設定，適合在夜間使用
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      fontFamily: 'NotoSansTC',
      brightness: Brightness.dark,
      // 使用深色模式的排版主題
      textTheme: TypographyTheme.darkTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkPrimaryDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        // 使用深色模式的頁面標題樣式
        titleTextStyle: TypographyTheme.pageTitle,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF121212),
        selectedItemColor: Color(0xFF42A5F5),
        unselectedItemColor: darkTextSecondaryColor,
        selectedLabelStyle: TypographyTheme.bottomNavSelectedDark,
        unselectedLabelStyle: TypographyTheme.bottomNavUnselectedDark,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, 52),
          elevation: 2,
          // 使用深色模式的按鈕文字樣式
          textStyle: TypographyTheme.buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryColor,
          side: const BorderSide(color: darkPrimaryColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, 52),
          // 使用深色模式的按鈕文字樣式 (需要覆蓋顏色)
          textStyle: TypographyTheme.buttonText.copyWith(color: darkPrimaryColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TypographyTheme.emphasizedDark,
        ),
      ),
      cardTheme: CardTheme(
        color: darkCardColor,
        elevation: 1,
        shadowColor: darkPrimaryColor.withAlpha(40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF424242), width: 1.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: darkPrimaryColor, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: warningColor, width: 1.0)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: warningColor, width: 1.5)),
        // 使用深色模式的輸入提示樣式
        hintStyle: TypographyTheme.inputHintDark,
        // 使用深色模式的表單標籤樣式
        labelStyle: TypographyTheme.formLabelDark,
        errorStyle: const TextStyle(color: warningLightColor, fontSize: 12),
      ),
      dividerTheme: const DividerThemeData(color: darkDividerColor, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: darkPrimaryColor,
        refreshBackgroundColor: darkBackgroundColor,
        linearTrackColor: darkPrimaryLightColor.withAlpha(77),
        circularTrackColor: darkPrimaryLightColor.withAlpha(51),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: darkPrimaryColor,
        inactiveTrackColor: darkPrimaryColor.withAlpha(51),
        thumbColor: darkPrimaryColor,
        overlayColor: darkPrimaryColor.withAlpha(51),
        valueIndicatorColor: darkPrimaryDarkColor,
        valueIndicatorTextStyle: TypographyTheme.small.copyWith(color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimaryColor;
          }
          return Colors.grey.shade600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimaryColor.withAlpha(128);
          }
          return Colors.grey.shade800;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: darkTextSecondaryColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkPrimaryColor,
        brightness: Brightness.dark,
        primary: darkPrimaryColor,
        secondary: darkPrimaryLightColor,
        error: warningLightColor,
        surface: darkBackgroundColor,
        onSurface: darkTextPrimaryColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        surfaceTint: darkPrimaryColor.withAlpha(13),
        surfaceContainerHighest: darkBackgroundColor.withAlpha(204),
        onSurfaceVariant: darkTextSecondaryColor,
        outline: darkDividerColor,
        shadow: Colors.black.withAlpha(40),
        inverseSurface: darkTextPrimaryColor,
        onInverseSurface: darkBackgroundColor,
        inversePrimary: darkPrimaryLightColor,
        scrim: Colors.black.withAlpha(100),
      ),
    );
  }
}
