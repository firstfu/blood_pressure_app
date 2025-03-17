// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 語系擴展方法，方便在代碼中使用

import 'package:flutter/material.dart';
import 'app_localizations.dart';

// 擴展 BuildContext，方便在代碼中使用語系
extension AppLocalizationsExtension on BuildContext {
  // 獲取當前語系的翻譯
  String tr(String key) {
    return AppLocalizations.of(this).translate(key);
  }

  // 獲取當前語系的翻譯，並進行格式化
  String formatTr(String key, List<String> args) {
    return AppLocalizations.of(this).formatTr(key, args);
  }

  // 獲取當前語系的名稱
  String get currentLanguageName {
    return AppLocalizations.of(this).currentLanguageName;
  }

  // 獲取當前語系
  Locale get currentLocale {
    return AppLocalizations.of(this).locale;
  }
}
