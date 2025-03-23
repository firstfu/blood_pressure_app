// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 主頁面，包含底部導航欄，用於切換不同頁面

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations_extension.dart';
// import '../themes/app_theme.dart'; // 移除不必要的引用
import 'home/home_page.dart';
import 'record/record_page.dart';
import 'analysis/stats/stats_page.dart';
import 'my/profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 修改頁面列表，移除記錄頁面
  final List<Widget> _pages = [const HomePage(), const SizedBox(), const StatsPage(), const ProfilePage()];

  @override
  void initState() {
    super.initState();

    // 設置沉浸式狀態欄 - 根據當前主題調整狀態欄圖標亮度
    // 這裡不再硬編碼設置，而是在 build 方法中根據當前主題動態設置
  }

  // 處理底部導航欄點擊
  void _onTabTapped(int index) {
    // 如果點擊的是記錄標籤（索引為1）
    if (index == 1) {
      // 導航到記錄頁面
      _navigateToRecordPage();
    } else {
      // 其他標籤正常切換
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // 導航到記錄頁面
  void _navigateToRecordPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecordPage(isFromTabNav: true))).then((value) {
      // 如果返回數據為 true，則刷新當前頁面
      if (value == true && _currentIndex == 0) {
        setState(() {
          // 刷新首頁
        });
      }

      // 保持在首頁標籤
      if (_currentIndex == 1) {
        setState(() {
          _currentIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // 根據當前主題動態設置狀態欄樣式
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarBrightness: brightness == Brightness.light ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: context.tr('首頁')),
          BottomNavigationBarItem(icon: const Icon(Icons.add_circle_outline), label: context.tr('記錄')),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: context.tr('統計')),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: context.tr('我的')),
        ],
        // 使用主題設置
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
        elevation: theme.bottomNavigationBarTheme.elevation,
      ),
    );
  }
}
