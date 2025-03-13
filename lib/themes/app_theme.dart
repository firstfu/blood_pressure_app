// 血壓記錄 App 主題檔案
// 定義應用程式的顏色方案、字體和其他主題設定

import 'package:flutter/material.dart';

class AppTheme {
  // 主色調
  static const Color primaryColor = Color(0xFF1E88E5); // 主藍色
  static const Color primaryLightColor = Color(0xFF64B5F6); // 淺藍色
  static const Color primaryDarkColor = Color(0xFF1565C0); // 深藍色

  // 功能色彩
  static const Color successColor = Color(0xFF43A047); // 綠色，用於正常值
  static const Color successLightColor = Color(0xFF81C784); // 淺綠色
  static const Color warningColor = Color(0xFFE53935); // 紅色，用於異常值
  static const Color warningLightColor = Color(0xFFEF5350); // 淺紅色
  static const Color alertColor = Color(0xFFFB8C00); // 橙色，用於提醒
  static const Color alertLightColor = Color(0xFFFFB74D); // 淺橙色

  // 中性色彩
  static const Color textPrimaryColor = Color(0xFF424242); // 深灰，主要文字
  static const Color textSecondaryColor = Color(0xFF9E9E9E); // 中灰，次要文字
  static const Color backgroundColor = Color(0xFFF5F5F5); // 淺灰，背景
  static const Color cardColor = Color(0xFFFFFFFF); // 白色，卡片背景

  // 創建主題數據
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      fontFamily: 'NotoSansTC',
      appBarTheme: const AppBarTheme(backgroundColor: primaryColor, foregroundColor: Colors.white, elevation: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'NotoSansTC'),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'NotoSansTC'),
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor, foregroundColor: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
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
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryColor)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: warningColor)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
