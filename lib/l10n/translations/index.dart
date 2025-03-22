// @ Author: firstfu
// @ Create Time: 2024-05-24 22:52:37
// @ Description: 翻譯模組整合文件

import 'common_translations.dart';
import 'home_translations.dart';
import 'record_translations.dart';
import 'analysis_translations.dart';
import 'advanced_analysis_translations.dart';
import 'settings_translations.dart';
import 'profile_translations.dart';
import 'about_feedback_translations.dart';

// 繁體中文翻譯整合
Map<String, String> mergeZhTWTranslations() {
  final Map<String, String> mergedZhTW = {};

  // 合併各模組翻譯
  mergedZhTW.addAll(zhTWCommon);
  mergedZhTW.addAll(zhTWHome);
  mergedZhTW.addAll(zhTWRecord);
  mergedZhTW.addAll(zhTWAnalysis);
  mergedZhTW.addAll(zhTWAdvancedAnalysis);
  mergedZhTW.addAll(zhTWSettings);
  mergedZhTW.addAll(zhTWProfile);
  mergedZhTW.addAll(zhTWAboutFeedback);

  return mergedZhTW;
}

// 英文翻譯整合
Map<String, String> mergeEnUSTranslations() {
  final Map<String, String> mergedEnUS = {};

  // 合併各模組翻譯
  mergedEnUS.addAll(enUSCommon);
  mergedEnUS.addAll(enUSHome);
  mergedEnUS.addAll(enUSRecord);
  mergedEnUS.addAll(enUSAnalysis);
  mergedEnUS.addAll(enUSAdvancedAnalysis);
  mergedEnUS.addAll(enUSSettings);
  mergedEnUS.addAll(enUSProfile);
  mergedEnUS.addAll(enUSAboutFeedback);

  return mergedEnUS;
}
