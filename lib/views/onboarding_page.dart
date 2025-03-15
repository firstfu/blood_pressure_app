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

class _OnboardingPageState extends State<OnboardingPage> {
  // 頁面控制器
  final PageController _pageController = PageController();

  // 當前頁面索引
  int _currentPage = 0;

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
    AppTheme.primaryLightColor.withAlpha(15), // 歡迎頁面 - 淺藍色
    AppTheme.successLightColor.withAlpha(15), // 記錄頁面 - 淺綠色
    AppTheme.primaryLightColor.withAlpha(20), // 分析頁面 - 中藍色
    AppTheme.alertLightColor.withAlpha(15), // 提醒頁面 - 淺橙色
  ];

  // 輔助圖標列表，為每個頁面提供額外的視覺元素
  final List<List<IconData>> _supportIcons = [
    [Icons.monitor_heart, Icons.health_and_safety, Icons.bloodtype], // 歡迎頁面
    [Icons.edit, Icons.note_add, Icons.input], // 記錄頁面
    [Icons.trending_up, Icons.pie_chart, Icons.stacked_line_chart], // 分析頁面
    [Icons.alarm, Icons.timer, Icons.calendar_today], // 提醒頁面
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 完成 onBoarding 流程
  ///
  /// 保存用戶已完成 onBoarding 的狀態，並導航到主頁面
  void _completeOnboarding() async {
    await SharedPrefsService.setOnBoardingCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainPage()));
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
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
                return _buildOnboardingPage(
                  title: AppConstants.onBoardingTitles[index],
                  description: AppConstants.onBoardingDescriptions[index],
                  imagePath: AppConstants.onBoardingImages[index],
                  iconData: _tempIcons[index],
                  iconColor: _iconColors[index],
                  backgroundColor: _backgroundColors[index],
                  supportIcons: _supportIcons[index],
                  index: index,
                );
              },
            ),
          ),

          // 頁面指示器 - 簡潔設計
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) => _buildPageIndicator(index == _currentPage)),
            ),
          ),

          // 底部按鈕 - 簡潔設計
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: _iconColors[_currentPage], // 使用當前頁面的主色調
                elevation: 0, // 移除陰影，更加簡約
              ),
              child: Text(
                _currentPage == _totalPages - 1 ? AppConstants.onBoardingStart : AppConstants.onBoardingNext,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖片或臨時圖標
          Expanded(flex: 3, child: _buildImageOrPlaceholder(imagePath, iconData, iconColor, backgroundColor, supportIcons, index)),

          const SizedBox(height: 32),

          // 標題
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // 描述
          Text(description, style: const TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor, height: 1.5), textAlign: TextAlign.center),

          const SizedBox(height: 32),
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
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
          // 背景圓形
          Container(width: 240, height: 240, decoration: BoxDecoration(color: iconColor.withAlpha(15), shape: BoxShape.circle)),

          // 主圖標
          Icon(mainIcon, size: 100, color: iconColor),

          // 輔助圖標 - 圍繞主圖標排列
          ...List.generate(supportIcons.length, (i) {
            final double angle = i * (2 * math.pi / supportIcons.length);
            return Positioned(
              left: 120 + 90 * math.cos(angle),
              top: 120 + 90 * math.sin(angle),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 2, offset: const Offset(0, 1))],
                ),
                child: Icon(supportIcons[i], size: 20, color: iconColor),
              ),
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
          // 手機框架
          Container(
            width: 200,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: iconColor.withAlpha(40), width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 表單標題
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  color: iconColor.withAlpha(15),
                  child: Icon(supportIcons[0], size: 28, color: iconColor),
                ),

                const SizedBox(height: 20),

                // 輸入欄位
                ...List.generate(2, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey.withAlpha(15), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(supportIcons[i + 1], size: 20, color: iconColor),
                          const SizedBox(width: 10),
                          Expanded(child: Container(height: 1.5, color: iconColor.withAlpha(40))),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // 提交按鈕
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              ],
            ),
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
          // 圖表容器
          Container(
            width: 280,
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 圖表標題
                Row(
                  children: [
                    Icon(mainIcon, size: 22, color: iconColor),
                    const SizedBox(width: 8),
                    Text('血壓趨勢', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor)),
                  ],
                ),

                const SizedBox(height: 16),

                // 模擬圖表
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(7, (i) {
                      final double height = 20.0 + (i % 3) * 15.0 + (i % 2) * 10.0;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 20,
                            height: height,
                            decoration: BoxDecoration(color: iconColor.withAlpha(80 + (i * 10)), borderRadius: BorderRadius.circular(4)),
                          ),
                          const SizedBox(height: 4),
                          Text('${i + 1}', style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor.withAlpha(140))),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 數據卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(supportIcons.length, (i) {
              return Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 3, offset: const Offset(0, 1))],
                ),
                child: Icon(supportIcons[i], size: 28, color: iconColor),
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
          // 通知圖標
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: iconColor.withAlpha(40), blurRadius: 10, spreadRadius: 2)],
            ),
            child: Icon(mainIcon, size: 50, color: iconColor),
          ),

          const SizedBox(height: 30),

          // 通知列表
          ...List.generate(2, (i) {
            return Container(
              width: 280,
              height: 70,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 3, offset: const Offset(0, 1))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: iconColor.withAlpha(15), shape: BoxShape.circle),
                    child: Icon(supportIcons[i], size: 22, color: iconColor),
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
                          decoration: BoxDecoration(color: AppTheme.textPrimaryColor.withAlpha(140), borderRadius: BorderRadius.circular(2)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: 100,
                          decoration: BoxDecoration(color: AppTheme.textSecondaryColor.withAlpha(100), borderRadius: BorderRadius.circular(2)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          // 大圖標
          Icon(iconData, size: 90, color: iconColor),

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? _iconColors[_currentPage] : _iconColors[_currentPage].withAlpha(40),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// 輔助函數 - 計算角度的正弦和餘弦
double sin(double angle) => math.sin(angle);
double cos(double angle) => math.cos(angle);
