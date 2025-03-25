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
  ThemeMode _themeMode = ThemeMode.system;

  // 是否使用深色模式
  bool _useDarkMode = false;

  // 是否使用用戶手動設定的主題（而非跟隨系統）
  bool _isUserSelected = false;

  // 獲取當前主題模式
  ThemeMode get themeMode => _themeMode;

  // 是否使用深色模式
  bool get useDarkMode => _useDarkMode;

  // 是否使用用戶手動設定的主題
  bool get isUserSelected => _isUserSelected;

  // 獲取根據設定決定的主題數據
  ThemeData get theme {
    // 跟隨系統模式
    if (_themeMode == ThemeMode.system) {
      return _isDarkModeEnabled() ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
    // 淺色主題
    else if (_themeMode == ThemeMode.light) {
      return AppTheme.lightTheme;
    }
    // 深色主題
    else {
      return AppTheme.darkTheme;
    }
  }

  // 初始化主題設定
  Future<void> init() async {
    final settings = await SharedPrefsService.getThemeSettings();
    _isUserSelected = settings['isUserSelected'] ?? false;

    if (_isUserSelected) {
      // 如果是用戶手動設定的主題，使用保存的設定
      _useDarkMode = settings['useDarkMode'] ?? false;
      _themeMode = _useDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      // 否則跟隨系統設定
      _themeMode = ThemeMode.system;
      _useDarkMode = _isDarkModeEnabled();
    }

    // 根據當前主題模式更新狀態欄樣式
    _updateStatusBarColors();

    notifyListeners();
  }

  // 設置是否使用深色模式
  void setUseDarkMode(bool value) {
    if (_useDarkMode == value && _isUserSelected) return;

    _useDarkMode = value;
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    _isUserSelected = true; // 標記為用戶手動設定

    _saveSettings();
    _updateStatusBarColors();
    notifyListeners();
  }

  // 設置跟隨系統主題
  void setFollowSystemTheme() {
    if (_themeMode == ThemeMode.system && !_isUserSelected) return;

    _themeMode = ThemeMode.system;
    _isUserSelected = false; // 標記為跟隨系統
    _useDarkMode = _isDarkModeEnabled(); // 更新為當前系統深淺模式

    _saveSettings();
    _updateStatusBarColors();
    notifyListeners();
  }

  // 保存設定
  Future<void> _saveSettings() async {
    final settings = {'useDarkMode': _useDarkMode, 'isUserSelected': _isUserSelected};
    await SharedPrefsService.saveThemeSettings(settings);
  }

  // 檢查系統是否為深色模式
  bool _isDarkModeEnabled() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  // 更新狀態欄顏色，根據當前主題模式
  void _updateStatusBarColors() {
    bool isDarkMode = _themeMode == ThemeMode.dark || (_themeMode == ThemeMode.system && _isDarkModeEnabled());

    if (isDarkMode) {
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
