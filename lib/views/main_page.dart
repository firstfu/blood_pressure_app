// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 主頁面，包含底部導航欄，用於切換不同頁面

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations_extension.dart';
import '../themes/app_theme.dart';
import 'home_page.dart';
import 'record_page.dart';
import 'stats_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const HomePage(), const RecordPage(isFromTabNav: true), const StatsPage(), const ProfilePage()];

  @override
  void initState() {
    super.initState();

    // 設置沉浸式狀態欄
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: context.tr('首頁')),
          BottomNavigationBarItem(icon: const Icon(Icons.add_circle_outline), label: context.tr('記錄')),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: context.tr('統計')),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: context.tr('我的')),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
      ),
    );
  }
}
