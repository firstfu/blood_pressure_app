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
import 'lifestyle_analysis_translations.dart';
import 'app_translations.dart';
import 'stats_translations.dart';
import 'privacy_translations.dart';
import 'health_assessment_translations.dart';
import 'terms_of_use_translations.dart';
import 'about_translations.dart';
import 'onboarding_translations.dart';

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
  mergedZhTW.addAll(zhTWLifestyleAnalysis);
  mergedZhTW.addAll(zhTWApp);
  mergedZhTW.addAll(zhTWStats);
  mergedZhTW.addAll(zhTWPrivacy);
  mergedZhTW.addAll(zhTWHealthAssessment);
  mergedZhTW.addAll(zhTWTermsOfUse);
  mergedZhTW.addAll(zhTWAbout);
  mergedZhTW.addAll(zhTWOnboarding);

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
  mergedEnUS.addAll(enUSLifestyleAnalysis);
  mergedEnUS.addAll(enUSApp);
  mergedEnUS.addAll(enUSStats);
  mergedEnUS.addAll(enUSPrivacy);
  mergedEnUS.addAll(enUSHealthAssessment);
  mergedEnUS.addAll(enUSTermsOfUse);
  mergedEnUS.addAll(enUSAbout);
  mergedEnUS.addAll(enUSOnboarding);

  return mergedEnUS;
}
