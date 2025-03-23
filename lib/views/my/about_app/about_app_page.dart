// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 關於應用頁面，顯示應用版本、開發者信息、隱私政策和使用條款等

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../privacy_policy/privacy_policy_page.dart';
import '../terms_of_use/terms_of_use_page.dart';

/// AboutAppPage 類
///
/// 實現應用程式的關於應用頁面，顯示應用版本、開發者信息、隱私政策和使用條款等
class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  // 應用版本信息
  String _appVersion = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  // 加載應用信息
  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      });
    } catch (e) {
      print('無法獲取應用版本信息: $e');
      setState(() {
        _appVersion = '1.0.0';
        _buildNumber = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('關於應用')),
        centerTitle: true,
        backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF121212) : theme.appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              theme.brightness == Brightness.dark
                  ? null // 暗黑模式下不使用漸層
                  : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [theme.primaryColor.withAlpha(26), theme.scaffoldBackgroundColor, theme.scaffoldBackgroundColor],
                  ),
          // 暗黑模式下使用純色背景
          color: theme.brightness == Brightness.dark ? theme.scaffoldBackgroundColor : null,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // 應用 Logo
              _buildAppLogo(),

              const SizedBox(height: 24),

              // 應用名稱和版本
              _buildAppInfo(),

              const SizedBox(height: 40),

              // 應用介紹
              _buildAppDescription(),

              const SizedBox(height: 24),

              // 開發者信息
              _buildDeveloperInfo(),

              const SizedBox(height: 24),

              // 法律信息
              _buildLegalInfo(),

              const SizedBox(height: 40),

              // 版權信息
              _buildCopyright(),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建應用 Logo
  Widget _buildAppLogo() {
    final theme = Theme.of(context);
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: theme.primaryColor.withAlpha(51), blurRadius: 20, spreadRadius: 2)],
      ),
      child: Center(
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(color: theme.primaryColor.withAlpha(26), borderRadius: BorderRadius.circular(25)),
          child: Icon(Icons.favorite, size: 60, color: theme.primaryColor),
        ),
      ),
    );
  }

  /// 構建應用信息
  Widget _buildAppInfo() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(context.tr('血壓管家'), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.primaryColor, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: theme.primaryColor.withAlpha(26), borderRadius: BorderRadius.circular(20)),
          child: Text(
            '${context.tr('版本：')} $_appVersion (${context.tr('建置版本')} $_buildNumber)',
            style: TextStyle(fontSize: 14, color: theme.primaryColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  /// 構建應用介紹
  Widget _buildAppDescription() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shadowColor: theme.primaryColor.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: theme.primaryColor, size: 22),
                const SizedBox(width: 10),
                Text(context.tr('應用介紹'), style: theme.textTheme.displaySmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.tr('血壓管家是一款專為高血壓患者和關注血壓健康的用戶設計的應用程式。它提供了簡單易用的血壓記錄功能，幫助用戶追蹤血壓變化趨勢，並提供數據分析和健康建議。'),
              style: TextStyle(fontSize: 15, height: 1.6, color: isDarkMode ? Colors.white : theme.textTheme.bodyMedium?.color),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('主要功能包括：'),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : theme.textTheme.bodyMedium?.color),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(context.tr('血壓記錄與追蹤')),
            _buildFeatureItem(context.tr('數據統計與分析')),
            _buildFeatureItem(context.tr('趨勢圖表可視化')),
            _buildFeatureItem(context.tr('Health tips and reminders')),
          ],
        ),
      ),
    );
  }

  /// 構建功能項目
  Widget _buildFeatureItem(String text) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 8, color: theme.primaryColor)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15, height: 1.5, color: isDarkMode ? Colors.white : theme.textTheme.bodyMedium?.color)),
          ),
        ],
      ),
    );
  }

  /// 構建開發者信息
  Widget _buildDeveloperInfo() {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shadowColor: theme.primaryColor.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: theme.primaryColor, size: 22),
                const SizedBox(width: 10),
                Text(context.tr('開發者信息'), style: theme.textTheme.displaySmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person, context.tr('Developer'), 'Phil'),
            InkWell(
              onTap: () => _launchURL('mailto:firefirstfu@gmail.com'),
              child: _buildInfoRow(Icons.email, context.tr('Contact Email'), 'firefirstfu@gmail.com'),
            ),
            InkWell(
              onTap: () => _launchURL('https://www.bloodpressuremanager.com'),
              child: _buildInfoRow(Icons.language, context.tr('Official Website'), context.tr('www.bloodpressuremanager.com')),
            ),
          ],
        ),
      ),
    );
  }

  /// 構建法律信息
  Widget _buildLegalInfo() {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shadowColor: theme.primaryColor.withAlpha(51),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.gavel_outlined, color: theme.primaryColor, size: 22),
                const SizedBox(width: 10),
                Text(context.tr('法律資訊'), style: theme.textTheme.displaySmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildLegalButton(
              context.tr('Privacy Policy'),
              Icons.privacy_tip_outlined,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage())),
            ),
            Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
            _buildLegalButton(
              context.tr('Terms of Use'),
              Icons.description_outlined,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsOfUsePage())),
            ),
          ],
        ),
      ),
    );
  }

  /// 構建版權信息
  Widget _buildCopyright() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          '© ${DateTime.now().year} ${context.tr('血壓管家')}',
          style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : theme.textTheme.bodySmall?.color),
        ),
        const SizedBox(height: 4),
        Text(context.tr('保留所有權利'), style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : theme.textTheme.bodySmall?.color)),
      ],
    );
  }

  /// 構建信息行
  Widget _buildInfoRow(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: theme.primaryColor.withAlpha(26), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: theme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : theme.textTheme.bodySmall?.color)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 構建法律按鈕
  Widget _buildLegalButton(String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: theme.primaryColor.withAlpha(26), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: theme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: isDarkMode ? Colors.white70 : theme.textTheme.bodySmall?.color),
          ],
        ),
      ),
    );
  }

  /// 啟動 URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('無法打開 URL: $url');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('無法打開 URL: $url')));
      }
    }
  }
}
