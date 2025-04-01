// @ Author: firstfu
// @ Create Time: 2024-03-13 09:45:50
// @ Description: 血壓記錄 App 主入口檔案

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/app_constants.dart';
import 'constants/supabase_constants.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'services/shared_prefs_service.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';
import 'services/record_service.dart';
import 'themes/app_theme.dart';
import 'views/main_page.dart';
import 'views/onboarding/onboarding_page.dart';

// GetIt實例
final getIt = GetIt.instance;

// 設置服務
void setupServices() {
  // 註冊 Supabase 服務
  if (!getIt.isRegistered<SupabaseService>()) {
    getIt.registerSingleton<SupabaseService>(SupabaseService());
  }

  // 註冊認證服務
  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerSingleton<AuthService>(AuthService());
  }

  // 註冊記錄服務
  if (!getIt.isRegistered<RecordService>()) {
    getIt.registerSingleton<RecordService>(RecordService());
  }
}

// 方便後續使用的全局 Supabase 客戶端的快捷方法
SupabaseClient get supabase => Supabase.instance.client;

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

  try {
    // 初始化 Supabase
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      anonKey: SupabaseConstants.supabaseAnonKey,
      debug: true, // 在開發時啟用調試
    );

    // 設置服務
    setupServices();

    // 檢查用戶是否已完成 onBoarding
    final bool onBoardingCompleted = await SharedPrefsService.isOnBoardingCompleted();
    debugPrint('onBoarding 狀態: ${onBoardingCompleted ? '已完成' : '未完成'}');

    // 初始化語系提供者
    final localeProvider = LocaleProvider();
    await localeProvider.init();

    // 初始化主題提供者
    final themeProvider = ThemeProvider();
    await themeProvider.init();

    // 初始化認證提供者
    final authProvider = AuthProvider();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => localeProvider),
          ChangeNotifierProvider(create: (_) => themeProvider),
          ChangeNotifierProvider(create: (_) => authProvider),
          ChangeNotifierProvider.value(value: getIt<RecordService>()),
        ],
        child: MyApp(onBoardingCompleted: onBoardingCompleted),
      ),
    );
  } catch (e) {
    debugPrint('初始化過程中發生錯誤: $e');
    // 顯示錯誤畫面或執行緊急處理
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text('應用程式初始化失敗: $e', textAlign: TextAlign.center)))));
  }
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
    // 獲取認證提供者
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

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
      // 在用戶身份變更時重建應用，確保權限控制生效
      key: ValueKey('app_${authProvider.isAuthenticated}'),
    );
  }
}
