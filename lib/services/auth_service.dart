/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:20:05
 * @ Description: 用戶認證服務，處理 Supabase 用戶認證相關邏輯
 */

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import '../models/user_profile.dart';
import '../constants/auth_constants.dart';
import '../constants/supabase_constants.dart';
import './shared_prefs_service.dart';
import '../widgets/auth/login_dialog.dart';

/// 用戶認證服務
///
/// 處理用戶認證相關邏輯，包括登入、註冊、登出等
class AuthService extends ChangeNotifier {
  // 當前用戶
  UserProfile? _currentUser;

  // Supabase 客戶端
  late final GoTrueClient _auth;

  // 獲取 Supabase 客戶端
  GoTrueClient get auth => _auth;

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
  /// 初始化 Supabase 並從本地存儲加載用戶信息
  Future<void> initialize() async {
    try {
      // 初始化 Supabase
      await Supabase.initialize(url: SupabaseConstants.supabaseUrl, anonKey: SupabaseConstants.supabaseAnonKey);

      // 獲取 auth 實例
      _auth = Supabase.instance.client.auth;

      // 監聽認證狀態變化
      _setupAuthListener();

      // 從 Supabase 獲取當前用戶
      final supabaseUser = _auth.currentUser;

      if (supabaseUser != null) {
        // 轉換為我們的用戶模型
        _currentUser = await _convertSupabaseUserToUserProfile(supabaseUser);
      } else {
        // 從本地存儲加載用戶信息
        final userData = await SharedPrefsService.getUserProfile();

        if (userData.userId != null && !userData.isGuest) {
          // 如果本地有非遊客用戶但 Supabase 沒有，可能是 token 過期
          // 創建遊客用戶
          _currentUser = UserProfile.createGuestUser();
          await SharedPrefsService.saveUserProfile(_currentUser!);
        } else {
          _currentUser = userData;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('認證服務初始化錯誤: $e');
      }
      // 創建遊客用戶作為備用
      _currentUser = UserProfile.createGuestUser();
      await SharedPrefsService.saveUserProfile(_currentUser!);
    }

    notifyListeners();
  }

  /// 監聽認證狀態變化
  void _setupAuthListener() {
    _auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (kDebugMode) {
        print('認證狀態變化: $event');
      }

      switch (event) {
        case AuthChangeEvent.signedIn:
          // 用戶登入
          if (session?.user != null) {
            _handleSignedIn(session!.user);
          }
          break;
        case AuthChangeEvent.signedOut:
          // 用戶登出
          _handleSignedOut();
          break;
        case AuthChangeEvent.userUpdated:
          // 用戶信息更新
          if (session?.user != null) {
            _handleUserUpdated(session!.user);
          }
          break;
        case AuthChangeEvent.tokenRefreshed:
          // 令牌刷新，不需要特別處理
          break;
        default:
          break;
      }
    });
  }

  /// 處理用戶登入事件
  Future<void> _handleSignedIn(User user) async {
    try {
      final wasGuest = _currentUser?.isGuest ?? true;
      final oldUserId = _currentUser?.userId;

      // 轉換 Supabase 用戶為我們的模型
      _currentUser = await _convertSupabaseUserToUserProfile(user);

      // 保存用戶信息
      await SharedPrefsService.saveUserProfile(_currentUser!);

      // 如果之前是遊客，處理數據遷移
      if (wasGuest && oldUserId != null && oldUserId.startsWith(AuthConstants.guestUserPrefix)) {
        await _migrateGuestData(oldUserId, user.id);
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('處理用戶登入事件錯誤: $e');
      }
    }
  }

  /// 處理用戶登出事件
  Future<void> _handleSignedOut() async {
    try {
      // 創建遊客用戶
      _currentUser = UserProfile.createGuestUser();

      // 保存用戶信息
      await SharedPrefsService.saveUserProfile(_currentUser!);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('處理用戶登出事件錯誤: $e');
      }
    }
  }

  /// 處理用戶信息更新事件
  Future<void> _handleUserUpdated(User user) async {
    try {
      // 更新用戶信息
      if (_currentUser != null) {
        _currentUser = await _convertSupabaseUserToUserProfile(user);
        await SharedPrefsService.saveUserProfile(_currentUser!);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('處理用戶信息更新事件錯誤: $e');
      }
    }
  }

  /// 將 Supabase 用戶轉換為 UserProfile
  Future<UserProfile> _convertSupabaseUserToUserProfile(User user) async {
    // 從 Supabase 用戶中獲取信息
    final email = user.email;
    final phone = user.phone;

    // 使用當前時間作為最後登入時間
    final lastLogin = DateTime.now();

    // 獲取用戶的元數據
    final metadata = user.userMetadata;
    String? name;
    String? photoUrl;

    if (metadata != null) {
      // 嘗試從元數據中獲取名稱
      name = metadata['full_name'] as String? ?? metadata['name'] as String? ?? metadata['user_name'] as String?;

      // 嘗試從元數據中獲取頭像
      photoUrl = metadata['avatar_url'] as String? ?? metadata['picture'] as String?;
    }

    // 如果元數據中沒有名稱，使用電子郵件的前綴部分
    if (name == null && email != null) {
      name = email.split('@').first;
    }

    // 創建用戶資料
    final profile = UserProfile(
      userId: user.id,
      name: name ?? '用戶${Random().nextInt(10000)}',
      email: email,
      phoneNumber: phone,
      isGuest: false,
      lastLogin: lastLogin,
      photoUrl: photoUrl,
    );

    return profile;
  }

  /// 註冊新用戶
  ///
  /// 使用電子郵件和密碼註冊新帳戶
  Future<UserProfile> registerUser(String email, String password, String name) async {
    try {
      // 使用 Supabase 註冊新用戶
      final response = await _auth.signUp(email: email, password: password, data: {'full_name': name});

      final user = response.user;
      if (user == null) {
        throw Exception('註冊失敗：無法創建用戶');
      }

      // 創建新的用戶資料
      final profile = await _convertSupabaseUserToUserProfile(user);

      // 保存到本地
      _currentUser = profile;
      await SharedPrefsService.saveUserProfile(profile);

      notifyListeners();
      return profile;
    } catch (e) {
      if (kDebugMode) {
        print('註冊用戶失敗: $e');
      }
      rethrow;
    }
  }

  /// 用戶登入
  ///
  /// 使用電子郵件和密碼登入
  Future<UserProfile> loginUser(String email, String password) async {
    try {
      // 保存遊客數據 (如果之前是遊客)
      final wasGuest = _currentUser?.isGuest ?? true;
      final oldUserId = _currentUser?.userId;

      // 使用 Supabase 登入
      final response = await _auth.signInWithPassword(email: email, password: password);

      final user = response.user;
      if (user == null) {
        throw Exception('登入失敗：無法獲取用戶信息');
      }

      // 轉換為我們的用戶模型
      final profile = await _convertSupabaseUserToUserProfile(user);

      // 保存用戶信息
      _currentUser = profile;
      await SharedPrefsService.saveUserProfile(profile);

      // 如果之前是遊客，處理數據遷移
      if (wasGuest && oldUserId != null && oldUserId.startsWith(AuthConstants.guestUserPrefix)) {
        await _migrateGuestData(oldUserId, user.id);
      }

      notifyListeners();
      return profile;
    } catch (e) {
      if (kDebugMode) {
        print('用戶登入失敗: $e');
      }
      rethrow;
    }
  }

  /// 使用 Apple 賬號登入
  ///
  /// 使用 Apple 賬號進行認證並登入
  Future<UserProfile?> signInWithApple() async {
    try {
      // 生成安全隨機數 nonce
      final rawNonce = _auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // 保存遊客數據 (如果之前是遊客)
      final wasGuest = _currentUser?.isGuest ?? true;
      final oldUserId = _currentUser?.userId;

      // 發起 Apple 登入請求
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: hashedNonce,
      );

      // 獲取 ID 令牌
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw Exception('無法從 Apple 獲取身份令牌');
      }

      // 使用 Supabase 進行 Apple 登入
      final response = await _auth.signInWithIdToken(provider: OAuthProvider.apple, idToken: idToken, nonce: rawNonce);

      final user = response.user;
      if (user == null) {
        throw Exception('Apple 登入失敗：無法獲取用戶信息');
      }

      // 處理 Apple 可能沒有返回的名字和郵箱
      // Apple 可能在第一次登入時才提供完整姓名和郵箱
      if (credential.givenName != null && credential.familyName != null) {
        // 更新用戶資料
        await _auth.updateUser(UserAttributes(data: {'full_name': '${credential.givenName} ${credential.familyName}'}));
      }

      // 轉換為我們的用戶模型
      final profile = await _convertSupabaseUserToUserProfile(user);

      // 保存用戶信息
      _currentUser = profile;
      await SharedPrefsService.saveUserProfile(profile);

      // 如果之前是遊客，處理數據遷移
      if (wasGuest && oldUserId != null && oldUserId.startsWith(AuthConstants.guestUserPrefix)) {
        await _migrateGuestData(oldUserId, user.id);
      }

      notifyListeners();
      return profile;
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

      // 使用 Supabase 登出
      await _auth.signOut();

      // 創建新的遊客用戶
      _currentUser = UserProfile.createGuestUser();

      // 保存到本地
      await SharedPrefsService.saveUserProfile(_currentUser!);

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

  /// 發送密碼重置郵件
  ///
  /// 向指定的電子郵件地址發送密碼重置郵件
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.resetPasswordForEmail(email, redirectTo: SupabaseConstants.resetPasswordRedirectUrl);
    } catch (e) {
      if (kDebugMode) {
        print('發送密碼重置郵件失敗: $e');
      }
      rethrow;
    }
  }

  /// 更新用戶密碼
  ///
  /// 用戶重設密碼或更改密碼
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      if (kDebugMode) {
        print('更新密碼失敗: $e');
      }
      rethrow;
    }
  }

  /// 更新用戶資料
  ///
  /// 更新用戶在 Supabase 中的元數據
  Future<void> updateUserProfile(String name, String? photoUrl) async {
    try {
      await _auth.updateUser(UserAttributes(data: {'full_name': name, if (photoUrl != null) 'avatar_url': photoUrl}));

      // 更新本地用戶資料
      if (_currentUser != null) {
        _currentUser!.name = name;
        if (photoUrl != null) {
          _currentUser!.photoUrl = photoUrl;
        }
        await SharedPrefsService.saveUserProfile(_currentUser!);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('更新用戶資料失敗: $e');
      }
      rethrow;
    }
  }

  /// 將操作類型轉換為登入對話框操作類型
  ///
  /// 根據應用操作類型返回對應的登入對話框操作類型
  AuthOperation getLoginDialogOperationType(OperationType operationType) {
    // 所有操作類型目前都使用登入模式
    return AuthOperation.login;
  }
}
