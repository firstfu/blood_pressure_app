/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:20:05
 * @ Description: 用戶認證服務，處理用戶認證相關邏輯
 */

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import '../models/user_profile.dart';
import '../constants/auth_constants.dart';
import './shared_prefs_service.dart';

/// 用戶認證服務
///
/// 處理用戶認證相關邏輯，包括登入、註冊、登出等
class AuthService extends ChangeNotifier {
  // 當前用戶
  UserProfile? _currentUser;

  // Google 登入實例
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

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

  /// 使用 Google 賬號登入
  ///
  /// 使用 Google 賬號進行認證並登入
  Future<UserProfile?> signInWithGoogle() async {
    try {
      // 顯示 Google 登入界面
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google 登入取消');
      }

      // 獲取認證信息
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 這裡應該將 googleAuth.idToken 和 googleAuth.accessToken 發送到後端進行驗證
      // 並獲取用戶信息和訪問令牌
      // 這裡僅做模擬

      // 保存遊客數據 (如果之前是遊客)
      final wasGuest = _currentUser?.isGuest ?? true;
      final oldUserId = _currentUser?.userId;

      // 創建用戶ID (實際開發中會從後端獲取)
      final userId = 'google_${googleUser.id}';

      // 創建用戶
      final user = _currentUser ?? UserProfile();
      user.isGuest = false;
      user.email = googleUser.email;
      user.name = googleUser.displayName ?? '用戶${Random().nextInt(10000)}';
      user.userId = userId;
      user.lastLogin = DateTime.now();
      user.photoUrl = googleUser.photoUrl;

      // 保存用戶信息
      _currentUser = user;
      await SharedPrefsService.saveUserProfile(user);

      // 保存 token (實際開發中會從後端獲取)
      await SharedPrefsService.saveAuthToken(googleAuth.accessToken ?? 'google_token');

      // 如果之前是遊客，處理數據遷移邏輯
      if (wasGuest && oldUserId != null) {
        await _migrateGuestData(oldUserId, userId);
      }

      notifyListeners();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print('Google 登入失敗: $e');
      }
      rethrow;
    }
  }

  /// 生成 Apple 登入的 nonce
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// 使用 SHA256 對字符串進行哈希處理
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 使用 Apple 賬號登入
  ///
  /// 使用 Apple 賬號進行認證並登入
  Future<UserProfile?> signInWithApple() async {
    try {
      // 生成安全隨機數 nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // 發起 Apple 登入請求
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );

      // 這裡應該將 credential.identityToken 發送到後端進行驗證
      // 並獲取用戶信息和訪問令牌
      // 這裡僅做模擬

      // 保存遊客數據 (如果之前是遊客)
      final wasGuest = _currentUser?.isGuest ?? true;
      final oldUserId = _currentUser?.userId;

      // 創建用戶ID (實際開發中會從後端獲取)
      final userId = 'apple_${credential.userIdentifier ?? DateTime.now().millisecondsSinceEpoch.toString()}';

      // 獲取用戶名 (Apple 有時不會返回用戶名)
      String? name;
      if (credential.givenName != null && credential.familyName != null) {
        name = '${credential.givenName} ${credential.familyName}';
      } else {
        name = '用戶${Random().nextInt(10000)}';
      }

      // 創建用戶
      final user = _currentUser ?? UserProfile();
      user.isGuest = false;
      user.email = credential.email ?? 'apple_user@example.com'; // Apple 有時不會返回郵箱
      user.name = name;
      user.userId = userId;
      user.lastLogin = DateTime.now();

      // 保存用戶信息
      _currentUser = user;
      await SharedPrefsService.saveUserProfile(user);

      // 保存 token (實際開發中會從後端獲取)
      await SharedPrefsService.saveAuthToken(credential.identityToken ?? 'apple_token');

      // 如果之前是遊客，處理數據遷移邏輯
      if (wasGuest && oldUserId != null) {
        await _migrateGuestData(oldUserId, userId);
      }

      notifyListeners();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print('Apple 登入失敗: $e');
      }
      rethrow;
    }
  }

  /// 登出
  ///
  /// 清除登入狀態，創建新的遊客用戶
  Future<void> logoutUser() async {
    try {
      // 如果使用 Google 登入，需要先退出 Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

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
