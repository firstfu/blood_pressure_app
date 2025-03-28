/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:50:09
 * @ Description: 登入狀態顯示組件，用於顯示當前用戶的登入狀態
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/permission_handler.dart';
import '../../constants/auth_constants.dart';

/// 登入狀態顯示組件
///
/// 用於顯示當前用戶的登入狀態，並提供登入/登出功能
class LoginStatusWidget extends StatelessWidget {
  const LoginStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用Provider獲取AuthService
    final authService = Provider.of<AuthService>(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('用戶狀態', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            _buildUserInfo(context, authService),
            const SizedBox(height: 16),
            _buildActionButtons(context, authService),
          ],
        ),
      ),
    );
  }

  /// 構建用戶信息
  Widget _buildUserInfo(BuildContext context, AuthService authService) {
    final user = authService.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('登入狀態: ${authService.isGuestUser ? '遊客' : '已登入'}'),
        if (user != null) ...[
          Text('用戶名稱: ${user.name}'),
          if (user.email != null) Text('電子郵件: ${user.email}'),
          if (user.userId != null) Text('用戶ID: ${user.userId}'),
          if (user.lastLogin != null) Text('最後登入: ${user.lastLogin!.toString()}'),
        ],
      ],
    );
  }

  /// 構建操作按鈕
  Widget _buildActionButtons(BuildContext context, AuthService authService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 如果是遊客，顯示登入按鈕
        if (authService.isGuestUser)
          ElevatedButton(onPressed: () => _login(context), child: const Text('登入'))
        // 如果已登入，顯示登出按鈕
        else
          ElevatedButton(onPressed: () => _logout(context, authService), child: const Text('登出')),

        // 測試CRUD操作
        ElevatedButton(onPressed: () => _testCrudOperation(context), child: const Text('測試CRUD操作')),
      ],
    );
  }

  /// 顯示登入彈窗
  void _login(BuildContext context) async {
    await PermissionHandler.checkOperationPermission(context, OperationType.addRecord, customMessage: '登入以使用完整功能');
  }

  /// 登出
  void _logout(BuildContext context, AuthService authService) async {
    await authService.logoutUser();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已登出')));
    }
  }

  /// 測試CRUD操作
  void _testCrudOperation(BuildContext context) async {
    final result = await PermissionHandler.performProtectedOperation(context, OperationType.addRecord, () async {
      // 模擬CRUD操作
      await Future.delayed(const Duration(seconds: 1));
      return '操作成功';
    }, customMessage: '您需要登入才能進行此操作');

    if (context.mounted && result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }
}
