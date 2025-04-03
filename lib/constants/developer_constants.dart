// @ Author: firstfu
// @ Create Time: 2024-05-15 15:47:42
// @ Description: 開發者選單與測試頁面常數定義

import 'package:flutter/material.dart';
import '../views/auth/auth_test_page.dart';

/// 開發者測試頁面資訊
class DevPageInfo {
  final String name;
  final IconData icon;
  final Widget page;
  final String description;

  const DevPageInfo({required this.name, required this.icon, required this.page, required this.description});
}

/// 開發者選單常數
class DeveloperConstants {
  /// 是否啟用開發者選單
  /// 在生產環境中設為 false
  static const bool enableDevMenu = true;

  /// 開發者選單觸發方式說明
  static const String triggerMethodDescription = '在主頁面左上角連續點擊 5 次';

  /// 開發者測試頁面列表
  static final List<DevPageInfo> devPages = [
    const DevPageInfo(name: '認證測試', icon: Icons.security, page: AuthTestPage(), description: '測試各種登入方式，包括 Email、Google 和 Apple 登入'),
    // 可以在這裡添加更多的測試頁面
  ];
}
