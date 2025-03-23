// @ Author: firstfu
// @ Create Time: 2024-06-06 15:41:23
// @ Description: 血壓管家 App 主題提供者，用於管理應用的深淺模式和主題顏色

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../services/shared_prefs_service.dart';
import '../themes/app_theme.dart';

/// ThemeProvider 類
///
/// 管理應用程式的主題設定，包括深淺模式和主題顏色
/// 通過 ChangeNotifier 實現狀態管理，當主題設定變更時通知監聽者
class ThemeProvider extends ChangeNotifier {
  // 主題模式
  ThemeMode _themeMode = ThemeMode.light;

  // 是否使用深色模式
  bool _useDarkMode = false;

  // 獲取當前主題模式
  ThemeMode get themeMode => _themeMode;

  // 是否使用深色模式
  bool get useDarkMode => _useDarkMode;

  // 獲取根據設定決定的主題數據
  ThemeData get theme {
    // 淺色主題
    if (_themeMode == ThemeMode.light || (_themeMode == ThemeMode.system && !_isDarkModeEnabled())) {
      return AppTheme.lightTheme;
    }
    // 深色主題
    return AppTheme.darkTheme;
  }

  // 初始化主題設定
  Future<void> init() async {
    final settings = await SharedPrefsService.getThemeSettings();
    _useDarkMode = settings['useDarkMode'] ?? false;
    _themeMode = _useDarkMode ? ThemeMode.dark : ThemeMode.light;

    // 根據當前主題模式更新狀態欄樣式
    _updateStatusBarColors();

    notifyListeners();
  }

  // 設置是否使用深色模式
  void setUseDarkMode(bool value) {
    if (_useDarkMode == value) return;

    _useDarkMode = value;
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;

    _saveSettings();
    _updateStatusBarColors();
    notifyListeners();
  }

  // 保存設定
  Future<void> _saveSettings() async {
    final settings = {'useDarkMode': _useDarkMode};
    await SharedPrefsService.saveThemeSettings(settings);
  }

  // 檢查系統是否為深色模式
  bool _isDarkModeEnabled() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  // 更新狀態欄顏色，根據當前主題模式
  void _updateStatusBarColors() {
    if (_useDarkMode) {
      // 深色模式狀態欄設置
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // Android
          statusBarBrightness: Brightness.dark, // iOS
        ),
      );
    } else {
      // 淺色模式狀態欄設置
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light, // iOS
        ),
      );
    }
  }
}
