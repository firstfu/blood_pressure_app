/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:20:05
 * @ Description: 用戶認證服務，處理用戶認證相關邏輯
 */

import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../constants/auth_constants.dart';
import './shared_prefs_service.dart';

/// 用戶認證服務
///
/// 處理用戶認證相關邏輯，包括登入、註冊、登出等
class AuthService extends ChangeNotifier {
  // 當前用戶
  UserProfile? _currentUser;

  // 獲取當前用戶
  UserProfile? get currentUser => _currentUser;

  // 是否為遊客
  bool get isGuestUser => _currentUser?.isGuest ?? true;

  // 是否已登入
  bool get isAuthenticated => !isGuestUser;

  /// 初始化認證服務
  ///
  /// 從本地存儲加載用戶信息
  Future<void> initialize() async {
    // 從本地存儲加載用戶信息
    final userData = await SharedPrefsService.getUserProfile();

    if (userData.userId != null) {
      _currentUser = userData;
    } else {
      // 創建遊客用戶
      _currentUser = UserProfile.createGuestUser();
      await SharedPrefsService.saveUserProfile(_currentUser!);
    }

    notifyListeners();
  }

  /// 註冊新用戶
  ///
  /// 返回註冊後的用戶資料
  Future<UserProfile> registerUser(String email, String password, String name) async {
    try {
      // 實際開發中，這裡會有真實的註冊邏輯，如調用API等
      // 這裡僅做模擬

      // 創建用戶ID (實際開發中會從後端獲取)
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      // 創建新用戶
      final newUser = UserProfile(userId: userId, name: name, email: email, isGuest: false, lastLogin: DateTime.now());

      // 保存用戶信息
      _currentUser = newUser;
      await SharedPrefsService.saveUserProfile(newUser);

      // 生成並保存token (實際開發中會從後端獲取)
      final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
      await SharedPrefsService.saveAuthToken(token);

      notifyListeners();
      return newUser;
    } catch (e) {
      if (kDebugMode) {
        print('註冊用戶失敗: $e');
      }
      rethrow;
    }
  }

  /// 用戶登入
  ///
  /// 返回登入後的用戶資料
  Future<UserProfile> loginUser(String email, String password) async {
    try {
      // 實際開發中，這裡會有真實的登入邏輯，如調用API等
      // 這裡僅做模擬

      // 保存遊客數據 (如果之前是遊客)
      final wasGuest = _currentUser?.isGuest ?? true;
      final oldUserId = _currentUser?.userId;

      // 創建用戶ID (實際開發中會從後端獲取)
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      // 模擬登入成功
      final user = _currentUser ?? UserProfile();
      user.isGuest = false;
      user.email = email;
      user.userId = userId;
      user.lastLogin = DateTime.now();

      // 保存用戶信息
      _currentUser = user;
      await SharedPrefsService.saveUserProfile(user);

      // 生成並保存token (實際開發中會從後端獲取)
      final token = 'token_${DateTime.now().millisecondsSinceEpoch}';
      await SharedPrefsService.saveAuthToken(token);

      // 如果之前是遊客，處理數據遷移邏輯
      if (wasGuest && oldUserId != null) {
        await _migrateGuestData(oldUserId, userId);
      }

      notifyListeners();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print('用戶登入失敗: $e');
      }
      rethrow;
    }
  }

  /// 登出
  ///
  /// 清除登入狀態，創建新的遊客用戶
  Future<void> logoutUser() async {
    try {
      // 創建新的遊客用戶
      _currentUser = UserProfile.createGuestUser();

      // 保存到本地
      await SharedPrefsService.saveUserProfile(_currentUser!);
      await SharedPrefsService.clearAuthToken();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('用戶登出失敗: $e');
      }
      rethrow;
    }
  }

  /// 檢查操作是否需要登入
  ///
  /// 根據操作類型判斷是否需要登入
  bool needsLoginDialog(OperationType operationType) {
    // 檢查用戶是否為遊客
    if (isGuestUser) {
      // 所有 CRUD 操作都需要登入
      return true;
    }

    // 已登入用戶不需要登入對話框
    return false;
  }

  /// 遊客數據遷移
  ///
  /// 將遊客數據遷移到註冊用戶
  Future<void> _migrateGuestData(String oldUserId, String newUserId) async {
    // 實際開發中，這裡會有數據遷移邏輯
    // 如將舊用戶ID關聯的數據更新為新用戶ID
    if (kDebugMode) {
      print('遷移遊客數據: $oldUserId -> $newUserId');
    }

    // 這裡僅做演示，實際實現視應用邏輯而定
  }
}
