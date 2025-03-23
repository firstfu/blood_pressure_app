// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 語系設定頁面

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../providers/locale_provider.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('語言設定')), elevation: 0),
      body: ListView(
        children: [
          _buildLanguageOption(
            context,
            title: context.tr('繁體中文'),
            locale: const Locale('zh', 'TW'),
            isSelected: currentLocale.languageCode == 'zh' && currentLocale.countryCode == 'TW',
            onTap: () => localeProvider.setTraditionalChinese(),
          ),
          _buildLanguageOption(
            context,
            title: context.tr('英文'),
            locale: const Locale('en', 'US'),
            isSelected: currentLocale.languageCode == 'en' && currentLocale.countryCode == 'US',
            onTap: () => localeProvider.setEnglish(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required Locale locale,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(title: Text(title), trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null, onTap: onTap);
  }
}
