// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 引導頁面，用於首次啟動時向用戶介紹應用功能

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../services/shared_prefs_service.dart';
import '../../themes/app_theme.dart';
import '../main_page.dart';
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

class _OnboardingPageState extends State<OnboardingPage> {
  // 頁面控制器
  final PageController _pageController = PageController();

  // 當前頁面索引
  int _currentPage = 0;

  // 頁面總數
  final int _totalPages = AppConstants.onBoardingTitles.length;

  // 頁面背景顏色
  final List<Color> _backgroundColors = [
    AppTheme.primaryColor.withAlpha(15),
    AppTheme.successColor.withAlpha(15),
    AppTheme.primaryDarkColor.withAlpha(15),
    AppTheme.alertColor.withAlpha(15),
  ];

  // 頁面主色調
  final List<Color> _primaryColors = [AppTheme.primaryColor, AppTheme.successColor, AppTheme.primaryDarkColor, AppTheme.alertColor];

  // 3D 模型圖標（臨時替代）
  final List<IconData> _tempIcons = [Icons.favorite, Icons.add_chart, Icons.bar_chart, Icons.notifications_active];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 完成 onBoarding 流程
  void _completeOnboarding() async {
    await SharedPrefsService.setOnBoardingCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  /// 跳到下一頁
  void _nextPage() {
    if (_currentPage == _totalPages - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  /// 跳過 onBoarding 流程
  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景漸變
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_backgroundColors[_currentPage], Colors.white],
                stops: const [0.3, 1.0],
              ),
            ),
          ),

          // 頁面內容
          SafeArea(
            child: Column(
              children: [
                // 頂部跳過按鈕
                Align(
                  alignment: Alignment.topRight,
                  child:
                      _currentPage < _totalPages - 1
                          ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextButton(
                              onPressed: _skipOnboarding,
                              style: TextButton.styleFrom(
                                foregroundColor: _primaryColors[_currentPage],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text(AppConstants.onBoardingSkip, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                          )
                          : const SizedBox(height: 56),
                ),

                // 主要內容區域
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
                      return _buildOnboardingPage(
                        title: AppConstants.onBoardingTitles[index],
                        description: AppConstants.onBoardingDescriptions[index],
                        imagePath: AppConstants.onBoardingImages[index],
                        index: index,
                      );
                    },
                  ),
                ),

                // 底部導航區域
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      // 頁面指示器
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_totalPages, (index) => _buildPageIndicator(index == _currentPage, index)),
                      ),

                      const SizedBox(height: 32),

                      // 下一步按鈕
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColors[_currentPage],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: Text(
                          _currentPage == _totalPages - 1 ? AppConstants.onBoardingStart : AppConstants.onBoardingNext,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 構建單個引導頁面
  Widget _buildOnboardingPage({required String title, required String description, required String imagePath, required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 3D 圖片區域
          Expanded(flex: 5, child: _buildImageContainer(imagePath, index)),

          const SizedBox(height: 40),

          // 標題
          Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor), textAlign: TextAlign.center),

          const SizedBox(height: 16),

          // 描述
          Text(description, style: TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor, height: 1.5), textAlign: TextAlign.center),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// 構建圖片容器
  Widget _buildImageContainer(String imagePath, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: _primaryColors[index].withAlpha(40), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 背景圓形裝飾
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: _primaryColors[index].withAlpha(15), shape: BoxShape.circle),
              ),
            ),

            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: _primaryColors[index].withAlpha(10), shape: BoxShape.circle),
              ),
            ),

            // 浮動裝飾元素
            ..._buildFloatingElements(index),

            // 主圖片
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('無法加載圖片: $imagePath, 使用臨時圖標替代');
                    return _buildFallbackImage(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 構建浮動裝飾元素
  List<Widget> _buildFloatingElements(int index) {
    final List<Widget> elements = [];
    final random = math.Random(index);

    // 添加3-5個浮動元素
    for (int i = 0; i < 4; i++) {
      final size = 8.0 + random.nextDouble() * 12;
      elements.add(
        Positioned(
          left: random.nextDouble() * 300,
          top: random.nextDouble() * 300,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: _primaryColors[index].withAlpha(100 + random.nextInt(155)), shape: BoxShape.circle),
          ),
        ),
      );
    }

    return elements;
  }

  /// 構建備用圖片（當無法加載圖片時）
  Widget _buildFallbackImage(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 3D 風格的圖標容器
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(color: _primaryColors[index].withAlpha(15), borderRadius: BorderRadius.circular(30)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 背景圓形
              Container(width: 140, height: 140, decoration: BoxDecoration(color: _primaryColors[index].withAlpha(30), shape: BoxShape.circle)),

              // 主圖標
              Icon(_tempIcons[index], size: 80, color: _primaryColors[index]),

              // 裝飾元素
              Positioned(
                top: 30,
                right: 30,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: _primaryColors[index].withAlpha(80), shape: BoxShape.circle),
                ),
              ),

              Positioned(
                bottom: 40,
                left: 30,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(color: _primaryColors[index].withAlpha(120), shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 構建頁面指示器
  Widget _buildPageIndicator(bool isActive, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? _primaryColors[_currentPage] : _primaryColors[_currentPage].withAlpha(40),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// 輔助函數 - 計算角度的正弦和餘弦
double sin(double angle) => math.sin(angle);
double cos(double angle) => math.cos(angle);
