// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 語系設定頁面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../providers/locale_provider.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 檢查是否是用戶手動設定的語系
    Future<bool> isUserSelected() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_user_selected_locale') ?? false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('語言設定')),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF121212) : theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: FutureBuilder<bool>(
          future: isUserSelected(),
          builder: (context, snapshot) {
            final isUserSelected = snapshot.data ?? false;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context.tr('應用語言'), isDarkMode, context),

                  // 跟隨系統選項
                  _buildRadioItem(
                    context.tr('跟隨系統'),
                    context.tr('自動跟隨系統語言設定'),
                    !isUserSelected,
                    () => localeProvider.resetToSystemLocale(),
                    isDarkMode,
                    context,
                  ),

                  const SizedBox(height: 8),

                  // 繁體中文選項
                  _buildRadioItem(
                    context.tr('繁體中文'),
                    context.tr('設置應用語言為繁體中文'),
                    isUserSelected && currentLocale.languageCode == 'zh' && currentLocale.countryCode == 'TW',
                    () => localeProvider.setTraditionalChinese(),
                    isDarkMode,
                    context,
                  ),

                  const SizedBox(height: 8),

                  // 英文選項
                  _buildRadioItem(
                    context.tr('英文'),
                    context.tr('設置應用語言為英文'),
                    isUserSelected && currentLocale.languageCode == 'en' && currentLocale.countryCode == 'US',
                    () => localeProvider.setEnglish(),
                    isDarkMode,
                    context,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 構建章節標題
  Widget _buildSectionTitle(String title, bool isDarkMode, BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDarkMode ? Colors.white : theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
    );
  }

  /// 構建單選項目
  Widget _buildRadioItem(String title, String subtitle, bool isSelected, VoidCallback onTap, bool isDarkMode, BuildContext context) {
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
