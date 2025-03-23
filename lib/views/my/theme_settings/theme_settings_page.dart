// @ Author: firstfu
// @ Create Time: 2024-05-16 14:30:23
// @ Description: 血壓管家 App 主題設定頁面，用於自定義應用外觀

import 'package:flutter/material.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../themes/app_theme.dart';
import '../../../services/shared_prefs_service.dart';

/// ThemeSettingsPage 類
///
/// 實現應用程式的主題設定頁面，用於自定義應用外觀
class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  // 主題設定選項狀態
  String _selectedThemeColor = 'blue'; // 預設藍色
  bool _useDarkMode = false; // 預設淺色模式
  bool _useSystemTheme = true; // 預設跟隨系統

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
  void initState() {
    super.initState();
    _loadThemeSettings();
  }

  /// 加載主題設定
  Future<void> _loadThemeSettings() async {
    // 從 SharedPreferences 加載設定
    final settings = await SharedPrefsService.getThemeSettings();
    setState(() {
      _selectedThemeColor = settings['themeColor'] ?? 'blue';
      _useDarkMode = settings['useDarkMode'] ?? false;
      _useSystemTheme = settings['useSystemTheme'] ?? true;
    });
  }

  /// 保存主題設定
  Future<void> _saveThemeSettings() async {
    // 保存設定到 SharedPreferences
    final settings = {'themeColor': _selectedThemeColor, 'useDarkMode': _useDarkMode, 'useSystemTheme': _useSystemTheme};
    await SharedPrefsService.saveThemeSettings(settings);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr('主題設定已保存，重啟應用後生效')), action: SnackBarAction(label: context.tr('確定'), onPressed: () {})));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('主題設定')),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 主題顏色選擇
              _buildSectionTitle(context.tr('主題顏色')),
              _buildThemeColorGrid(),

              const SizedBox(height: 24),

              // 深淺模式設定
              _buildSectionTitle(context.tr('深淺模式')),
              _buildSwitchItem(context.tr('跟隨系統'), context.tr('自動跟隨系統深淺模式設定'), _useSystemTheme, (value) {
                setState(() {
                  _useSystemTheme = value;
                  // 如果啟用跟隨系統，則禁用手動深色模式設定
                  if (value) {
                    _useDarkMode = false;
                  }
                });
              }),
              if (!_useSystemTheme)
                _buildSwitchItem(context.tr('深色模式'), context.tr('使用深色主題，適合夜間使用'), _useDarkMode, (value) {
                  setState(() => _useDarkMode = value);
                }),

              const SizedBox(height: 24),

              // 保存按鈕
              Center(
                child: ElevatedButton(
                  onPressed: _saveThemeSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(context.tr('保存設定')),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建章節標題
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
    );
  }

  /// 構建開關設定項
  Widget _buildSwitchItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  /// 構建主題顏色網格
  Widget _buildThemeColorGrid() {
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
        final isSelected = _selectedThemeColor == themeColor['name'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedThemeColor = themeColor['name'];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? themeColor['color'] : Colors.transparent, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))],
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
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [BoxShadow(color: themeColor['color'].withAlpha(100), blurRadius: 4, spreadRadius: 1)],
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr(themeColor['displayName']),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? themeColor['color'] : AppTheme.textPrimaryColor,
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
