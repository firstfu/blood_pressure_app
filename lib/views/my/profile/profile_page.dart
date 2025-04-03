// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 個人頁面，用於顯示和管理用戶個人資料和設置

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../services/shared_prefs_service.dart';
import '../../../constants/app_constants.dart';
import '../../../models/user_profile.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/auth/user_display_widget.dart';
import '../../../services/auth_manager.dart';
import '../about_app/about_app_page.dart';
import '../edit_profile/edit_profile_page.dart';
import '../help_feedback/help_feedback_page.dart';
import '../language_settings/language_settings_page.dart';
import '../privacy_settings/privacy_settings_page.dart';
import '../theme_settings/theme_settings_page.dart';

/// ProfilePage 類
///
/// 實現應用程式的個人頁面，用於顯示和管理用戶個人資料和設置
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  ],
                ),
              ),
    );
  }

  /// 構建用戶資料卡片
  Widget _buildUserProfileCard(ThemeData theme) {
    // 獲取認證狀態
    final authProvider = Provider.of<AuthProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;

    return Card(
      elevation: 2,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 認證狀態和操作按鈕
            Row(
              children: [
                if (isAuthenticated) ...[
                  Icon(Icons.verified_user, size: 16, color: theme.primaryColor),
                  const SizedBox(width: 4),
                  Text('已登入', style: TextStyle(fontSize: 14, color: theme.primaryColor, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  TextButton(onPressed: _handleLogout, child: Text('登出', style: TextStyle(color: theme.colorScheme.error))),
                ] else ...[
                  Icon(Icons.person_outline, size: 16, color: theme.hintColor),
                  const SizedBox(width: 4),
                  Text('未登入', style: TextStyle(fontSize: 14, color: theme.hintColor)),
                  const Spacer(),
                  TextButton(onPressed: _handleLogin, child: Text('登入', style: TextStyle(color: theme.primaryColor))),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // 用戶資訊區域 - 根據登入狀態顯示不同內容
            if (isAuthenticated)
              // 已登入 - 顯示Supabase認證用戶資訊
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 使用定制化的頭像顯示 - 包裝在 Expanded 中以防止溢出
                  Expanded(
                    child: UserDisplayWidget(avatarRadius: 40, showEmail: true, alignment: CrossAxisAlignment.start, padding: EdgeInsets.zero),
                  ),

                  // 編輯按鈕 (可根據需要添加編輯Supabase用戶資料的功能)
                  IconButton(
                    icon: Icon(Icons.settings, color: theme.primaryColor),
                    tooltip: '帳號設定',
                    onPressed: () {
                      // 可以添加導航到帳號設定頁面的邏輯
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('帳號設定功能即將推出')));
                    },
                  ),
                ],
              )
            else
              // 未登入 - 顯示本地用戶資料
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用戶頭像
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.primaryColor.withAlpha(26),
                    backgroundImage: _avatarFile != null ? FileImage(_avatarFile!) : null,
                    child: _avatarFile == null ? Icon(Icons.person, size: 40, color: theme.primaryColor) : null,
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(context.tr('點擊編輯個人資料'), style: TextStyle(color: theme.textTheme.bodySmall?.color), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  // 編輯按鈕
                  IconButton(icon: Icon(Icons.edit, color: theme.primaryColor), onPressed: _navigateToEditProfile),
                ],
              ),
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

  /// 處理登入
  void _handleLogin() async {
    await AuthManager.showLoginDialog(context, message: '請登入以獲取更多功能');

    // 確保 widget 仍在樹中
    if (mounted) {
      setState(() {}); // 更新UI以反映登入狀態變化
    }
  }

  /// 處理登出
  void _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    // 在呼叫 setState 前檢查 widget 是否仍然掛載
    if (mounted) {
      setState(() {}); // 更新UI以反映登出狀態變化
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
}
