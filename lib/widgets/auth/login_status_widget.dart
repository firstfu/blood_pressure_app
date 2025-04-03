// @ Author: firstfu
// @ Create Time: 2024-05-11 17:55:30
// @ Description: 登入狀態顯示元件

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';

/// 登入狀態顯示元件
class LoginStatusWidget extends StatelessWidget {
  const LoginStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final bool isAuthenticated = provider.isAuthenticated;
        final currentUser = provider.currentUser;
        final theme = Theme.of(context);
        final isDarkMode = theme.brightness == Brightness.dark;

        return Card(
          elevation: isDarkMode ? 3 : 2,
          shadowColor: isDarkMode ? Colors.black.withAlpha(60) : Colors.black.withAlpha(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isDarkMode ? const Color(0xFF2A2A2A) : theme.cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題欄 - 與其他彈窗一致的漸層樣式
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        isDarkMode
                            ? [const Color(0xFF333333), const Color(0xFF1E1E1E)] // 暗黑模式使用深灰色漸層
                            : [theme.primaryColor, theme.primaryColor], // 明亮模式下使用 primaryColor 的純色
                  ),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_circle_outlined, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text('登入狀態', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // 內容區
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAuthenticated ? '已登入' : '未登入',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color:
                            isAuthenticated
                                ? (isDarkMode ? AppTheme.successLightColor : AppTheme.successColor)
                                : (isDarkMode ? AppTheme.warningLightColor : AppTheme.warningColor),
                      ),
                    ),
                    if (currentUser != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '使用者: ${provider.displayName}',
                        style: TextStyle(fontSize: 14, color: isDarkMode ? AppTheme.darkTextSecondaryColor : AppTheme.lightTextSecondaryColor),
                      ),
                      if (currentUser.email != null && currentUser.email!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '電子郵件: ${currentUser.email}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode ? AppTheme.darkTextSecondaryColor.withOpacity(0.8) : AppTheme.lightTextSecondaryColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
