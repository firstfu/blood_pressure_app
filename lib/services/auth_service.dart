// @ Author: firstfu
// @ Create Time: 2024-05-11 18:12:30
// @ Description: 身份認證服務，處理各種登入方式

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';
import '../constants/auth_constants.dart' as auth_constants;
import 'package:google_sign_in/google_sign_in.dart';
import 'supabase_service.dart';

/// 身份認證服務，處理 Apple、Google 和電子郵件登入
class AuthService {
  /// 獲取 Supabase 服務實例
  final SupabaseService _supabaseService = SupabaseService();

  /// 獲取當前用戶
  User? get currentUser => _supabaseService.currentUser;

  /// 檢查用戶是否已登入
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  /// 檢查是否為遊客用戶
  bool get isGuestUser => !isAuthenticated;

  /// 使用電子郵件和密碼登入
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseService.auth.signInWithPassword(email: email, password: password);
      return response;
    } catch (error) {
      debugPrint('電子郵件密碼登入失敗: $error');
      rethrow;
    }
  }

  /// 使用 OTP（一次性密碼）登入
  Future<void> signInWithOtp(String email) async {
    try {
      await _supabaseService.auth.signInWithOtp(email: email, emailRedirectTo: kIsWeb ? null : SupabaseConstants.redirectUrl);
    } catch (error) {
      debugPrint('OTP 登入失敗: $error');
      rethrow;
    }
  }

  /// 使用電子郵件和密碼註冊
  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabaseService.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: kIsWeb ? null : SupabaseConstants.redirectUrl,
      );
      return response;
    } catch (error) {
      debugPrint('用戶註冊失敗: $error');
      rethrow;
    }
  }

  /// 請求重置密碼
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.auth.resetPasswordForEmail(email, redirectTo: kIsWeb ? null : SupabaseConstants.redirectUrl);
    } catch (error) {
      debugPrint('請求重設密碼失敗: $error');
      rethrow;
    }
  }

  /// 更新密碼
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabaseService.auth.updateUser(UserAttributes(password: newPassword));
    } catch (error) {
      debugPrint('更新密碼失敗: $error');
      rethrow;
    }
  }

  /// 使用 Google 登入
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // 在 Web 平台使用 OAuth 流程
      if (kIsWeb) {
        // Web 平台上啟動 OAuth 流程並直接將用戶重定向
        await _supabaseService.auth.signInWithOAuth(OAuthProvider.google, redirectTo: SupabaseConstants.redirectUrl);
        // 注意：此處不會立即返回 AuthResponse，因為用戶會被重定向
        // 在用戶重定向回來後，Supabase 會處理認證狀態
        // 為了保持函數簽名一致，我們拋出一個例外，實際上這行代碼不會被執行
        throw const AuthException('重定向進行中');
      }
      // 在移動平台使用原生 Google 登入
      else {
        // 配置 Google Sign In
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          throw const AuthException('Google 登入已取消');
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final String? idToken = googleAuth.idToken;

        if (idToken == null) {
          throw const AuthException('無法獲取 Google ID Token');
        }

        // 使用 Google ID Token 登入 Supabase
        return await _supabaseService.auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken);
      }
    } catch (error) {
      debugPrint('Google 登入失敗: $error');
      rethrow;
    }
  }

  /// 生成用於 Apple 登入的隨機字符串
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// 使用 Apple 登入
  Future<AuthResponse> signInWithApple() async {
    try {
      // 在 Web 平台使用 OAuth 流程
      if (kIsWeb) {
        // Web 平台上啟動 OAuth 流程並直接將用戶重定向
        await _supabaseService.auth.signInWithOAuth(OAuthProvider.apple, redirectTo: SupabaseConstants.redirectUrl);
        // 注意：此處不會立即返回 AuthResponse，因為用戶會被重定向
        // 在用戶重定向回來後，Supabase 會處理認證狀態
        // 為了保持函數簽名一致，我們拋出一個例外，實際上這行代碼不會被執行
        throw const AuthException('重定向進行中');
      }
      // 在 iOS/macOS 平台使用原生 Apple 登入
      else if (Platform.isIOS || Platform.isMacOS) {
        // 生成隨機 nonce 用於安全驗證
        final rawNonce = _generateNonce();
        final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

        // 請求 Apple 憑證
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
          nonce: nonce,
        );

        // 確保我們獲取到了 ID Token
        final idToken = appleCredential.identityToken;
        if (idToken == null) {
          throw const AuthException('無法獲取 Apple ID Token');
        }

        // 使用 Apple ID Token 登入 Supabase
        return await _supabaseService.auth.signInWithIdToken(provider: OAuthProvider.apple, idToken: idToken, nonce: rawNonce);
      }
      // 在其他平台上也使用 OAuth 流程
      else {
        // 啟動 OAuth 流程並直接將用戶重定向
        await _supabaseService.auth.signInWithOAuth(OAuthProvider.apple, redirectTo: SupabaseConstants.redirectUrl);
        // 注意：此處不會立即返回 AuthResponse，因為用戶會被重定向
        // 在用戶重定向回來後，Supabase 會處理認證狀態
        // 為了保持函數簽名一致，我們拋出一個例外，實際上這行代碼不會被執行
        throw const AuthException('重定向進行中');
      }
    } catch (error) {
      debugPrint('Apple 登入失敗: $error');
      rethrow;
    }
  }

  /// 登出
  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
    } catch (error) {
      debugPrint('登出失敗: $error');
      rethrow;
    }
  }

  /// 登出用戶 (alias for signOut to maintain compatibility)
  Future<void> logoutUser() async {
    return signOut();
  }

  /// 監聽授權狀態變化
  Stream<AuthState> get onAuthStateChange => _supabaseService.onAuthStateChange;

  /// 檢查操作是否需要登入對話框
  ///
  /// [operationType] - 要執行的操作類型
  ///
  /// 返回是否需要顯示登入對話框
  bool needsLoginDialog(auth_constants.OperationType operationType) {
    // 在這裡，我們可以根據不同的操作類型來決定是否需要登入
    // 例如，某些操作可能允許遊客進行，但其他操作可能需要登入
    switch (operationType) {
      case auth_constants.OperationType.addRecord:
      case auth_constants.OperationType.editRecord:
      case auth_constants.OperationType.deleteRecord:
      case auth_constants.OperationType.editProfile:
      case auth_constants.OperationType.setReminder:
      case auth_constants.OperationType.exportData:
      case auth_constants.OperationType.viewStats:
        return true; // 這些操作需要登入
      case auth_constants.OperationType.viewHistory:
        return false; // 假設查看歷史記錄不需要登入
    }
  }

  /// 顯示登入還是註冊對話框
  ///
  /// [operationType] - 要執行的操作類型
  ///
  /// 返回 true 表示顯示註冊對話框，false 表示顯示登入對話框
  bool shouldShowRegisterDialog(auth_constants.OperationType operationType) {
    // 在這裡，我們可以根據不同的操作類型來決定顯示登入還是註冊界面
    // 默認顯示登入界面
    return false;
  }
}
