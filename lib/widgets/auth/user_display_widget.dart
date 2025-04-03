// @ Author: firstfu
// @ Create Time: 2024-05-14 11:32:45
// @ Description: 用戶資訊顯示組件，用於顯示當前登入用戶的姓名、頭像等資訊

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';

/// 用戶資訊顯示組件
///
/// 可以在導航欄、側邊欄或其他需要顯示用戶資訊的地方使用
/// [showAvatar] - 是否顯示頭像
/// [showEmail] - 是否顯示電子郵件
/// [avatarRadius] - 頭像半徑，默認為20
/// [nameStyle] - 姓名文字樣式
/// [emailStyle] - 電子郵件文字樣式
/// [alignment] - 對齊方式
class UserDisplayWidget extends StatelessWidget {
  final bool showAvatar;
  final bool showEmail;
  final double avatarRadius;
  final TextStyle? nameStyle;
  final TextStyle? emailStyle;
  final CrossAxisAlignment alignment;
  final EdgeInsetsGeometry? padding;

  const UserDisplayWidget({
    super.key,
    this.showAvatar = true,
    this.showEmail = true,
    this.avatarRadius = 20,
    this.nameStyle,
    this.emailStyle,
    this.alignment = CrossAxisAlignment.start,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final currentUser = provider.currentUser;
        final theme = Theme.of(context);
        final isDarkMode = theme.brightness == Brightness.dark;

        // 如果用戶未登入，顯示遊客信息
        if (currentUser == null) {
          return Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showAvatar) ...[
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(Icons.person_outline, size: avatarRadius * 1.2, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  '訪客',
                  style: nameStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                ),
              ],
            ),
          );
        }

        // 獲取用戶顯示名稱
        final displayName = provider.displayName;
        final email = currentUser.email;
        final avatarUrl = provider.avatarUrl;

        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 頭像
              if (showAvatar) ...[
                if (avatarUrl != null)
                  CircleAvatar(radius: avatarRadius, backgroundImage: NetworkImage(avatarUrl))
                else
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: theme.primaryColor.withValues(alpha: 51), // 0.2 * 255 ≈ 51
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                      style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: avatarRadius * 0.8),
                    ),
                  ),
                const SizedBox(width: 12),
              ],

              // 用戶信息 - 使用 Flexible 確保文字區域可以縮小而不溢出
              Flexible(
                child: Column(
                  crossAxisAlignment: alignment,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 用戶姓名
                    Text(
                      displayName,
                      style: nameStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black87),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // 電子郵件
                    if (showEmail && email != null && email.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style:
                            emailStyle ??
                            TextStyle(fontSize: 14, color: isDarkMode ? AppTheme.darkTextSecondaryColor : AppTheme.lightTextSecondaryColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
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
