// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 語系提供者，使用 Provider 管理語系狀態

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('zh', 'TW'); // 預設繁體中文
  static const String _localeKey = 'app_locale';

  // 獲取當前語系
  Locale get locale => _locale;

  // 初始化語系
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('${_localeKey}_language_code');
    final String? countryCode = prefs.getString('${_localeKey}_country_code');

    if (languageCode != null && countryCode != null) {
      _locale = Locale(languageCode, countryCode);
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
  }

  // 切換到繁體中文
  Future<void> setTraditionalChinese() async {
    await setLocale(const Locale('zh', 'TW'));
  }

  // 切換到英文
  Future<void> setEnglish() async {
    await setLocale(const Locale('en', 'US'));
  }
}
