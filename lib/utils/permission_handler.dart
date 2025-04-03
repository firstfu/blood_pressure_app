// @ Author: firstfu
// @ Create Time: 2024-05-11 18:20:30
// @ Description: 權限控制類，處理CRUD操作前的權限檢查

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';
import '../constants/auth_constants.dart' as auth_constants;
import '../services/auth_manager.dart';

/// 權限控制類
///
/// 用於在CRUD操作前檢查用戶是否有權限執行該操作
/// 如果沒有權限（未登入），則顯示登入彈窗
class PermissionHandler {
  /// 檢查操作權限
  ///
  /// [context] - 構建上下文
  /// [operationType] - 要執行的操作類型
  /// [operationName] - 操作名稱 (用於顯示在提示訊息中)
  /// [customMessage] - 可選的自定義信息
  /// [onLoginSuccess] - 登入成功後的回調函數
  ///
  /// 返回用戶是否有權限執行該操作
  /// - true: 用戶有權限執行操作
  /// - false: 用戶沒有權限或取消了登入
  static Future<bool> checkOperationPermission(
    BuildContext context,
    auth_constants.OperationType operationType, {
    String? operationName,
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
      // 使用操作類型的描述或提供的操作名稱
      final opName = operationName ?? operationType.description;

      // 使用自定義消息或默認消息
      final message = customMessage ?? '您需要登入才能$opName。';

      // 確定顯示登入還是註冊對話框
      final showRegister = authService.shouldShowRegisterDialog(operationType);

      // 使用 AuthManager 顯示登入或註冊對話框
      final bool result = await AuthManager.showLoginDialog(context, message: message, showRegister: showRegister);

      // 處理登入成功回調
      if (result && onLoginSuccess != null && authService.currentUser != null) {
        onLoginSuccess(authService.currentUser);
      }

      // 返回登入結果
      return result;
    }

    // 其他情況，有權限執行操作
    return true;
  }

  /// 執行受保護操作
  ///
  /// [context] - 構建上下文
  /// [operationType] - 要執行的操作類型
  /// [operation] - 操作函數，在用戶有權限時執行
  /// [operationName] - 操作名稱 (用於顯示在提示訊息中)
  /// [customMessage] - 可選的自定義信息
  /// [onLoginSuccess] - 登入成功後的回調函數
  ///
  /// 返回操作結果，如果用戶沒有權限，返回null
  static Future<T?> performProtectedOperation<T>(
    BuildContext context,
    auth_constants.OperationType operationType,
    Future<T> Function() operation, {
    String? operationName,
    String? customMessage,
    Function? onLoginSuccess,
  }) async {
    final hasPermission = await checkOperationPermission(
      context,
      operationType,
      operationName: operationName,
      customMessage: customMessage,
      onLoginSuccess: onLoginSuccess,
    );

    if (hasPermission) {
      return operation();
    }

    return null;
  }
}
