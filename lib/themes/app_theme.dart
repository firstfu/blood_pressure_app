// 血壓記錄 App 主題檔案
// 定義應用程式的顏色方案、字體和其他主題設定

import 'package:flutter/material.dart';

class AppTheme {
  // 主色調
  static const Color primaryColor = Color(0xFF1976D2); // 更專業的醫療藍
  static const Color primaryLightColor = Color(0xFF4FC3F7); // 更清新的淺藍色
  static const Color primaryDarkColor = Color(0xFF0D47A1); // 更深沉的藍色

  // 功能色彩
  static const Color successColor = Color(0xFF2E7D32); // 更沉穩的綠色
  static const Color successLightColor = Color(0xFF81C784); // 淺綠色
  static const Color warningColor = Color(0xFFD32F2F); // 更醒目的紅色
  static const Color warningLightColor = Color(0xFFEF5350); // 淺紅色
  static const Color alertColor = Color(0xFFEF6C00); // 更溫暖的橙色
  static const Color alertLightColor = Color(0xFFFFB74D); // 淺橙色

  // 中性色彩
  static const Color textPrimaryColor = Color(0xFF212121); // 更深的灰，主要文字
  static const Color textSecondaryColor = Color(0xFF757575); // 中灰，次要文字
  static const Color backgroundColor = Color(0xFFF8F9FA); // 更柔和的背景色
  static const Color cardColor = Color(0xFFFFFFFF); // 白色，卡片背景
  static const Color dividerColor = Color(0xFFEEEEEE); // 分隔線顏色

  // 創建主題數據
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      fontFamily: 'NotoSansTC',
      appBarTheme: const AppBarTheme(backgroundColor: primaryColor, foregroundColor: Colors.white, elevation: 0, centerTitle: true),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'NotoSansTC'),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansTC'),
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
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      textTheme: const TextTheme(
        // 標題
        displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // H1
        displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // H2
        displaySmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // H3
        headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // H4
        // 正文
        bodyLarge: TextStyle(fontSize: 16, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // 主要文字
        bodyMedium: TextStyle(fontSize: 14, color: textSecondaryColor, fontFamily: 'NotoSansTC'), // 次要文字
        bodySmall: TextStyle(fontSize: 12, color: textSecondaryColor, fontFamily: 'NotoSansTC'), // 小型文字
        // 數據顯示
        titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // 大型數據
        titleMedium: TextStyle(fontSize: 24, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // 中型數據
        titleSmall: TextStyle(fontSize: 18, color: textPrimaryColor, fontFamily: 'NotoSansTC'), // 小型數據
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 1,
        shadowColor: primaryColor.withOpacity(0.1),
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
        hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7), fontSize: 14),
        labelStyle: TextStyle(color: textSecondaryColor, fontSize: 14),
        errorStyle: TextStyle(color: warningColor, fontSize: 12),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: primaryLightColor,
        error: warningColor,
        background: backgroundColor,
        surface: cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onBackground: textPrimaryColor,
        onSurface: textPrimaryColor,
      ),
    );
  }
}
