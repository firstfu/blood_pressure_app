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

    // 檢查是否是用戶手動設定的語系
    Future<bool> isUserSelected() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('is_user_selected_locale') ?? false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('語言設定')),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: FutureBuilder<bool>(
        future: isUserSelected(),
        builder: (context, snapshot) {
          final isUserSelected = snapshot.data ?? false;

          return ListView(
            children: [
              _buildLanguageOption(
                context,
                title: context.tr('跟隨系統'),
                isSelected: !isUserSelected,
                onTap: () => localeProvider.resetToSystemLocale(),
              ),
              const Divider(),
              _buildLanguageOption(
                context,
                title: context.tr('繁體中文'),
                locale: const Locale('zh', 'TW'),
                isSelected: isUserSelected && currentLocale.languageCode == 'zh' && currentLocale.countryCode == 'TW',
                onTap: () => localeProvider.setTraditionalChinese(),
              ),
              _buildLanguageOption(
                context,
                title: context.tr('英文'),
                locale: const Locale('en', 'US'),
                isSelected: isUserSelected && currentLocale.languageCode == 'en' && currentLocale.countryCode == 'US',
                onTap: () => localeProvider.setEnglish(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, {required String title, Locale? locale, required bool isSelected, required VoidCallback onTap}) {
    return ListTile(title: Text(title), trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null, onTap: onTap);
  }
}
