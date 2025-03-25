// @ Author: firstfu
// @ Create Time: 2024-05-16 14:30:23
// @ Description: 血壓管家 App 主題設定頁面，用於自定義應用外觀

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../providers/theme_provider.dart';
// import '../../../themes/app_theme.dart'; // 移除不必要的引用

/// ThemeSettingsPage 類
///
/// 實現應用程式的主題設定頁面，用於自定義應用外觀
class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  @override
  Widget build(BuildContext context) {
    // 獲取主題提供者
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 獲取當前主題設定
    final bool useDarkMode = themeProvider.useDarkMode;
    final bool isUserSelected = themeProvider.isUserSelected;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('主題設定')),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF121212) : theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 深淺模式設定
              _buildSectionTitle(context.tr('深淺模式'), isDarkMode),

              // 跟隨系統選項
              _buildRadioItem(
                context.tr('跟隨系統'),
                context.tr('自動跟隨系統深淺模式設定'),
                !isUserSelected,
                () => themeProvider.setFollowSystemTheme(),
                isDarkMode,
              ),

              const SizedBox(height: 8),

              // 淺色模式選項
              _buildRadioItem(
                context.tr('淺色模式'),
                context.tr('始終使用淺色模式'),
                isUserSelected && !useDarkMode,
                () => themeProvider.setUseDarkMode(false),
                isDarkMode,
              ),

              const SizedBox(height: 8),

              // 深色模式選項
              _buildRadioItem(
                context.tr('深色模式'),
                context.tr('使用深色主題，適合夜間使用'),
                isUserSelected && useDarkMode,
                () => themeProvider.setUseDarkMode(true),
                isDarkMode,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建章節標題
  Widget _buildSectionTitle(String title, bool isDarkMode) {
    final theme = Theme.of(context);
    final textColor = isDarkMode ? Colors.white : theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
    );
  }

  /// 構建單選項目
  Widget _buildRadioItem(String title, String subtitle, bool isSelected, VoidCallback onTap, bool isDarkMode) {
    final theme = Theme.of(context);
    final themeColor = theme.primaryColor;
    final titleColor = isDarkMode ? Colors.white : theme.textTheme.titleMedium?.color;
    final subtitleColor = isDarkMode ? Colors.white70 : theme.textTheme.bodySmall?.color;

    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: titleColor, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: subtitleColor)),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: themeColor),
            ],
          ),
        ),
      ),
    );
  }
}
