// @ Author: firstfu
// @ Create Time: 2024-03-23 18:50:42
// @ Description: Onboarding 頁面，為新用戶展示應用功能亮點

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:math' as math;
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

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  // 頁面控制器
  final PageController _pageController = PageController();
  // 當前頁面索引
  int _currentPage = 0;

  // 動畫控制器
  late AnimationController _animationController;

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
  void initState() {
    super.initState();
    // 初始化動畫控制器 - 3秒循環
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
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
          child: Stack(
            children: [
              // 背景動畫氣泡
              ..._buildBackgroundBubbles(),

              Column(
                children: [
                  // 狀態欄指示圖標
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(scale: value, child: child);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Text(
                              '${_currentPage + 1}/$_totalPages',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
                              ),
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
                          animationController: _animationController,
                          pageIndex: 0,
                          currentPage: _currentPage,
                        ),
                        OnboardingPageContent(
                          image: 'assets/images/onboarding_reminder.png',
                          titleKey: '追蹤健康_標題',
                          descriptionKey: '追蹤健康_描述',
                          gradientColors: _pageGradients[1],
                          animationController: _animationController,
                          pageIndex: 1,
                          currentPage: _currentPage,
                        ),
                        OnboardingPageContent(
                          image: 'assets/images/onboarding_analysis.png',
                          titleKey: '數據分析_標題',
                          descriptionKey: '數據分析_描述',
                          gradientColors: _pageGradients[2],
                          animationController: _animationController,
                          pageIndex: 2,
                          currentPage: _currentPage,
                        ),
                        OnboardingPageContent(
                          image: 'assets/images/onboarding_welcome.png',
                          titleKey: '數據分享_標題',
                          descriptionKey: '數據分享_描述',
                          gradientColors: _pageGradients[3],
                          animationController: _animationController,
                          pageIndex: 3,
                          currentPage: _currentPage,
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
                          effect: CustomizableEffect(
                            activeDotDecoration: DotDecoration(
                              width: 10,
                              height: 10,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              dotBorder: DotBorder(padding: 2, width: 2, color: Colors.white.withOpacity(0.5)),
                            ),
                            dotDecoration: DotDecoration(
                              width: 8,
                              height: 8,
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                              dotBorder: DotBorder(padding: 0, width: 0, color: Colors.transparent),
                            ),
                            spacing: 16,
                            activeColorOverride: (i) => Colors.white,
                            inActiveColorOverride: (i) => Colors.white.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 底部按鈕
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 跳過按鈕 (最後一頁沒有跳過按鈕)
                            if (_currentPage < _totalPages - 1)
                              _buildCustomButton(
                                onPressed: _completeOnboarding,
                                child: Text(
                                  context.tr('跳過_按鈕'),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                                isOutlined: true,
                              )
                            else
                              const SizedBox(width: 80),

                            // 下一步或開始按鈕
                            _buildCustomButton(
                              onPressed: () {
                                if (_currentPage < _totalPages - 1) {
                                  _pageController.nextPage(duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic);
                                } else {
                                  _completeOnboarding();
                                }
                              },
                              child: Text(
                                _currentPage < _totalPages - 1 ? context.tr('下一步_按鈕') : context.tr('開始_按鈕'),
                                style: TypographyTheme.buttonText.copyWith(color: _pageGradients[_currentPage][1], fontWeight: FontWeight.bold),
                              ),
                              isOutlined: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 自定義按鈕構建方法
  Widget _buildCustomButton({required VoidCallback onPressed, required Widget child, required bool isOutlined}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Material(
        color: isOutlined ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(26),
          splashColor: isOutlined ? Colors.white.withOpacity(0.2) : _pageGradients[_currentPage][1].withOpacity(0.2),
          highlightColor: isOutlined ? Colors.white.withOpacity(0.1) : _pageGradients[_currentPage][1].withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: isOutlined ? Border.all(color: Colors.white.withOpacity(0.8), width: 1) : null,
              boxShadow:
                  isOutlined ? null : [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // 背景浮動氣泡
  List<Widget> _buildBackgroundBubbles() {
    final random = math.Random(42); // 使用固定種子，使氣泡位置在重建後保持一致

    return List.generate(12, (index) {
      final size = random.nextDouble() * 40 + 20;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final top = random.nextDouble() * MediaQuery.of(context).size.height;
      final opacity = random.nextDouble() * 0.15 + 0.05;
      final delay = random.nextDouble() * 1000;

      return Positioned(
        left: left,
        top: top,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 1000 + delay.toInt()),
          builder: (context, value, child) {
            return Opacity(opacity: value * opacity, child: child);
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final offset = math.sin(_animationController.value * math.pi * 2 + index) * 10;
              return Transform.translate(
                offset: Offset(math.sin(_animationController.value * math.pi + index) * 8, offset),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(opacity)),
                ),
              );
            },
          ),
        ),
      );
    });
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
  final AnimationController animationController;
  final int pageIndex;
  final int currentPage;

  const OnboardingPageContent({
    super.key,
    required this.image,
    required this.titleKey,
    required this.descriptionKey,
    required this.gradientColors,
    required this.animationController,
    required this.pageIndex,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    // 計算頁面過渡動畫狀態
    final bool isActive = pageIndex == currentPage;
    final double opacity = isActive ? 1.0 : 0.0;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖片 - 添加動畫效果
          Expanded(
            flex: 3,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    // 創建脈動和浮動效果
                    final scale = 0.95 + 0.05 * math.sin(animationController.value * math.pi * 2);
                    final yOffset = 8.0 * math.sin(animationController.value * math.pi * 2);

                    return Transform.translate(offset: Offset(0, yOffset), child: Transform.scale(scale: scale, child: child));
                  },
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
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            final pulseScale = 0.9 + 0.1 * math.sin(animationController.value * math.pi * 2);
                            return Transform.scale(scale: pulseScale, child: child);
                          },
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [Colors.white.withOpacity(0.2), Colors.transparent], stops: const [0.6, 1.0]),
                            ),
                          ),
                        ),

                        // 主圖片
                        Image.asset(image, height: 220, fit: BoxFit.contain),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 標題和描述 - 添加動畫效果
          Expanded(
            flex: 1,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  // 確保 opacity 值在 0.0 到 1.0 之間
                  final safeOpacity = value.clamp(0.0, 1.0);
                  return Transform.translate(offset: Offset(0, 50 * (1 - value)), child: Opacity(opacity: safeOpacity, child: child));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
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
            ),
          ),
        ],
      ),
    );
  }
}
