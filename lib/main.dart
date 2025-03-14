// @ Author: 1891_0982
// @ Create Time: 2024-03-15 10:30:30
// @ Description: 血壓記錄 App 主入口檔案

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      // 添加本地化支持
      localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: const [
        Locale('zh', 'TW'), // 繁體中文
        Locale('zh', 'CN'), // 簡體中文
        Locale('en', 'US'), // 英文
      ],
      locale: const Locale('zh', 'TW'), // 設置默認語言為繁體中文
    );
  }
}
