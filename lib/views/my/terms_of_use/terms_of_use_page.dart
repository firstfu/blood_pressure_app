// @ Author: firstfu
// @ Create Time: 2024-05-15 16:50:18
// @ Description: 血壓管家 App 使用條款頁面，顯示應用的使用條款內容

import 'package:flutter/material.dart';
import '../../../l10n/app_localizations_extension.dart';

/// TermsOfUsePage 類
///
/// 實現應用程式的使用條款頁面，顯示應用的使用條款內容
class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('使用條款')),
        centerTitle: true,
        backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF121212) : theme.appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 使用條款內容
              _buildSectionTitle(context, context.tr('1. 接受條款')),
              _buildParagraph(context, context.tr('通過下載、安裝或使用血壓管家應用程式（以下簡稱"應用程式"），您同意受本使用條款的約束。如果您不同意這些條款，請勿使用本應用程式。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('2. 使用許可')),
              _buildParagraph(context, context.tr('我們授予您有限的、非獨占的、不可轉讓的許可，以在您擁有或控制的裝置上下載、安裝和使用本應用程式，僅供個人、非商業用途。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('3. 使用限制')),
              _buildParagraph(context, context.tr('您同意不會：')),
              _buildBulletPoint(context, context.tr('出租、租賃、出借、銷售、再分發或再授權本應用程式')),
              _buildBulletPoint(context, context.tr('複製、反編譯、反向工程、拆解、嘗試獲取源代碼、修改或創建本應用程式的衍生作品')),
              _buildBulletPoint(context, context.tr('移除、更改或遮蓋本應用程式中的任何版權、商標或其他專有權聲明')),
              _buildBulletPoint(context, context.tr('使用本應用程式進行任何非法、欺詐或未經授權的目的')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('4. 健康資訊免責聲明')),
              _buildParagraph(context, context.tr('本應用程式提供的資訊僅供參考，不構成醫療建議。應用程式不應被用作診斷工具或替代專業醫療諮詢、診斷或治療。')),
              _buildParagraph(context, context.tr('我們建議您在做出任何健康相關決定前諮詢合格的醫療專業人員。如果您認為自己可能有醫療緊急情況，請立即聯絡您的醫生或撥打緊急服務電話。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('5. 用戶內容')),
              _buildParagraph(context, context.tr('您對您通過本應用程式提交、發布或顯示的任何內容（包括但不限於血壓讀數、健康資料等）負全部責任。')),
              _buildParagraph(context, context.tr('通過提交內容，您授予我們全球性的、非獨占的、免版稅的許可，以使用、複製、修改、創建衍生作品、分發、公開展示和以其他方式利用該內容，用於提供和改進我們的服務。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('6. 隱私')),
              _buildParagraph(context, context.tr('我們根據我們的隱私政策收集、使用和處理您的個人資料。通過使用本應用程式，您同意我們按照隱私政策處理您的資訊。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('7. 終止')),
              _buildParagraph(context, context.tr('如果您違反本使用條款的任何條款，我們可以終止或暫停您對本應用程式的訪問，恕不另行通知。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('8. 免責聲明')),
              _buildParagraph(context, context.tr('本應用程式按"現狀"和"可用"的基礎提供，不提供任何形式的明示或暗示保證。')),
              _buildParagraph(context, context.tr('我們不保證本應用程式將無錯誤或不間斷運行，也不保證缺陷將被糾正，或本應用程式或提供它的伺服器沒有病毒或其他有害成分。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('9. 責任限制')),
              _buildParagraph(context, context.tr('在法律允許的最大範圍內，我們不對因使用或無法使用本應用程式而導致的任何直接、間接、附帶、特殊、衍生或懲罰性損害負責。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('10. 條款變更')),
              _buildParagraph(context, context.tr('我們保留隨時修改或替換這些條款的權利。修改後的條款將在應用程式中發布。繼續使用本應用程式即表示您同意受修改後的條款約束。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('11. 適用法律')),
              _buildParagraph(context, context.tr('這些條款受中華民國法律管轄，不考慮法律衝突原則。')),

              const SizedBox(height: 16),

              _buildSectionTitle(context, context.tr('12. 聯絡我們')),
              _buildParagraph(context, context.tr('如果您對本使用條款有任何疑問或建議，請通過以下方式聯絡我們：')),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryColor)),
    );
  }

  /// 構建段落文字
  Widget _buildParagraph(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: TextStyle(fontSize: 15, height: 1.5, color: theme.textTheme.bodyMedium?.color)),
    );
  }

  /// 構建項目符號點
  Widget _buildBulletPoint(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 8), child: Icon(Icons.circle, size: 6, color: theme.primaryColor)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 15, height: 1.5, color: theme.textTheme.bodyMedium?.color))),
        ],
      ),
    );
  }
}
