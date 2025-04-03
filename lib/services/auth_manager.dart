// @ Author: firstfu
// @ Create Time: 2024-05-11 18:05:30
// @ Description: 身份認證管理服務，整合 Supabase 與現有登入對話框

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/auth/login_dialog.dart';
import '../widgets/auth/register_dialog.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import '../constants/auth_constants.dart' as auth_constants;

/// 身份認證管理器
///
/// 用於整合 Supabase 身份認證與現有的登入對話框
class AuthManager {
  /// 顯示登入對話框
  ///
  /// [context] - 當前上下文
  /// [message] - 可選的提示訊息
  /// [showRegister] - 是否顯示註冊對話框
  /// 返回是否成功完成認證
  static Future<bool> showLoginDialog(BuildContext context, {String? message, bool showRegister = false}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 如果用戶已登入，無需顯示登入對話框
    if (authProvider.isAuthenticated) {
      return true;
    }

    // 顯示登入或註冊對話框
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        if (showRegister) {
          return RegisterDialog(
            message: message,
            onSuccess: (User user) {
              // 當用戶成功註冊並登入時通知 AuthProvider
              authProvider.notifyUserSignedIn(user);
            },
          );
        } else {
          return LoginDialog(
            message: message,
            onSuccess: (User user) {
              // 當用戶成功登入時通知 AuthProvider
              authProvider.notifyUserSignedIn(user);
            },
          );
        }
      },
    );

    // 返回對話框結果 (如果為 null 則視為登入失敗)
    return result ?? false;
  }

  /// 檢查操作是否需要登入
  ///
  /// [context] - 當前上下文
  /// [operationType] - 操作類型
  /// [operationName] - 操作名稱 (用於顯示在提示訊息中)
  /// 返回是否可以執行操作
  static Future<bool> checkAuthStateForOperation(
    BuildContext context, {
    required auth_constants.OperationType operationType,
    required String operationName,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    // 如果用戶已登入，允許操作
    if (authProvider.isAuthenticated) {
      return true;
    }

    // 檢查操作是否需要登入
    if (!authService.needsLoginDialog(operationType)) {
      return true; // 不需要登入的操作
    }

    // 確定顯示登入還是註冊對話框
    final showRegister = authService.shouldShowRegisterDialog(operationType);

    // 顯示登入或註冊對話框
    final message = '您需要登入才能$operationName。';
    return await showLoginDialog(context, message: message, showRegister: showRegister);
  }

  /// 登出用戶
  ///
  /// [context] - 當前上下文
  static Future<void> signOut(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
  }
}
