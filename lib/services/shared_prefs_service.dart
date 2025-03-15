// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 共享偏好設定服務，用於管理應用程式的本地存儲

import 'package:shared_preferences/shared_preferences.dart';

/// 共享偏好設定服務
///
/// 用於管理應用程式的本地存儲，包括用戶設置、onBoarding 狀態等
class SharedPrefsService {
  static const String _keyOnBoardingCompleted = 'onBoardingCompleted';

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
}
