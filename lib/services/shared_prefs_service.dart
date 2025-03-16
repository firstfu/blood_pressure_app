// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 共享偏好設定服務，用於管理應用程式的本地存儲

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 共享偏好設定服務
///
/// 用於管理應用程式的本地存儲，包括用戶設置、onBoarding 狀態等
class SharedPrefsService {
  static const String _keyOnBoardingCompleted = 'onBoardingCompleted';
  static const String _keyPrivacySettings = 'privacySettings';

  /// 獲取 onBoarding 完成狀態
  ///
  /// 返回用戶是否已完成 onBoarding 流程
  /// 如果用戶是首次使用應用，返回 false
  static Future<bool> isOnBoardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnBoardingCompleted) ?? false;
  }

  /// 設置 onBoarding 完成狀態
  ///
  /// 當用戶完成 onBoarding 流程後調用此方法
  /// 將用戶狀態保存到本地存儲中
  static Future<void> setOnBoardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnBoardingCompleted, true);
    print('onBoarding 狀態已保存: 已完成');
  }

  /// 重置 onBoarding 狀態（用於測試）
  ///
  /// 將 onBoarding 狀態重置為未完成
  /// 主要用於開發和測試目的
  static Future<void> resetOnBoardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnBoardingCompleted, false);
    print('onBoarding 狀態已重置: 未完成');
  }

  /// 獲取隱私設定
  ///
  /// 返回用戶的隱私設定，如果沒有設定過，返回默認值
  static Future<Map<String, bool>> getPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? settingsJson = prefs.getString(_keyPrivacySettings);

    if (settingsJson == null) {
      // 返回默認設定
      return {'allowDataCollection': true, 'allowHealthTips': true, 'allowNotifications': true, 'allowCloudBackup': false, 'allowDataSharing': false};
    }

    // 解析 JSON 字符串為 Map
    try {
      final Map<String, dynamic> settings = Map<String, dynamic>.from(
        // ignore: unnecessary_cast
        (jsonDecode(settingsJson) as Map<dynamic, dynamic>),
      );

      // 將 dynamic 值轉換為 bool
      return settings.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      print('解析隱私設定時出錯: $e');
      // 出錯時返回默認設定
      return {'allowDataCollection': true, 'allowHealthTips': true, 'allowNotifications': true, 'allowCloudBackup': false, 'allowDataSharing': false};
    }
  }

  /// 保存隱私設定
  ///
  /// 將用戶的隱私設定保存到本地存儲中
  static Future<void> savePrivacySettings(Map<String, bool> settings) async {
    final prefs = await SharedPreferences.getInstance();

    // 將 Map 轉換為 JSON 字符串
    final String settingsJson = jsonEncode(settings);

    // 保存到 SharedPreferences
    await prefs.setString(_keyPrivacySettings, settingsJson);
    print('隱私設定已保存: $settings');
  }
}
