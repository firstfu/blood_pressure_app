// @ Author: firstfu
// @ Create Time: 2024-03-23 18:50:42
// @ Description: Onboarding 頁面，為新用戶展示應用功能亮點

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../themes/app_theme.dart';
import '../../themes/typography_theme.dart';
import '../../services/shared_prefs_service.dart';
import '../../l10n/app_localizations_extension.dart';
import '../../views/main_page.dart'; // 導入 MainPage

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
  static const int _totalPages = 4;

  // 定義每個頁面的漸層顏色
  final List<List<Color>> _pageGradients = [
    [const Color(0xFF1565C0), const Color(0xFF1976D2), const Color(0xFF42A5F5)], // 第一頁藍色漸層
    [const Color(0xFF7986CB), const Color(0xFF5C6BC0), const Color(0xFF3949AB)], // 第二頁紫藍色漸層
    [const Color(0xFF0277BD), const Color(0xFF0288D1), const Color(0xFF039BE5)], // 第三頁淺藍色漸層
    [const Color(0xFF00838F), const Color(0xFF0097A7), const Color(0xFF00ACC1)], // 第四頁藍綠色漸層
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 完成 Onboarding 並導航到主頁
  Future<void> _completeOnboarding() async {
    // 設置 onBoarding 完成狀態
    await SharedPrefsService.setOnBoardingCompleted();

    // 導航到主頁 - 修復路由問題
    if (!mounted) return;

    // 使用 pushReplacement 直接導航到 MainPage，而不是使用命名路由
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用漸層背景
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: _pageGradients[_currentPage]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 狀態欄指示圖標
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        '${_currentPage + 1}/$_totalPages',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
                        ),
                      ),
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
                      titleKey: '記錄血壓_標題',
                      descriptionKey: '記錄血壓_描述',
                      gradientColors: _pageGradients[0],
                    ),
                    OnboardingPageContent(
                      image: 'assets/images/onboarding_reminder.png',
                      titleKey: '追蹤健康_標題',
                      descriptionKey: '追蹤健康_描述',
                      gradientColors: _pageGradients[1],
                    ),
                    OnboardingPageContent(
                      image: 'assets/images/onboarding_analysis.png',
                      titleKey: '數據分析_標題',
                      descriptionKey: '數據分析_描述',
                      gradientColors: _pageGradients[2],
                    ),
                    OnboardingPageContent(
                      image: 'assets/images/onboarding_welcome.png',
                      titleKey: '數據分享_標題',
                      descriptionKey: '數據分享_描述',
                      gradientColors: _pageGradients[3],
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
                        dotColor: Colors.white.withOpacity(0.4),
                        radius: 5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 底部按鈕
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 跳過按鈕 (最後一頁沒有跳過按鈕)
                        if (_currentPage < _totalPages - 1)
                          TextButton(
                            onPressed: _completeOnboarding,
                            child: Text(context.tr('跳過_按鈕'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                          )
                        else
                          const SizedBox(width: 80),

                        // 下一步或開始按鈕
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage < _totalPages - 1) {
                                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                              } else {
                                _completeOnboarding();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: _pageGradients[_currentPage][1],
                              minimumSize: const Size(140, 52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              elevation: 0,
                            ),
                            child: Text(
                              _currentPage < _totalPages - 1 ? context.tr('下一步_按鈕') : context.tr('開始_按鈕'),
                              style: TypographyTheme.buttonText.copyWith(color: _pageGradients[_currentPage][1], fontWeight: FontWeight.bold),
                            ),
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
  final List<Color> gradientColors;

  const OnboardingPageContent({super.key, required this.image, required this.titleKey, required this.descriptionKey, required this.gradientColors});

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
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)], radius: 0.8),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, spreadRadius: 5)],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 背景發光效果
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent], stops: const [0.6, 1.0]),
                    ),
                  ),
                  // 主圖片
                  Image.asset(image, height: 220, fit: BoxFit.contain),
                ],
              ),
            ),
          ),

          // 標題和描述
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr(titleKey),
                    style: TypographyTheme.largeTitle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      shadows: [const Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 描述文字
                  Flexible(
                    child: Text(
                      context.tr(descriptionKey),
                      textAlign: TextAlign.center,
                      style: TypographyTheme.body.copyWith(color: Colors.white, height: 1.4),
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
}
