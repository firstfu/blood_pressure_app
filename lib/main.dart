// @ Author: firstfu
// @ Create Time: 2024-05-15 16:16:42
// @ Description: 血壓管家 App 主入口檔案

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'services/shared_prefs_service.dart';
import 'themes/app_theme.dart';
import 'views/main_page.dart';
import 'views/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 設置狀態欄顏色
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));

  // 檢查用戶是否已完成 onBoarding
  final bool onBoardingCompleted = await SharedPrefsService.isOnBoardingCompleted();
  print('onBoarding 狀態: ${onBoardingCompleted ? '已完成' : '未完成'}');

  // 初始化語系提供者
  final localeProvider = LocaleProvider();
  await localeProvider.init();

  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => localeProvider)], child: MyApp(onBoardingCompleted: onBoardingCompleted)));
}

class MyApp extends StatelessWidget {
  final bool onBoardingCompleted;

  const MyApp({super.key, required this.onBoardingCompleted});

  @override
  Widget build(BuildContext context) {
    // 獲取當前語系
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: onBoardingCompleted ? const MainPage() : const OnboardingPage(),
      debugShowCheckedModeBanner: false,
      // 添加本地化支持
      localizationsDelegates: const [
        AppLocalizationsDelegate(), // 自定義語系代理
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeProvider.locale, // 使用 Provider 管理的語系
    );
  }
}
