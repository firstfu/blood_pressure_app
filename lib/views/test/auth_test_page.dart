/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:58:14
 * @ Description: 認證測試頁面，用於測試登入/註冊功能
 */

import 'package:flutter/material.dart';
import '../../widgets/auth/login_status_widget.dart';

/// 認證測試頁面
class AuthTestPage extends StatelessWidget {
  const AuthTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('認證測試')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('遊客訪問與登入測試', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text(
                '本頁面用於測試遊客訪問與登入功能。在默認情況下，用戶以遊客身份訪問應用。'
                '當嘗試進行CRUD操作時，會彈出登入窗口。',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const LoginStatusWidget(),
              const SizedBox(height: 32),
              Text('說明', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                '• 點擊「登入」按鈕可以直接顯示登入窗口\n'
                '• 點擊「測試CRUD操作」可以模擬進行需要登入的操作\n'
                '• 登入後可以查看用戶信息，並可以登出\n'
                '• 所有數據僅在本地存儲，不會上傳到服務器',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
