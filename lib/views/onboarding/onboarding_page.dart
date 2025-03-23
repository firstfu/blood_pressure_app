/**
 * @ Author: firstfu
 * @ Create Time: 2024-03-23 18:50:42
 * @ Description: Onboarding 頁面，為新用戶展示應用功能亮點
 */

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../themes/app_theme.dart';
import '../../themes/typography_theme.dart';
import '../../services/shared_prefs_service.dart';
import '../../l10n/app_localizations_extension.dart';

/// Onboarding 頁面
///
/// 應用程式首次啟動時向用戶展示主要功能亮點
/// 包含功能介紹輪播和導航按鈕
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // 頁面控制器
  final PageController _pageController = PageController();
  // 當前頁面索引
  int _currentPage = 0;
  // 總頁數
  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 完成 Onboarding 並導航到主頁
  Future<void> _completeOnboarding() async {
    // 設置 onBoarding 完成狀態
    await SharedPrefsService.setOnBoardingCompleted();

    // 導航到主頁
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // 使用應用程式的主色調
      body: SafeArea(
        child: Column(
          children: [
            // 狀態欄指示圖標
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    context.formatTr('onboarding_page_indicator', [(_currentPage + 1).toString(), _totalPages.toString()]),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // 主要內容 - 輪播頁面
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  OnboardingPageContent(
                    image: 'assets/images/onboarding_record.png',
                    titleKey: 'onboarding_manage_goals_title',
                    descriptionKey: 'onboarding_manage_goals_description',
                  ),
                  OnboardingPageContent(
                    image: 'assets/images/onboarding_reminder.png',
                    titleKey: 'onboarding_set_schedule_title',
                    descriptionKey: 'onboarding_set_schedule_description',
                  ),
                  OnboardingPageContent(
                    image: 'assets/images/onboarding_analysis.png',
                    titleKey: 'onboarding_todo_list_title',
                    descriptionKey: 'onboarding_todo_list_description',
                  ),
                ],
              ),
            ),

            // 底部導航區域
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // 頁面指示器
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _totalPages,
                    effect: WormEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor: Colors.white,
                      dotColor: AppTheme.primaryLightColor.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 底部按鈕
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 跳過按鈕 (最後一頁沒有跳過按鈕)
                      if (_currentPage < _totalPages - 1)
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(context.tr('onboarding_skip_button'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        )
                      else
                        const SizedBox(width: 80),

                      // 下一步或開始按鈕
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _totalPages - 1) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          } else {
                            _completeOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          minimumSize: const Size(120, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentPage < _totalPages - 1 ? context.tr('onboarding_next_button') : context.tr('onboarding_start_button'),
                          style: TypographyTheme.buttonText.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 單個 Onboarding 頁面內容
///
/// 包含圖片、標題和描述文字
class OnboardingPageContent extends StatelessWidget {
  final String image;
  final String titleKey;
  final String descriptionKey;

  const OnboardingPageContent({super.key, required this.image, required this.titleKey, required this.descriptionKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖片
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
              child: Center(child: Image.asset(image, height: 240, fit: BoxFit.contain)),
            ),
          ),

          // 標題
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(context.tr(titleKey), style: TypographyTheme.largeTitle.copyWith(color: Colors.white)),
                const SizedBox(height: 16),

                // 描述文字
                Text(context.tr(descriptionKey), textAlign: TextAlign.center, style: TypographyTheme.body.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
