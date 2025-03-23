/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-23 17:31:42
 * @ Description: 血壓記錄 App 引導頁面
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/app_constants.dart';
import '../../services/shared_prefs_service.dart';
import '../../themes/app_theme.dart';
import '../main_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(image: 'assets/images/onboarding_welcome.png', title: '歡迎使用血壓管家', description: '專業的血壓監測助手，幫助您更好地管理健康數據。隨時隨地記錄、分析您的血壓數據，讓健康管理更輕鬆。'),
    OnboardingItem(image: 'assets/images/onboarding_record.png', title: '簡單記錄血壓數據', description: '通過簡潔直觀的界面，輕鬆記錄您的收縮壓、舒張壓和心率數據。支持手動輸入和藍牙設備連接。'),
    OnboardingItem(image: 'assets/images/onboarding_analysis.png', title: '專業數據分析', description: '通過圖表和趨勢分析，直觀了解您的血壓變化。系統會提供專業建議，幫助您更好地理解健康狀況。'),
    OnboardingItem(image: 'assets/images/onboarding_reminder.png', title: '智能提醒功能', description: '設置測量提醒，養成規律監測血壓的習慣。您也可以設置用藥提醒，確保按時服藥。'),
  ];

  @override
  void initState() {
    super.initState();
    // 設置狀態欄為透明
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 背景漸變
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.withOpacity(0.05), Colors.white],
              ),
            ),
          ),
          // 主要內容
          SafeArea(
            child: Column(
              children: [
                // 頂部跳過按鈕
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                      child: const Text('跳過', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    ),
                  ),
                ),

                // 內容區域
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingItems.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(_onboardingItems[index]);
                    },
                  ),
                ),

                // 底部按鈕區域
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0, left: 24.0, right: 24.0),
                  child: Column(
                    children: [
                      // 頁面指示器
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _totalPages,
                        effect: ExpandingDotsEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: primaryColor,
                          dotColor: Colors.grey.withOpacity(0.3),
                          spacing: 10,
                          expansionFactor: 3,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // 下一步或完成按鈕
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < _totalPages - 1) {
                              _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                            } else {
                              _completeOnboarding();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          child: Text(
                            _currentPage < _totalPages - 1 ? '下一步' : '開始使用',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1),
                          ),
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

  // 構建引導頁面
  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 圖像容器
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset(item.image, fit: BoxFit.contain)),
            ),
          ),
          const SizedBox(height: 40),
          // 標題
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 26, letterSpacing: 0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // 描述
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87, height: 1.5, fontSize: 16, letterSpacing: 0.3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // 完成引導
  void _completeOnboarding() async {
    // 保存引導完成狀態
    await SharedPrefsService.setOnBoardingCompleted();

    // 導航到主頁面
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// 引導頁面項目模型
class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({required this.image, required this.title, required this.description});
}
