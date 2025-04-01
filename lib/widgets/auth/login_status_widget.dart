// @ Author: firstfu
// @ Create Time: 2024-05-11 17:55:30
// @ Description: 登入狀態顯示元件

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

/// 登入狀態顯示元件
class LoginStatusWidget extends StatelessWidget {
  const LoginStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final bool isAuthenticated = provider.isAuthenticated;
        final currentUser = provider.currentUser;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('登入狀態:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(isAuthenticated ? '已登入' : '未登入'),
                if (currentUser != null) ...[const SizedBox(height: 8), Text('使用者: ${currentUser.email ?? '未知'}')],
              ],
            ),
          ),
        );
      },
    );
  }
}
