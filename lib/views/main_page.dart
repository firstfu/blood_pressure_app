// 血壓記錄 App 主頁面
// 包含底部導航欄，用於切換不同頁面

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
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

  final List<Widget> _pages = [const HomePage(), const RecordPage(), const StatsPage(), const ProfilePage()];

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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: AppConstants.homeTab),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: AppConstants.recordTab),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: AppConstants.statsTab),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: AppConstants.profileTab),
        ],
      ),
    );
  }
}
