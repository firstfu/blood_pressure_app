// 血壓記錄 App 主入口檔案

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_constants.dart';
import 'themes/app_theme.dart';
import 'views/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 設置狀態欄顏色
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: AppConstants.appName, theme: AppTheme.lightTheme, home: const MainPage(), debugShowCheckedModeBanner: false);
  }
}
