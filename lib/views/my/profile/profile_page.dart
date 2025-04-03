// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 個人頁面，用於顯示和管理用戶個人資料和設置

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../services/shared_prefs_service.dart';
import '../../../constants/app_constants.dart';
import '../../../models/user_profile.dart';
import '../../../widgets/developer/dev_menu_dialog.dart';
import '../about_app/about_app_page.dart';
import '../edit_profile/edit_profile_page.dart';
import '../help_feedback/help_feedback_page.dart';
import '../language_settings/language_settings_page.dart';
import '../privacy_settings/privacy_settings_page.dart';
import '../theme_settings/theme_settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ProfilePage 類
///
/// 實現應用程式的個人頁面，用於顯示和管理用戶個人資料和設置
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 開發者模式計數器
  int _devModeCounter = 0;
  // 是否顯示開發者選項
  bool _showDevOptions = false;
  // 應用評分服務
  final InAppReview _inAppReview = InAppReview.instance;
  // 用戶資料
  UserProfile? _userProfile;
  // 是否正在加載
  bool _isLoading = true;
  // 頭像文件
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _checkDeveloperMode();
  }

  /// 檢查是否啟用開發者模式
  Future<void> _checkDeveloperMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showDevOptions = prefs.getBool('developer_mode') ?? false;
    });
  }

  /// 加載用戶資料
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await SharedPrefsService.getUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
        _loadAvatarFile();
      });
    } catch (e) {
      print('加載用戶資料時出錯: $e');
      setState(() {
        _userProfile = UserProfile.createDefault();
        _isLoading = false;
      });
    }
  }

  /// 加載頭像文件
  void _loadAvatarFile() {
    if (_userProfile?.avatarPath != null && _userProfile!.avatarPath!.isNotEmpty) {
      final avatarFile = File(_userProfile!.avatarPath!);
      if (avatarFile.existsSync()) {
        setState(() {
          _avatarFile = avatarFile;
        });
      }
    }
  }

  /// 增加開發者模式計數器
  void _incrementDevModeCounter() {
    setState(() {
      _devModeCounter++;
      if (_devModeCounter >= 7) {
        _toggleDeveloperMode();
        _devModeCounter = 0;
      }
    });
  }

  /// 切換開發者模式
  Future<void> _toggleDeveloperMode() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !_showDevOptions;

    await prefs.setBool('developer_mode', newValue);

    setState(() {
      _showDevOptions = newValue;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(newValue ? '開發者模式已啟用' : '開發者模式已停用'), duration: const Duration(seconds: 2)));
    }
  }

  /// 打開開發者選單
  void _openDeveloperMenu() {
    showDialog(context: context, builder: (context) => const DevMenuDialog());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('我的')),
        centerTitle: true,
        backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF121212) : theme.appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用戶資料卡片
                    _buildUserProfileCard(theme),

                    const SizedBox(height: 24),

                    // 設置選項
                    _buildSettingsSection(theme),

                    const SizedBox(height: 24),

                    // 關於應用
                    _buildAboutSection(theme),

                    // 開發者選項（隱藏）
                    if (_showDevOptions) _buildDeveloperOptions(theme),
                  ],
                ),
              ),
    );
  }

  /// 構建用戶資料卡片
  Widget _buildUserProfileCard(ThemeData theme) {
    return Card(
      elevation: 2,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 用戶頭像
            GestureDetector(
              onTap: _incrementDevModeCounter,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: theme.primaryColor.withAlpha(26),
                backgroundImage: _avatarFile != null ? FileImage(_avatarFile!) : null,
                child: _avatarFile == null ? Icon(Icons.person, size: 40, color: theme.primaryColor) : null,
              ),
            ),
            const SizedBox(width: 16),
            // 用戶信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userProfile?.name.isNotEmpty == true ? _userProfile!.name : context.tr('姓名'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color),
                  ),
                  const SizedBox(height: 4),
                  Text(context.tr('點擊編輯個人資料'), style: TextStyle(color: theme.textTheme.bodySmall?.color)),
                ],
              ),
            ),
            // 編輯按鈕
            IconButton(icon: Icon(Icons.edit, color: theme.primaryColor), onPressed: _navigateToEditProfile),
          ],
        ),
      ),
    );
  }

  /// 導航到編輯個人資料頁面
  void _navigateToEditProfile() async {
    if (_userProfile == null) return;

    final result = await Navigator.push<UserProfile>(context, MaterialPageRoute(builder: (context) => EditProfilePage(userProfile: _userProfile!)));

    if (result != null) {
      setState(() {
        _userProfile = result;
        _loadAvatarFile();
      });
    }
  }

  /// 構建設置選項
  Widget _buildSettingsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('設定'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
        const SizedBox(height: 12),
        _buildSettingItem(theme, Icons.notifications, context.tr('提醒設定'), context.tr('設置測量提醒時間'), () {}),
        _buildSettingItem(theme, Icons.language, context.tr('語言設定'), context.tr('切換應用語言'), _navigateToLanguageSettings),
        _buildSettingItem(theme, Icons.color_lens, context.tr('主題設定'), context.tr('自定義應用外觀'), _navigateToThemeSettings),
        _buildSettingItem(theme, Icons.security, context.tr('隱私偏好'), context.tr('管理應用通知與提示'), _navigateToPrivacySettings),
      ],
    );
  }

  /// 構建關於應用部分
  Widget _buildAboutSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('關於我們'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
        const SizedBox(height: 12),
        _buildSettingItem(theme, Icons.info, context.tr('關於應用'), context.tr('版本信息和開發者'), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutAppPage()));
        }),
        _buildSettingItem(theme, Icons.help, context.tr('幫助與反饋'), context.tr('獲取幫助或提交反饋'), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HelpFeedbackPage()));
        }),
        _buildSettingItem(theme, Icons.star, context.tr('評分應用'), context.tr('在應用商店評分'), _rateApp),
        _buildSettingItem(theme, Icons.share, context.tr('分享應用'), context.tr('與朋友分享此應用'), _shareApp),
      ],
    );
  }

  /// 構建開發者選項
  Widget _buildDeveloperOptions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: theme.dividerColor),
        const SizedBox(height: 12),
        Text('開發者選項', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.error)),
        const SizedBox(height: 12),
        _buildDevSettingItem(theme, Icons.developer_mode, '開發者工具', '打開開發者測試頁面選單', _openDeveloperMenu),
        _buildDevSettingItem(theme, Icons.refresh, context.tr('重置 OnBoarding'), context.tr('重置引導頁面狀態'), _resetOnboarding),
        _buildDevSettingItem(theme, Icons.delete, context.tr('清除所有數據'), context.tr('刪除應用所有數據'), () {
          _showClearDataConfirmDialog();
        }),
      ],
    );
  }

  /// 構建設置項
  Widget _buildSettingItem(ThemeData theme, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.primaryColor),
        title: Text(title, style: TextStyle(color: theme.textTheme.titleMedium?.color)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color?.withAlpha(128)),
        onTap: onTap,
      ),
    );
  }

  /// 構建開發者設置項
  Widget _buildDevSettingItem(ThemeData theme, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: Colors.red.withValues(red: 255, green: 0, blue: 0, alpha: 26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.error),
        title: Text(title, style: TextStyle(color: theme.colorScheme.error)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.error.withValues(alpha: 179))),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.error.withAlpha(128)),
        onTap: onTap,
      ),
    );
  }

  /// 重置引導頁面
  Future<void> _resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('引導頁面已重置')), duration: const Duration(seconds: 2)));

      // 可選：直接導航到 OnboardingPage
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingPage()));
    }
  }

  /// 導航到語言設置頁面
  void _navigateToLanguageSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LanguageSettingsPage()));
  }

  /// 導航到主題設置頁面
  void _navigateToThemeSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ThemeSettingsPage()));
  }

  /// 導航到隱私設置頁面
  void _navigateToPrivacySettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacySettingsPage()));
  }

  /// 在應用商店評分
  Future<void> _rateApp() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {
      // 如果內部評分不可用，嘗試打開應用商店
      final url = Platform.isIOS ? 'https://apps.apple.com/app/id${AppConstants.appStoreId}' : 'market://details?id=${AppConstants.packageName}';

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('無法打開應用商店'))));
        }
      }
    }
  }

  /// 分享應用
  Future<void> _shareApp() async {
    final String shareText = context.tr('我正在使用「血壓管家」App記錄和追蹤我的血壓，非常實用！推薦給你：');
    final String url =
        Platform.isIOS
            ? 'https://apps.apple.com/app/id${AppConstants.appStoreId}'
            : 'https://play.google.com/store/apps/details?id=${AppConstants.packageName}';

    await Share.share('$shareText $url');
  }

  /// 顯示清除數據確認對話框
  Future<void> _showClearDataConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.tr('確認清除所有數據')),
            content: Text(context.tr('此操作將刪除應用中的所有數據，包括用戶資料、血壓記錄和設置，且無法恢復。確定要繼續嗎？')),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.tr('取消'))),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(context.tr('清除所有數據')),
              ),
            ],
          ),
    );

    if (result == true) {
      await _clearAllData();
    }
  }

  /// 清除所有數據
  Future<void> _clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 重新載入用戶資料
      await _loadUserProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('所有數據已清除')), duration: const Duration(seconds: 2)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('清除數據失敗：$e')), backgroundColor: Colors.red));
      }
    }
  }
}
