// @ Author: firstfu
// @ Create Time: 2024-05-16 10:45:23
// @ Description: 血壓管家 App 隱私偏好頁面，用於管理應用通知與提示設置

import 'package:flutter/material.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../services/shared_prefs_service.dart';

/// PrivacySettingsPage 類
///
/// 實現應用程式的隱私偏好頁面，用於管理應用通知與提示設置
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  // 隱私設定選項狀態
  bool _allowDataCollection = true;
  bool _allowHealthTips = true;
  bool _allowNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  /// 加載隱私設定
  Future<void> _loadPrivacySettings() async {
    // 從 SharedPreferences 加載設定
    final settings = await SharedPrefsService.getPrivacySettings();
    setState(() {
      _allowDataCollection = settings['allowDataCollection'] ?? true;
      _allowHealthTips = settings['allowHealthTips'] ?? true;
      _allowNotifications = settings['allowNotifications'] ?? true;
    });
  }

  /// 保存隱私設定
  Future<void> _savePrivacySettings() async {
    // 保存設定到 SharedPreferences
    final settings = {'allowDataCollection': _allowDataCollection, 'allowHealthTips': _allowHealthTips, 'allowNotifications': _allowNotifications};
    await SharedPrefsService.savePrivacySettings(settings);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('偏好設定已保存'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('隱私偏好')),
        centerTitle: true,
        backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF121212) : theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 應用通知與提示
              _buildSectionTitle(context.tr('應用通知與提示')),
              _buildSwitchItem(context.tr('使用體驗改進計劃'), context.tr('參與匿名使用統計以幫助我們改進應用'), _allowDataCollection, (value) {
                setState(() => _allowDataCollection = value);
              }),
              _buildSwitchItem(context.tr('健康提示'), context.tr('根據您的數據提供個性化健康建議'), _allowHealthTips, (value) {
                setState(() => _allowHealthTips = value);
              }),
              _buildSwitchItem(context.tr('通知'), context.tr('接收測量提醒和健康提示通知'), _allowNotifications, (value) {
                setState(() => _allowNotifications = value);
              }),

              const SizedBox(height: 24),

              // 保存按鈕
              Center(
                child: ElevatedButton(
                  onPressed: _savePrivacySettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryColor)),
    );
  }

  /// 構建開關設定項
  Widget _buildSwitchItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    final theme = Theme.of(context);
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
        activeColor: theme.primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
