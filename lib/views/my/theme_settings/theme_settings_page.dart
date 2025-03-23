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
  // 可選的主題顏色
  final List<Map<String, dynamic>> _themeColors = [
    {'name': 'blue', 'color': const Color(0xFF1976D2), 'displayName': '醫療藍'},
    {'name': 'green', 'color': const Color(0xFF2E7D32), 'displayName': '健康綠'},
    {'name': 'purple', 'color': const Color(0xFF6A1B9A), 'displayName': '靜謐紫'},
    {'name': 'red', 'color': const Color(0xFFC62828), 'displayName': '活力紅'},
    {'name': 'orange', 'color': const Color(0xFFEF6C00), 'displayName': '溫暖橙'},
    {'name': 'teal', 'color': const Color(0xFF00796B), 'displayName': '清新青'},
  ];

  @override
  Widget build(BuildContext context) {
    // 獲取主題提供者
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    // 獲取當前主題設定
    final String selectedThemeColor = themeProvider.themeColor;
    final bool useDarkMode = themeProvider.useDarkMode;
    final bool useSystemTheme = themeProvider.useSystemTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('主題設定')),
        centerTitle: true,
        backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF121212) : theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 主題顏色選擇
              _buildSectionTitle(context.tr('主題顏色')),
              _buildThemeColorGrid(context, selectedThemeColor, themeProvider),

              const SizedBox(height: 24),

              // 深淺模式設定
              _buildSectionTitle(context.tr('深淺模式')),
              _buildSwitchItem(context.tr('跟隨系統'), context.tr('自動跟隨系統深淺模式設定'), useSystemTheme, (value) => themeProvider.setUseSystemTheme(value)),
              if (!useSystemTheme)
                _buildSwitchItem(context.tr('深色模式'), context.tr('使用深色主題，適合夜間使用'), useDarkMode, (value) => themeProvider.setUseDarkMode(value)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建章節標題
  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    final themeColor = theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor)),
    );
  }

  /// 構建開關設定項
  Widget _buildSwitchItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    final theme = Theme.of(context);
    final themeColor = theme.primaryColor;

    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(color: theme.textTheme.titleMedium?.color)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
        value: value,
        onChanged: onChanged,
        activeColor: themeColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  /// 構建主題顏色網格
  Widget _buildThemeColorGrid(BuildContext context, String selectedThemeColor, ThemeProvider themeProvider) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _themeColors.length,
      itemBuilder: (context, index) {
        final themeColor = _themeColors[index];
        final isSelected = selectedThemeColor == themeColor['name'];

        return GestureDetector(
          onTap: () {
            themeProvider.setThemeColor(themeColor['name']);
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? themeColor['color'] : Colors.transparent, width: 2),
              boxShadow: [BoxShadow(color: theme.shadowColor.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: themeColor['color'],
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.cardColor, width: 2),
                    boxShadow: [BoxShadow(color: themeColor['color'].withAlpha(100), blurRadius: 4, spreadRadius: 1)],
                  ),
                  child: isSelected ? Icon(Icons.check, color: theme.colorScheme.onPrimary, size: 20) : null,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr(themeColor['displayName']),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? themeColor['color'] : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
