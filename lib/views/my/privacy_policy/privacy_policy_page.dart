// @ Author: firstfu
// @ Create Time: 2024-05-15 16:45:23
// @ Description: 血壓管家 App 隱私政策頁面，顯示應用的隱私政策內容

import 'package:flutter/material.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../themes/app_theme.dart';

/// PrivacyPolicyPage 類
///
/// 實現應用程式的隱私政策頁面，顯示應用的隱私政策內容
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Privacy Policy')),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 隱私政策內容
              _buildSectionTitle(context, context.tr('1. 資料收集')),
              _buildParagraph(context, context.tr('我們收集的資訊包括但不限於：')),
              _buildBulletPoint(context, context.tr('您提供的個人資料，如姓名、電子郵件地址等')),
              _buildBulletPoint(context, context.tr('您輸入的健康資料，如血壓讀數、心率等')),
              _buildBulletPoint(context, context.tr('裝置資訊，如裝置型號、作業系統版本等')),
              _buildBulletPoint(context, context.tr('使用應用程式的相關資訊，如使用頻率、功能使用情況等')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('2. 資料使用')),
              _buildParagraph(context, context.tr('我們使用收集的資訊用於：')),
              _buildBulletPoint(context, context.tr('提供、維護和改進我們的服務')),
              _buildBulletPoint(context, context.tr('為您提供個人化的健康建議和提醒')),
              _buildBulletPoint(context, context.tr('分析使用模式以改進用戶體驗')),
              _buildBulletPoint(context, context.tr('與您溝通有關服務更新和新功能')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('3. 資料共享')),
              _buildParagraph(context, context.tr('我們不會出售您的個人資料。我們可能在以下情況下共享您的資訊：')),
              _buildBulletPoint(context, context.tr('經您明確同意')),
              _buildBulletPoint(context, context.tr('與提供服務所需的第三方服務提供商共享')),
              _buildBulletPoint(context, context.tr('為遵守法律要求或保護我們的權利')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('4. 資料安全')),
              _buildParagraph(context, context.tr('我們採取合理的安全措施保護您的資訊不被未經授權的訪問、使用或披露。然而，沒有任何網絡或電子存儲方法是100%安全的。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('5. 您的權利')),
              _buildParagraph(context, context.tr('您有權：')),
              _buildBulletPoint(context, context.tr('訪問、更正或刪除您的個人資料')),
              _buildBulletPoint(context, context.tr('限制或反對我們處理您的資料')),
              _buildBulletPoint(context, context.tr('要求資料可攜性')),
              _buildBulletPoint(context, context.tr('撤回同意')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('6. 兒童隱私')),
              _buildParagraph(context, context.tr('我們的服務不面向13歲以下兒童。我們不會故意收集13歲以下兒童的個人資料。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('7. 隱私政策變更')),
              _buildParagraph(context, context.tr('我們可能會不時更新本隱私政策。更新後的政策將在應用程式中發布，並在重大變更時通知您。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('8. 聯絡我們')),
              _buildParagraph(context, context.tr('如果您對本隱私政策有任何疑問或建議，請通過以下方式聯絡我們：')),
              _buildParagraph(context, context.tr('電子郵件: firefirstfu@gmail.com')),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建章節標題
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
    );
  }

  /// 構建段落文字
  Widget _buildParagraph(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5, color: AppTheme.textPrimaryColor)),
    );
  }

  /// 構建項目符號點
  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 8), child: Icon(Icons.circle, size: 6, color: AppTheme.primaryColor)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5, color: AppTheme.textPrimaryColor))),
        ],
      ),
    );
  }
}
