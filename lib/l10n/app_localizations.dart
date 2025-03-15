// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 多國語系管理文件

import 'package:flutter/material.dart';
import 'app_zh_TW.dart';
import 'app_en_US.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // 支援的語系列表
  static final List<Locale> supportedLocales = [
    const Locale('zh', 'TW'), // 繁體中文
    const Locale('en', 'US'), // 英文
  ];

  // 語系資源
  static final Map<String, Map<String, String>> _localizedValues = {'zh_TW': zhTW, 'en_US': enUS};

  // 獲取當前語系的翻譯
  String translate(String key) {
    String localeKey = '${locale.languageCode}_${locale.countryCode}';

    // 如果找不到對應的語系，使用繁體中文作為預設
    if (!_localizedValues.containsKey(localeKey)) {
      localeKey = 'zh_TW';
    }

    // 如果找不到對應的翻譯，返回原始 key
    return _localizedValues[localeKey]?[key] ?? key;
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

  // 獲取當前 AppLocalizations 實例
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

// 語系代理
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
