// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 引導頁面，用於首次啟動時向用戶介紹應用功能

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../services/shared_prefs_service.dart';
import '../themes/app_theme.dart';
import 'main_page.dart';
import 'dart:math' as math;

/// OnboardingPage 類
///
/// 實現應用程式的引導頁面，用於首次啟動時向用戶介紹應用功能
/// 包含頁面滑動、跳過和完成功能
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  // 頁面控制器
  final PageController _pageController = PageController();

  // 動畫控制器
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  // 當前頁面索引
  int _currentPage = 0;
  int _previousPage = 0;

  // 頁面總數
  final int _totalPages = AppConstants.onBoardingTitles.length;

  // 臨時圖標列表，用於替代實際圖片
  final List<IconData> _tempIcons = [
    Icons.favorite, // 歡迎頁面 - 心臟圖標
    Icons.add_chart, // 記錄頁面 - 添加數據圖標
    Icons.bar_chart, // 分析頁面 - 圖表圖標
    Icons.notifications_active, // 提醒頁面 - 通知圖標
  ];

  // 臨時圖標顏色列表，為每個頁面提供不同的顏色
  final List<Color> _iconColors = [
    AppTheme.primaryColor, // 歡迎頁面 - 主色調
    AppTheme.successColor, // 記錄頁面 - 成功綠色
    AppTheme.primaryDarkColor, // 分析頁面 - 深藍色
    AppTheme.alertColor, // 提醒頁面 - 橙色
  ];

  // 臨時背景顏色列表，為每個頁面提供不同的背景色
  final List<Color> _backgroundColors = [
    AppTheme.primaryLightColor.withAlpha(26), // 歡迎頁面 - 淺藍色
    AppTheme.successLightColor.withAlpha(26), // 記錄頁面 - 淺綠色
    AppTheme.primaryLightColor.withAlpha(51), // 分析頁面 - 中藍色
    AppTheme.alertLightColor.withAlpha(26), // 提醒頁面 - 淺橙色
  ];

  // 輔助圖標列表，為每個頁面提供額外的視覺元素
  final List<List<IconData>> _supportIcons = [
    [Icons.monitor_heart, Icons.health_and_safety, Icons.bloodtype], // 歡迎頁面
    [Icons.edit, Icons.note_add, Icons.input], // 記錄頁面
    [Icons.trending_up, Icons.pie_chart, Icons.stacked_line_chart], // 分析頁面
    [Icons.alarm, Icons.timer, Icons.calendar_today], // 提醒頁面
  ];

  @override
  void initState() {
    super.initState();

    // 初始化動畫控制器
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    // 圖片動畫 - 從下方滑入
    _imageAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)));

    // 文字動畫 - 淡入
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.3, 0.8, curve: Curves.easeInOut)));

    // 按鈕動畫 - 從下方彈入
    _buttonAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 1.0, curve: Curves.elasticOut)));

    // 背景顏色動畫 - 初始化
    _updateBackgroundColorAnimation();

    // 啟動初始動畫
    _animationController.forward();

    // 監聽頁面滑動
    _pageController.addListener(_onPageScroll);
  }

  // 更新背景顏色動畫
  void _updateBackgroundColorAnimation() {
    _backgroundColorAnimation = ColorTween(
      begin: _previousPage < _totalPages ? _backgroundColors[_previousPage] : _backgroundColors[0],
      end: _currentPage < _totalPages ? _backgroundColors[_currentPage] : _backgroundColors[0],
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  // 頁面滑動監聽
  void _onPageScroll() {
    // 檢測頁面變化
    if (_pageController.page != null) {
      final int currentPage = _pageController.page!.round();
      if (currentPage != _currentPage && currentPage < _totalPages) {
        setState(() {
          _previousPage = _currentPage;
          _currentPage = currentPage;

          // 更新背景顏色動畫
          _updateBackgroundColorAnimation();

          // 重置並啟動動畫
          _animationController.reset();
          _animationController.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// 完成 onBoarding 流程
  ///
  /// 保存用戶已完成 onBoarding 的狀態，並導航到主頁面
  void _completeOnboarding() async {
    await SharedPrefsService.setOnBoardingCompleted();
    if (mounted) {
      // 添加退出動畫
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  /// 跳到下一頁
  ///
  /// 如果當前是最後一頁，則完成 onBoarding 流程
  /// 否則跳到下一頁
  void _nextPage() {
    if (_currentPage == _totalPages - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    }
  }

  /// 跳過 onBoarding 流程
  ///
  /// 直接完成 onBoarding 流程，跳到主頁面
  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
            actions: [
              // 跳過按鈕
              if (_currentPage < _totalPages - 1)
                TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    AppConstants.onBoardingSkip,
                    style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // 頁面內容
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    // 只為當前頁面應用動畫
                    final bool isCurrentPage = index == _currentPage;

                    return _buildOnboardingPage(
                      title: AppConstants.onBoardingTitles[index],
                      description: AppConstants.onBoardingDescriptions[index],
                      imagePath: AppConstants.onBoardingImages[index],
                      iconData: _tempIcons[index],
                      iconColor: _iconColors[index],
                      backgroundColor: _backgroundColors[index],
                      supportIcons: _supportIcons[index],
                      index: index,
                      applyAnimation: isCurrentPage,
                    );
                  },
                ),
              ),

              // 頁面指示器
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalPages, (index) => _buildPageIndicator(index == _currentPage)),
                ),
              ),

              // 底部按鈕 - 添加動畫效果
              Transform.translate(
                offset: Offset(0, _buttonAnimation.value),
                child: AnimatedOpacity(
                  opacity: _textAnimation.value,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: _iconColors[_currentPage], // 使用當前頁面的主色調
                        elevation: 4.0 * _textAnimation.value, // 動態陰影
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1 ? AppConstants.onBoardingStart : AppConstants.onBoardingNext,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 構建單個引導頁面
  ///
  /// 包含圖片、標題和描述
  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String imagePath,
    required IconData iconData,
    required Color iconColor,
    required Color backgroundColor,
    required List<IconData> supportIcons,
    required int index,
    bool applyAnimation = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖片或臨時圖標 - 添加動畫效果
          Expanded(
            flex: 3,
            child: Transform.translate(
              offset: applyAnimation ? Offset(0, _imageAnimation.value) : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: applyAnimation ? _textAnimation.value : 1.0,
                child: _buildImageOrPlaceholder(imagePath, iconData, iconColor, backgroundColor, supportIcons, index),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 標題 - 添加動畫效果
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: applyAnimation ? _textAnimation.value : 1.0,
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // 描述 - 添加動畫效果
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: applyAnimation ? _textAnimation.value * 0.8 : 1.0,
            child: Text(
              description,
              style: const TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// 構建圖片或臨時占位圖
  ///
  /// 嘗試加載圖片，如果失敗則顯示臨時圖標
  Widget _buildImageOrPlaceholder(
    String imagePath,
    IconData iconData,
    Color iconColor,
    Color backgroundColor,
    List<IconData> supportIcons,
    int index,
  ) {
    return Hero(
      tag: 'onboarding_image_$index',
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('無法加載圖片: $imagePath, 使用臨時圖標替代');
              // 如果圖片加載失敗，返回臨時圖標
              return _buildPlaceholderWithIcons(iconData, iconColor, backgroundColor, supportIcons, index);
            },
          ),
        ),
      ),
    );
  }

  /// 構建帶有多個圖標的臨時占位圖
  ///
  /// 顯示主圖標和輔助圖標，提供更豐富的視覺效果
  Widget _buildPlaceholderWithIcons(IconData mainIcon, Color iconColor, Color backgroundColor, List<IconData> supportIcons, int index) {
    // 根據頁面索引選擇不同的布局
    switch (index) {
      case 0: // 歡迎頁面 - 心臟和健康相關圖標
        return _buildWelcomePlaceholder(mainIcon, iconColor, supportIcons);
      case 1: // 記錄頁面 - 表單和輸入相關圖標
        return _buildRecordPlaceholder(mainIcon, iconColor, supportIcons);
      case 2: // 分析頁面 - 圖表和趨勢相關圖標
        return _buildAnalysisPlaceholder(mainIcon, iconColor, supportIcons);
      case 3: // 提醒頁面 - 通知和時間相關圖標
        return _buildReminderPlaceholder(mainIcon, iconColor, supportIcons);
      default:
        return _buildDefaultPlaceholder(mainIcon, iconColor);
    }
  }

  /// 構建歡迎頁面的臨時占位圖
  Widget _buildWelcomePlaceholder(IconData mainIcon, Color iconColor, List<IconData> supportIcons) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景圓形 - 添加脈動動畫
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.95, end: 1.05),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(width: 240, height: 240, decoration: BoxDecoration(color: iconColor.withAlpha(26), shape: BoxShape.circle)),
              );
            },
            onEnd: () {
              // 循環動畫
              setState(() {});
            },
          ),

          // 主圖標 - 添加旋轉動畫
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 0.05),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.rotate(angle: math.sin(value * 10) * 0.05, child: Icon(mainIcon, size: 120, color: iconColor));
            },
            onEnd: () {
              // 循環動畫
              setState(() {});
            },
          ),

          // 輔助圖標 - 圍繞主圖標旋轉
          ...List.generate(supportIcons.length, (i) {
            // 為每個圖標設置不同的動畫起始點
            final double startAngle = i * (2 * math.pi / supportIcons.length);

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: startAngle, end: startAngle + 2 * math.pi),
              duration: Duration(milliseconds: 10000 + i * 500), // 不同速度
              curve: Curves.linear,
              builder: (context, angle, child) {
                return Positioned(
                  left: 120 + 100 * math.cos(angle),
                  top: 120 + 100 * math.sin(angle),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.8, end: 1.2),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 5, offset: const Offset(0, 2))],
                          ),
                          child: Icon(supportIcons[i], size: 24, color: iconColor),
                        ),
                      );
                    },
                    onEnd: () {
                      // 循環動畫
                      setState(() {});
                    },
                  ),
                );
              },
              onEnd: () {
                // 循環動畫
                setState(() {});
              },
            );
          }),
        ],
      ),
    );
  }

  /// 構建記錄頁面的臨時占位圖
  Widget _buildRecordPlaceholder(IconData mainIcon, Color iconColor, List<IconData> supportIcons) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 手機框架 - 添加浮動動畫
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: -3.0, end: 3.0),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: iconColor.withAlpha(77), width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 表單標題
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: double.infinity,
                        color: iconColor.withAlpha(26),
                        child: Icon(supportIcons[0], size: 30, color: iconColor),
                      ),

                      const SizedBox(height: 20),

                      // 輸入欄位 - 添加打字動畫
                      ...List.generate(2, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(color: Colors.grey.withAlpha(26), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Icon(supportIcons[i + 1], size: 20, color: iconColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0.2, end: 1.0),
                                    duration: Duration(milliseconds: 1500 + i * 500),
                                    curve: Curves.easeInOut,
                                    builder: (context, value, child) {
                                      return Container(height: 2, width: double.infinity * value, color: iconColor.withAlpha(77));
                                    },
                                    onEnd: () {
                                      // 循環動畫
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      // 提交按鈕 - 添加脈動動畫
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.95, end: 1.05),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.check, color: Colors.white),
                            ),
                          );
                        },
                        onEnd: () {
                          // 循環動畫
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            onEnd: () {
              // 循環動畫
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  /// 構建分析頁面的臨時占位圖
  Widget _buildAnalysisPlaceholder(IconData mainIcon, Color iconColor, List<IconData> supportIcons) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖表容器 - 添加浮動動畫
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: -2.0, end: 2.0),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Container(
                  width: 280,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 圖表標題
                      Row(
                        children: [
                          Icon(mainIcon, size: 24, color: iconColor),
                          const SizedBox(width: 8),
                          Text('血壓趨勢', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 模擬圖表 - 添加增長動畫
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(7, (i) {
                            final double targetHeight = 20.0 + (i % 3) * 15.0 + (i % 2) * 10.0;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 0, end: targetHeight),
                                  duration: Duration(milliseconds: 1200 + i * 150),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, height, child) {
                                    return Container(
                                      width: 20,
                                      height: height,
                                      decoration: BoxDecoration(color: iconColor.withAlpha(128 + (i * 20)), borderRadius: BorderRadius.circular(4)),
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text('${i + 1}', style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor.withAlpha(179))),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onEnd: () {
              // 循環動畫
              setState(() {});
            },
          ),

          const SizedBox(height: 20),

          // 數據卡片 - 添加彈跳動畫
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(supportIcons.length, (i) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 800 + i * 200),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 5, offset: const Offset(0, 2))],
                      ),
                      child: Icon(supportIcons[i], size: 30, color: iconColor),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 構建提醒頁面的臨時占位圖
  Widget _buildReminderPlaceholder(IconData mainIcon, Color iconColor, List<IconData> supportIcons) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 通知圖標 - 添加脈動動畫
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.9, end: 1.1),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: iconColor.withAlpha(77), blurRadius: 20, spreadRadius: 5)],
                  ),
                  child: Icon(mainIcon, size: 60, color: iconColor),
                ),
              );
            },
            onEnd: () {
              // 循環動畫
              setState(() {});
            },
          ),

          const SizedBox(height: 30),

          // 通知列表 - 添加滑入動畫
          ...List.generate(2, (i) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 100.0, end: 0.0),
              duration: Duration(milliseconds: 800 + i * 200),
              curve: Curves.easeOutCubic,
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: Container(
                    width: 280,
                    height: 70,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 5, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(color: iconColor.withAlpha(26), shape: BoxShape.circle),
                          child: Icon(supportIcons[i], size: 24, color: iconColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 14,
                                width: 150,
                                decoration: BoxDecoration(color: AppTheme.textPrimaryColor.withAlpha(179), borderRadius: BorderRadius.circular(2)),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 10,
                                width: 100,
                                decoration: BoxDecoration(color: AppTheme.textSecondaryColor.withAlpha(128), borderRadius: BorderRadius.circular(2)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  /// 構建默認的臨時占位圖
  Widget _buildDefaultPlaceholder(IconData iconData, Color iconColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 大圖標 - 添加旋轉動畫
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 2 * math.pi),
            duration: const Duration(milliseconds: 3000),
            curve: Curves.linear,
            builder: (context, value, child) {
              return Transform.rotate(angle: value, child: Icon(iconData, size: 100, color: iconColor));
            },
            onEnd: () {
              // 循環動畫
              setState(() {});
            },
          ),

          const SizedBox(height: 20),

          // 圖片路徑提示
          Text('圖片將顯示在此處', style: TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor)),
        ],
      ),
    );
  }

  /// 構建頁面指示器
  ///
  /// 當前頁面顯示為實心圓點，其他頁面顯示為空心圓點
  Widget _buildPageIndicator(bool isActive) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: isActive ? 0.0 : 1.0, end: isActive ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8 + (16 * value), // 動態寬度
          decoration: BoxDecoration(
            color: isActive ? _iconColors[_currentPage] : _iconColors[_currentPage].withAlpha(77),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}

// 輔助函數 - 計算角度的正弦和餘弦
double sin(double angle) => math.sin(angle);
double cos(double angle) => math.cos(angle);
