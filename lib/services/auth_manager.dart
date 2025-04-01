// @ Author: firstfu
// @ Create Time: 2024-05-11 18:05:30
// @ Description: 身份認證管理服務，整合 Supabase 與現有登入對話框

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/auth/login_dialog.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

/// 身份認證管理器
///
/// 用於整合 Supabase 身份認證與現有的登入對話框
class AuthManager {
  /// 顯示登入對話框
  ///
  /// [context] - 當前上下文
  /// [message] - 可選的提示訊息
  /// [operationType] - 認證操作類型 (登入/註冊)
  /// 返回是否成功完成認證
  static Future<bool> showLoginDialog(BuildContext context, {String? message, AuthOperation operationType = AuthOperation.login}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 如果用戶已登入，無需顯示登入對話框
    if (authProvider.isAuthenticated) {
      return true;
    }

    // 顯示登入對話框
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => LoginDialog(
            message: message,
            operationType: operationType,
            onSuccess: (User user) {
              // 當用戶成功登入時通知 AuthProvider
              authProvider.notifyUserSignedIn(user);
            },
          ),
    );

    // 返回對話框結果 (如果為 null 則視為登入失敗)
    return result ?? false;
  }

  /// 檢查操作是否需要登入
  ///
  /// [context] - 當前上下文
  /// [operationName] - 操作名稱 (用於顯示在提示訊息中)
  /// 返回是否可以執行操作
  static Future<bool> checkAuthStateForOperation(BuildContext context, {required String operationName}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 如果用戶已登入，允許操作
    if (authProvider.isAuthenticated) {
      return true;
    }

    // 否則顯示登入對話框
    final message = '您需要登入才能$operationName。';
    return await showLoginDialog(context, message: message);
  }

  /// 登出用戶
  ///
  /// [context] - 當前上下文
  static Future<void> signOut(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
  }
}
