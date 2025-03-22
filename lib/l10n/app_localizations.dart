/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-25 14:09:30
 * @ Description: 血壓記錄 App 多語系支援
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'app_en_us.dart';
import 'app_zh_tw.dart';

// 此類用於提供應用內所有的語系翻譯支援
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to get localized strings
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // 靜態代理實例
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // 可用的語系清單
  static final List<Locale> supportedLocales = [const Locale('en', 'US'), const Locale('zh', 'TW')];

  // 所有語系映射表
  static final Map<String, Map<String, String>> _localizedValues = {'en_US': enUS, 'zh_TW': zhTW};

  // 獲取翻譯字串的方法
  String translate(String key) {
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;
    final localeKey = '${languageCode}_$countryCode';

    // 如果找不到對應的語系或翻譯鍵，則返回原鍵值
    if (!_localizedValues.containsKey(localeKey) || !_localizedValues[localeKey]!.containsKey(key)) {
      return key;
    }

    return _localizedValues[localeKey]![key]!;
  }

  // 封裝後的API，簡化呼叫方式
  String get(String key) => translate(key);

  // 獲取當前語系的翻譯，並進行格式化
  String formatTr(String key, List<String> args) {
    String translation = translate(key);

    // 使用args替換%s佔位符
    for (var arg in args) {
      translation = translation.replaceFirst('%s', arg);
    }

    return translation;
  }

  // 獲取當前語系的名稱
  String get currentLanguageName {
    String localeKey = '${locale.languageCode}_${locale.countryCode}';
    switch (localeKey) {
      case 'zh_TW':
        return '繁體中文';
      case 'en_US':
        return 'English';
      default:
        return '繁體中文';
    }
  }
}

// 語系代理類，用於加載和切換語系
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // 檢查語系是否支援
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // 加載語系資源
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// 便捷擴展方法，使用於BuildContext
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String tr(String key) => l10n.translate(key);
}
