// @ Author: firstfu
// @ Create Time: 2024-04-01 17:58:20
// @ Description: 身份認證狀態管理 Provider

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

/// 身份認證錯誤類型
enum AuthErrorType { invalidCredentials, emailNotVerified, userNotFound, weakPassword, emailAlreadyInUse, networkError, unknown }

/// 身份認證狀態 Provider
class AuthProvider extends ChangeNotifier {
  /// 身份認證服務實例
  final AuthService _authService = AuthService();

  /// 當前用戶
  User? get currentUser => _authService.currentUser;

  /// 是否已登入
  bool get isAuthenticated => _authService.isAuthenticated;

  /// 獲取用戶姓名，優先從用戶元數據中獲取，如果沒有則回傳電子郵件或空值
  String get displayName {
    final user = currentUser;
    if (user == null) {
      return '';
    }

    // 優先使用元數據中的姓名
    final fullName = user.userMetadata?['full_name'] as String?;
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    // 次優先使用元數據中的名稱
    final name = user.userMetadata?['name'] as String?;
    if (name != null && name.isNotEmpty) {
      return name;
    }

    // 再次優先使用元數據中的用戶名
    final username = user.userMetadata?['username'] as String?;
    if (username != null && username.isNotEmpty) {
      return username;
    }

    // 最後回傳電子郵件或空值
    return user.email ?? '';
  }

  /// 獲取用戶頭像URL
  String? get avatarUrl => currentUser?.userMetadata?['avatar_url'] as String?;

  /// 登入狀態
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 身份認證錯誤訊息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 身份認證錯誤類型
  AuthErrorType? _errorType;
  AuthErrorType? get errorType => _errorType;

  /// 認證狀態訂閱
  StreamSubscription<AuthState>? _authStateSubscription;

  /// 初始化 Provider
  AuthProvider() {
    _initialize();
  }

  /// 監聽身份認證狀態變化
  void _initialize() {
    _authStateSubscription = _authService.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;

      switch (event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.tokenRefreshed:
          debugPrint('用戶登入狀態變化: $event');
          notifyListeners();
          break;
        case AuthChangeEvent.signedOut:
          debugPrint('用戶登出');
          notifyListeners();
          break;
        // 處理初始會話事件
        case AuthChangeEvent.initialSession:
          debugPrint('初始會話載入完成: ${data.session != null ? "有效會話" : "無會話"}');
          // 通知監聽器更新認證狀態
          notifyListeners();
          break;
        // ignoring deprecated event
        case AuthChangeEvent.passwordRecovery:
          debugPrint('用戶請求重置密碼');
          break;
        case AuthChangeEvent.mfaChallengeVerified:
          debugPrint('多因素認證已驗證');
          break;
        default:
          debugPrint('未處理的認證事件: $event');
          break;
      }
    });
  }

  /// 釋放資源
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  /// 清除錯誤信息
  void clearError() {
    _errorMessage = null;
    _errorType = null;
    notifyListeners();
  }

  /// 設置加載狀態
  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  /// 設置錯誤信息
  void _setError(String message, AuthErrorType type) {
    _errorMessage = message;
    _errorType = type;
    notifyListeners();
  }

  /// 處理 Supabase 錯誤
  AuthErrorType _handleSupabaseError(dynamic error) {
    if (error is AuthException) {
      final String errorMessage = error.message.toLowerCase();

      if (errorMessage.contains('invalid login credentials')) {
        return AuthErrorType.invalidCredentials;
      } else if (errorMessage.contains('email not confirmed')) {
        return AuthErrorType.emailNotVerified;
      } else if (errorMessage.contains('user not found')) {
        return AuthErrorType.userNotFound;
      } else if (errorMessage.contains('weak password')) {
        return AuthErrorType.weakPassword;
      } else if (errorMessage.contains('email already registered')) {
        return AuthErrorType.emailAlreadyInUse;
      }
    }

    // 網絡錯誤
    if (error.toString().contains('network')) {
      return AuthErrorType.networkError;
    }

    return AuthErrorType.unknown;
  }

  /// 通知用戶已經成功登入
  ///
  /// [user] - 登入成功的用戶對象
  void notifyUserSignedIn(User user) {
    // 當登入成功時，清除錯誤信息和加載狀態
    clearError();
    _setLoading(false);

    // 通知監聽器用戶已登入
    notifyListeners();
  }

  /// 使用電子郵件和密碼登入
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      return true;
    } catch (error) {
      final errorType = _handleSupabaseError(error);
      String errorMessage;

      switch (errorType) {
        case AuthErrorType.invalidCredentials:
          errorMessage = '電子郵件或密碼不正確';
          break;
        case AuthErrorType.emailNotVerified:
          errorMessage = '請先驗證您的電子郵件';
          break;
        case AuthErrorType.userNotFound:
          errorMessage = '找不到使用此電子郵件的用戶';
          break;
        case AuthErrorType.networkError:
          errorMessage = '網絡連接錯誤';
          break;
        default:
          errorMessage = '登入時發生錯誤：${error.toString()}';
          break;
      }

      _setError(errorMessage, errorType);
      _setLoading(false);
      return false;
    }
  }

  /// 使用一次性密碼登入
  Future<bool> signInWithOtp(String email) async {
    _setLoading(true);
    clearError();

    try {
      await _authService.signInWithOtp(email);
      _setLoading(false);
      return true;
    } catch (error) {
      final errorMessage = '發送一次性密碼失敗：${error.toString()}';
      _setError(errorMessage, AuthErrorType.unknown);
      _setLoading(false);
      return false;
    }
  }

  /// 使用電子郵件和密碼註冊
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      await _authService.signUpWithEmailAndPassword(email, password);
      _setLoading(false);
      return true;
    } catch (error) {
      final errorType = _handleSupabaseError(error);
      String errorMessage;

      switch (errorType) {
        case AuthErrorType.emailAlreadyInUse:
          errorMessage = '此電子郵件已被使用';
          break;
        case AuthErrorType.weakPassword:
          errorMessage = '密碼太弱，請使用更強的密碼';
          break;
        case AuthErrorType.networkError:
          errorMessage = '網絡連接錯誤';
          break;
        default:
          errorMessage = '註冊時發生錯誤：${error.toString()}';
          break;
      }

      _setError(errorMessage, errorType);
      _setLoading(false);
      return false;
    }
  }

  /// 使用 Google 登入
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    clearError();

    try {
      await _authService.signInWithGoogle();
      _setLoading(false);
      return true;
    } catch (error) {
      // 忽略用戶取消登入的錯誤
      if (error.toString().contains('canceled') || error.toString().contains('cancelled') || error.toString().contains('重定向進行中')) {
        _setLoading(false);
        return false;
      }

      final errorMessage = 'Google 登入失敗：${error.toString()}';
      _setError(errorMessage, AuthErrorType.unknown);
      _setLoading(false);
      return false;
    }
  }

  /// 使用 Apple 登入
  Future<bool> signInWithApple() async {
    _setLoading(true);
    clearError();

    try {
      await _authService.signInWithApple();
      _setLoading(false);
      return true;
    } catch (error) {
      // 忽略用戶取消登入的錯誤
      if (error.toString().contains('canceled') || error.toString().contains('cancelled') || error.toString().contains('重定向進行中')) {
        _setLoading(false);
        return false;
      }

      final errorMessage = 'Apple 登入失敗：${error.toString()}';
      _setError(errorMessage, AuthErrorType.unknown);
      _setLoading(false);
      return false;
    }
  }

  /// 請求重置密碼
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (error) {
      final errorMessage = '密碼重置請求失敗：${error.toString()}';
      _setError(errorMessage, AuthErrorType.unknown);
      _setLoading(false);
      return false;
    }
  }

  /// 更新密碼
  Future<bool> updatePassword(String newPassword) async {
    _setLoading(true);
    clearError();

    try {
      await _authService.updatePassword(newPassword);
      _setLoading(false);
      return true;
    } catch (error) {
      final errorMessage = '更新密碼失敗：${error.toString()}';
      _setError(errorMessage, AuthErrorType.unknown);
      _setLoading(false);
      return false;
    }
  }

  /// 登出
  Future<bool> signOut() async {
    _setLoading(true);
    clearError();

    try {
      await _authService.signOut();
      _setLoading(false);
      return true;
    } catch (error) {
      final errorMessage = '登出失敗：${error.toString()}';
      _setError(errorMessage, AuthErrorType.unknown);
      _setLoading(false);
      return false;
    }
  }
}
