// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 主頁面，包含底部導航欄，用於切換不同頁面

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../l10n/app_localizations_extension.dart';
import '../services/auth_service.dart';
import '../constants/auth_constants.dart';
import '../utils/dialog_utils.dart';
import 'home/home_page.dart';
import 'record/record_page.dart';
import 'analysis/stats/stats_page.dart';
import 'my/profile/profile_page.dart';
import 'test/auth_test_page.dart'; // 添加測試頁面引用

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const RecordPage(isFromTabNav: true),
    const StatsPage(),
    const ProfilePage(),
    const AuthTestPage(), // 認證測試頁面
  ];

  @override
  void initState() {
    super.initState();

    // 設置沉浸式狀態欄 - 根據當前主題調整狀態欄圖標亮度
    // 這裡不再硬編碼設置，而是在 build 方法中根據當前主題動態設置
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: context.tr('首頁')),
          BottomNavigationBarItem(icon: const Icon(Icons.add_box), label: context.tr('新增記錄')),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: context.tr('報表')),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: context.tr('設定')),
          BottomNavigationBarItem(icon: const Icon(Icons.login), label: context.tr('認證測試')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      ),
    );
  }

  Future<void> _onTabTapped(int index) async {
    // 如果點擊了 "新增記錄"，檢查是否需要登入
    if (index == 1) {
      // 新增記錄頁
      final authService = GetIt.instance<AuthService>();

      // 如果是遊客用戶
      if (authService.isGuestUser) {
        // 顯示登入對話框
        final bool? result = await showLoginDialog(context, message: '新增記錄需要登入。您想現在登入嗎？', operationType: OperationType.addRecord);

        // 如果用戶取消登入或登入失敗，不切換頁面
        if (result != true) {
          return;
        }
      }
    }

    // 更新選中的索引
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
