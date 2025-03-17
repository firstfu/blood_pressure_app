// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 幫助與反饋頁面，提供常見問題解答和用戶反饋功能

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations_extension.dart';
import '../themes/app_theme.dart';
import '../themes/typography_theme.dart';

/// HelpFeedbackPage 類
///
/// 實現應用程式的幫助與反饋頁面，提供常見問題解答和用戶反饋功能
class HelpFeedbackPage extends StatefulWidget {
  const HelpFeedbackPage({super.key});

  @override
  State<HelpFeedbackPage> createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  // 反饋表單控制器
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // 選擇的反饋類型
  late String _selectedFeedbackType;

  // 反饋類型列表
  late List<String> _feedbackTypes;

  // 展開的 FAQ 索引
  int? _expandedFaqIndex;

  @override
  void initState() {
    super.initState();
    // 初始化時設置默認值，等待 build 時再更新為多語系值
    _selectedFeedbackType = '功能建議';
    _feedbackTypes = ['功能建議', '問題回報', '使用疑問', '其他'];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在 context 可用時更新多語系值
    _selectedFeedbackType = context.tr('功能建議');
    _feedbackTypes = [context.tr('功能建議'), context.tr('問題回報'), context.tr('使用疑問'), context.tr('其他')];
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('幫助與反饋'), style: TypographyTheme.pageTitle),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryColor.withAlpha(26), AppTheme.backgroundColor, AppTheme.backgroundColor],
          ),
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondaryColor,
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  labelStyle: TypographyTheme.secondary.copyWith(fontWeight: FontWeight.w500),
                  unselectedLabelStyle: TypographyTheme.secondary,
                  labelPadding: const EdgeInsets.symmetric(vertical: 8),
                  tabs: [
                    Tab(icon: const Icon(Icons.help_outline, size: 18), text: context.tr('常見問題'), height: 46),
                    Tab(icon: const Icon(Icons.feedback_outlined, size: 18), text: context.tr('意見反饋'), height: 46),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // 常見問題頁面
                    _buildFaqTab(),

                    // 意見反饋頁面
                    _buildFeedbackTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建常見問題頁面
  Widget _buildFaqTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context.tr('常見問題解答'), Icons.question_answer_outlined),
          const SizedBox(height: 16),

          // FAQ 列表
          _buildFaqItem(0, context.tr('如何記錄我的血壓數據？'), context.tr('在應用底部導航欄點擊「記錄」按鈕，進入記錄頁面後點擊右下角的「+」按鈕，填寫您的血壓數值、心率等信息後點擊「保存記錄」即可。')),
          _buildFaqItem(1, context.tr('如何查看我的血壓趨勢？'), context.tr('在應用底部導航欄點擊「統計」按鈕，進入統計頁面後可以查看您的血壓趨勢圖表和統計數據。您可以選擇不同的時間範圍（7天、2週、1月或自訂）來查看相應的趨勢。')),
          _buildFaqItem(2, context.tr('如何設置測量提醒？'), context.tr('在「我的」頁面中點擊「提醒設定」，您可以設置每日測量血壓的提醒時間，系統會在設定的時間發送通知提醒您測量血壓。')),
          _buildFaqItem(3, context.tr('如何導出我的血壓數據？'), context.tr('在「統計」頁面中點擊右上角的「更多」按鈕，選擇「生成報告」選項，系統會生成一份包含您血壓數據的PDF報告，您可以保存或分享該報告。')),
          _buildFaqItem(
            4,
            context.tr('血壓分類標準是什麼？'),
            context.tr(
              '本應用採用國際通用的血壓分類標準：\n• 正常：收縮壓 < 120 mmHg 且舒張壓 < 80 mmHg\n• 臨界：收縮壓 120-139 mmHg 或舒張壓 80-89 mmHg\n• 高血壓一級：收縮壓 140-159 mmHg 或舒張壓 90-99 mmHg\n• 高血壓二級：收縮壓 ≥ 160 mmHg 或舒張壓 ≥ 100 mmHg\n• 高血壓危象：收縮壓 > 180 mmHg 或舒張壓 > 120 mmHg',
            ),
          ),
          _buildFaqItem(5, context.tr('如何更改應用語言？'), context.tr('在「我的」頁面中點擊「語言設定」，選擇您想要的語言（目前支持繁體中文和英文），系統會立即切換到所選語言。')),

          const SizedBox(height: 24),

          _buildSectionTitle(context.tr('聯絡我們'), Icons.contact_support_outlined),
          const SizedBox(height: 16),

          // 聯絡方式
          _buildContactItem(Icons.email_outlined, context.tr('電子郵件'), 'firefirstfu@gmail.com', () => _launchURL('mailto:firefirstfu@gmail.com')),
          _buildContactItem(
            Icons.language_outlined,
            context.tr('官方網站'),
            'www.bloodpressuremanager.com',
            () => _launchURL('https://www.bloodpressuremanager.com'),
          ),
          // _buildContactItem(Icons.support_agent_outlined, context.tr('客服熱線'), '+886 2 1234 5678', () => _launchURL('tel:+886212345678')),
        ],
      ),
    );
  }

  /// 構建意見反饋頁面
  Widget _buildFeedbackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context.tr('提交反饋'), Icons.edit_note_outlined),
          const SizedBox(height: 16),

          // 反饋表單
          Card(
            elevation: 2,
            shadowColor: AppTheme.primaryColor.withAlpha(51),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 反饋類型
                  Text(context.tr('反饋類型'), style: TypographyTheme.formLabel),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFeedbackType,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
                        items:
                            _feedbackTypes.map((String type) {
                              return DropdownMenuItem<String>(value: type, child: Text(type, style: TypographyTheme.body));
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedFeedbackType = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 反饋內容
                  Text(context.tr('反饋內容'), style: TypographyTheme.formLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 5,
                    style: TypographyTheme.body,
                    decoration: InputDecoration(
                      hintText: context.tr('請描述您的問題或建議...'),
                      hintStyle: TypographyTheme.inputHint,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 聯絡郵箱
                  Text(context.tr('聯絡郵箱（選填）'), style: TypographyTheme.formLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TypographyTheme.body,
                    decoration: InputDecoration(
                      hintText: context.tr('請輸入您的電子郵箱'),
                      hintStyle: TypographyTheme.inputHint,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.primaryColor, size: 18),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 提交按鈕
                  ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(context.tr('提交反饋'), style: TypographyTheme.buttonText),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 構建章節標題
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(title, style: TypographyTheme.subtitle.copyWith(color: AppTheme.primaryColor)),
      ],
    );
  }

  /// 構建 FAQ 項目
  Widget _buildFaqItem(int index, String question, String answer) {
    final bool isExpanded = _expandedFaqIndex == index;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: AppTheme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          setState(() {
            _expandedFaqIndex = isExpanded ? null : index;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(question, style: TypographyTheme.emphasized)),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 12),
                Padding(padding: const EdgeInsets.only(left: 32), child: Text(answer, style: TypographyTheme.body)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 構建聯絡方式項目
  Widget _buildContactItem(IconData icon, String title, String value, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: AppTheme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TypographyTheme.secondary),
                    const SizedBox(height: 4),
                    Text(value, style: TypographyTheme.emphasized.copyWith(color: AppTheme.primaryColor), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondaryColor, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  /// 提交反饋
  void _submitFeedback() {
    // 檢查反饋內容是否為空
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('請輸入反饋內容')), backgroundColor: AppTheme.warningColor));
      return;
    }

    // 顯示提交中對話框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(context.tr('正在提交反饋...'))],
            ),
          ),
    );

    // 模擬提交過程
    Future.delayed(const Duration(seconds: 2), () {
      // 檢查 widget 是否仍然掛載
      if (!mounted) return;

      // 關閉提交中對話框
      Navigator.pop(context);

      // 顯示提交成功對話框
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.successColor),
                  const SizedBox(width: 8),
                  Text(context.tr('提交成功'), style: TypographyTheme.subtitle),
                ],
              ),
              content: Text(context.tr('感謝您的反饋，我們會認真考慮您的意見和建議。'), style: TypographyTheme.body),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 清空表單
                    _feedbackController.clear();
                    _emailController.clear();
                    setState(() {
                      _selectedFeedbackType = context.tr('功能建議');
                    });
                  },
                  child: Text(context.tr('確定')),
                ),
              ],
            ),
      );
    });
  }

  /// 啟動 URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('無法打開連結')), backgroundColor: AppTheme.warningColor));
      }
    }
  }
}
