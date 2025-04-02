// @ Author: firstfu
// @ Create Time: 2024-05-11 18:20:30
// @ Description: 權限控制類，處理CRUD操作前的權限檢查

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';
import '../constants/auth_constants.dart';
import './dialog_utils.dart';

/// 權限控制類
///
/// 用於在CRUD操作前檢查用戶是否有權限執行該操作
/// 如果沒有權限（未登入），則顯示登入彈窗
class PermissionHandler {
  /// 檢查操作權限
  ///
  /// [context] - 構建上下文
  /// [operationType] - 要執行的操作類型
  /// [customMessage] - 可選的自定義信息
  /// [onLoginSuccess] - 登入成功後的回調函數
  ///
  /// 返回用戶是否有權限執行該操作
  /// - true: 用戶有權限執行操作
  /// - false: 用戶沒有權限或取消了登入
  static Future<bool> checkOperationPermission(
    BuildContext context,
    OperationType operationType, {
    String? customMessage,
    Function? onLoginSuccess,
  }) async {
    final authService = GetIt.instance<AuthService>();

    // 如果用戶已登入，直接返回 true
    if (!authService.isGuestUser) {
      return true;
    }

    // 如果是遊客且需要登入
    if (authService.needsLoginDialog(operationType)) {
      // 顯示登入對話框
      final bool? result = await showLoginDialog(
        context,
        message: customMessage ?? '您需要登入才能${operationType.description}。',
        operationType: authService.getLoginDialogOperationType(operationType),
        onSuccess: (user) {
          if (onLoginSuccess != null) {
            onLoginSuccess(user);
          }
        },
      );

      // 返回登入結果
      return result ?? false;
    }

    // 其他情況，返回 false
    return false;
  }

  /// 執行受保護操作
  ///
  /// [context] - 構建上下文
  /// [operationType] - 要執行的操作類型
  /// [operation] - 操作函數，在用戶有權限時執行
  /// [customMessage] - 可選的自定義信息
  /// [onLoginSuccess] - 登入成功後的回調函數
  ///
  /// 返回操作結果，如果用戶沒有權限，返回null
  static Future<T?> performProtectedOperation<T>(
    BuildContext context,
    OperationType operationType,
    Future<T> Function() operation, {
    String? customMessage,
    Function? onLoginSuccess,
  }) async {
    final hasPermission = await checkOperationPermission(context, operationType, customMessage: customMessage, onLoginSuccess: onLoginSuccess);

    if (hasPermission) {
      return operation();
    }

    return null;
  }
}
