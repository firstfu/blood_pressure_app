/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:40:35
 * @ Description: 對話框工具函數
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/auth/login_dialog.dart';
import '../widgets/auth/register_dialog.dart';

/// 顯示登入彈窗
///
/// [context] - 構建上下文
/// [message] - 可選的自定義信息
/// [onSuccess] - 登入成功後的回調函數
///
/// 返回一個Future&lt;bool?&gt;，表示用戶是否成功登入
/// - true: 用戶成功登入
/// - false: 用戶取消登入
/// - null: 出現錯誤或彈窗被關閉
Future<bool?> showLoginDialog(BuildContext context, {String? message, Function(User user)? onSuccess}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LoginDialog(message: message, onSuccess: onSuccess);
    },
  );
}

/// 顯示註冊彈窗
///
/// [context] - 構建上下文
/// [message] - 可選的自定義信息
/// [onSuccess] - 註冊成功後的回調函數
///
/// 返回一個Future&lt;bool?&gt;，表示用戶是否成功註冊
/// - true: 用戶成功註冊
/// - false: 用戶取消註冊
/// - null: 出現錯誤或彈窗被關閉
Future<bool?> showRegisterDialog(BuildContext context, {String? message, Function(User user)? onSuccess}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return RegisterDialog(message: message, onSuccess: onSuccess);
    },
  );
}

/// 顯示確認對話框
///
/// [context] - 構建上下文
/// [title] - 對話框標題
/// [content] - 對話框內容
/// [confirmText] - 確認按鈕文本，默認為"確認"
/// [cancelText] - 取消按鈕文本，默認為"取消"
///
/// 返回一個Future&lt;bool&gt;，表示用戶是否確認
/// - true: 用戶點擊確認按鈕
/// - false: 用戶點擊取消按鈕或關閉對話框
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  String confirmText = '確認',
  String cancelText = '取消',
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

/// 顯示通知對話框
///
/// [context] - 構建上下文
/// [title] - 對話框標題
/// [content] - 對話框內容
/// [buttonText] - 按鈕文本，默認為"確定"
///
/// 返回一個Future&lt;void&gt;
Future<void> showNoticeDialog(BuildContext context, {required String title, required String content, String buttonText = '確定'}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

/// 顯示錯誤對話框
///
/// [context] - 構建上下文
/// [title] - 對話框標題，默認為"錯誤"
/// [content] - 錯誤信息
///
/// 返回一個Future&lt;void&gt;
Future<void> showErrorDialog(BuildContext context, {String title = '錯誤', required String content}) {
  return showNoticeDialog(context, title: title, content: content);
}
