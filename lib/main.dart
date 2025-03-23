/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-13 09:45:50
 * @ Description: 血壓記錄 App 主入口檔案
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'services/shared_prefs_service.dart';
import 'themes/app_theme.dart';
import 'views/main_page.dart';
import 'views/onboarding/onboarding_page.dart';

// 主應用程式入口
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始狀態欄設置為透明
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light, // iOS
    ),
  );

  // 檢查用戶是否已完成 onBoarding
  final bool onBoardingCompleted = await SharedPrefsService.isOnBoardingCompleted();
  print('onBoarding 狀態: ${onBoardingCompleted ? '已完成' : '未完成'}');

  // 初始化語系提供者
  final localeProvider = LocaleProvider();
  await localeProvider.init();

  // 初始化主題提供者
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => localeProvider), ChangeNotifierProvider(create: (_) => themeProvider)],
      child: MyApp(onBoardingCompleted: onBoardingCompleted),
    ),
  );
}

// 主應用程式
class MyApp extends StatelessWidget {
  final bool onBoardingCompleted;

  const MyApp({super.key, required this.onBoardingCompleted});

  @override
  Widget build(BuildContext context) {
    // 獲取當前語系
    final localeProvider = Provider.of<LocaleProvider>(context);
    // 獲取當前主題
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: AppConstants.appName,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: onBoardingCompleted ? const MainPage() : const OnboardingPage(),
      debugShowCheckedModeBanner: false,
      // 添加本地化支持
      localizationsDelegates: [
        AppLocalizations.delegate, // 使用靜態代理
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeProvider.locale, // 使用 Provider 管理的語系
    );
  }
}
