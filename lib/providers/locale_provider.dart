// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 語系提供者，使用 Provider 管理語系狀態

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('zh', 'TW'); // 暫時設定的預設值
  static const String _localeKey = 'app_locale';
  static const String _isUserSelectedKey = 'is_user_selected_locale';

  // 獲取當前語系
  Locale get locale => _locale;

  // 初始化語系
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('${_localeKey}_language_code');
    final String? countryCode = prefs.getString('${_localeKey}_country_code');
    final bool isUserSelected = prefs.getBool(_isUserSelectedKey) ?? false;

    if (languageCode != null && countryCode != null && isUserSelected) {
      // 用戶已手動設定過語系，使用儲存的設定
      _locale = Locale(languageCode, countryCode);
    } else {
      // 用戶未手動設定過語系，使用系統語系
      final deviceLocale = ui.PlatformDispatcher.instance.locale;

      // 檢查系統語系是否在我們支援的列表中
      if (['zh', 'en'].contains(deviceLocale.languageCode)) {
        if (deviceLocale.languageCode == 'zh') {
          _locale = const Locale('zh', 'TW'); // 中文預設使用繁體中文
        } else if (deviceLocale.languageCode == 'en') {
          _locale = const Locale('en', 'US'); // 英文預設使用美式英文
        }
      }
      // 若系統語系不在支援列表中，則保持預設的繁體中文
    }
  }

  // 設置語系
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    // 儲存語系設定
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_localeKey}_language_code', locale.languageCode);
    await prefs.setString('${_localeKey}_country_code', locale.countryCode!);
    await prefs.setBool(_isUserSelectedKey, true); // 標記為使用者手動設定
  }

  // 切換到繁體中文
  Future<void> setTraditionalChinese() async {
    await setLocale(const Locale('zh', 'TW'));
  }

  // 切換到英文
  Future<void> setEnglish() async {
    await setLocale(const Locale('en', 'US'));
  }

  // 重置為跟隨系統語系
  Future<void> resetToSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isUserSelectedKey, false);

    // 獲取系統語系
    final deviceLocale = ui.PlatformDispatcher.instance.locale;

    // 設定為系統語系 (如果支援)
    if (['zh', 'en'].contains(deviceLocale.languageCode)) {
      if (deviceLocale.languageCode == 'zh') {
        await setLocale(const Locale('zh', 'TW'));
      } else if (deviceLocale.languageCode == 'en') {
        await setLocale(const Locale('en', 'US'));
      }
    } else {
      // 若系統語系不支援，則設為預設的繁體中文
      await setLocale(const Locale('zh', 'TW'));
    }
  }
}
