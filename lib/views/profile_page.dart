// @ Author: 1891_0982
// @ Create Time: 2024-03-15 10:25:30
// @ Description: 血壓記錄 App 個人頁面，用於顯示和編輯用戶資料

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        title: const Text('個人中心', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(child: Text('個人頁面內容將在後續實現')),
    );
  }
}
