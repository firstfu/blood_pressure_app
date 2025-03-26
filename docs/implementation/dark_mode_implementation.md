# 深色模式實現文檔

## 文件資訊

- **文件名稱**：深色模式實現文檔
- **版本**：1.0
- **最後更新日期**：2024 年 5 月 27 日
- **狀態**：已實現

## 需求分析

### 背景

為了提升用戶在不同光線環境下的使用體驗，特別是在夜間或光線較弱環境下減少眼睛疲勞，血壓管家應用需要實現深色模式功能。深色模式不僅可以減少藍光對眼睛的刺激，還可以節省電量，特別是在 OLED 屏幕的設備上。

### 目標

1. 實現完整的深色模式主題，包括所有頁面和元件
2. 提供自動切換選項，根據系統設定自動調整
3. 提供手動切換選項，讓用戶可以根據個人偏好選擇
4. 確保深色模式下的視覺舒適度和可讀性
5. 維持應用整體設計語言的一致性

### 技術方案

1. **主題系統設計**

   - 創建完整的深色模式主題，定義所有顏色和樣式
   - 使用 Flutter 的 ThemeData 進行統一管理
   - 針對深色模式特別優化的顏色方案

2. **主題管理**

   - 使用 Provider 管理主題狀態
   - 使用 SharedPreferences 保存用戶主題偏好
   - 提供主題切換功能

3. **系統集成**
   - 監聽系統深色模式設定變化
   - 在啟動時根據系統設定或用戶偏好設定應用主題

## 實現細節

### 1. 主題配置

```dart
// 淺色主題配置
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF1976D2),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1976D2),
    foregroundColor: Colors.white,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.black.withOpacity(0.1),
  ),
  textTheme: const TextTheme(
    // 文字樣式定義
  ),
  // 其他組件主題定義
);

// 深色主題配置
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF90CAF9),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF1F1F1F),
    shadowColor: Colors.transparent,
  ),
  textTheme: const TextTheme(
    // 深色模式下的文字樣式定義
  ),
  // 其他組件主題定義
);
```

### 2. 主題管理類

```dart
enum ThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // 獲取系統設定
      return SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    notifyListeners();
  }

  // 從 SharedPreferences 加載主題設定
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('theme_mode');
    if (savedMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  // 保存主題設定到 SharedPreferences
  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode.toString());
  }
}
```

### 3. 主題設定頁面

```dart
class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('主題設定')),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(context.tr('跟隨系統')),
            leading: const Icon(Icons.brightness_auto),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) => themeProvider.setThemeMode(value!),
            ),
            onTap: () => themeProvider.setThemeMode(ThemeMode.system),
          ),
          ListTile(
            title: Text(context.tr('淺色模式')),
            leading: const Icon(Icons.brightness_5),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) => themeProvider.setThemeMode(value!),
            ),
            onTap: () => themeProvider.setThemeMode(ThemeMode.light),
          ),
          ListTile(
            title: Text(context.tr('深色模式')),
            leading: const Icon(Icons.brightness_4),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) => themeProvider.setThemeMode(value!),
            ),
            onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}
```

### 4. 主應用程式集成

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        // 其他 providers...
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Blood Pressure Manager',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // 其他 app 配置...
    );
  }
}
```

## 深色模式設計考量

### 顏色選擇原則

1. **背景顏色**

   - 使用暗灰色（#121212）作為主要背景色，而非純黑色
   - 不同層級的表面使用略微不同的顏色，創建層次感

2. **文字顏色**

   - 主要文字使用白色（#FFFFFF），但降低透明度至 87% 減少眼睛疲勞
   - 次要文字使用較低透明度的白色（60%）
   - 禁用或提示文字使用更低透明度（38%）

3. **強調色**

   - 使用較亮的藍色（#90CAF9）代替主題原色（#1976D2）
   - 確保足夠的對比度，增強可讀性

4. **狀態顏色**
   - 錯誤色：較淺的紅色（#CF6679）
   - 成功色：調整為較淺的綠色（#03DAC6）
   - 警告色：調整為較暗的橙色（#FF9E40）

### 對比度與可讀性

- 確保文字與背景的對比度達到 WCAG AA 標準（4.5:1）
- 使用較大的字體大小和增加字重來增強可讀性
- 避免使用低飽和度和低對比度的顏色組合

### 圖表與數據視覺化

- 為圖表設計專用的深色模式配色方案
- 增加線條粗細和數據點大小
- 使用更明亮的顏色表示重要數據
- 添加適當的網格線幫助區分數據

## 測試與優化

1. **設備測試**

   - 在不同尺寸和屏幕類型的設備上測試（LCD、OLED）
   - 確保在高低亮度設定下都有良好的可見性

2. **使用者測試**

   - 收集使用者反饋，特別是關於可讀性和舒適度
   - 針對老年用戶特別測試深色模式的可讀性

3. **性能測試**
   - 測試主題切換的流暢度
   - 確保深色模式不會增加應用啟動時間

## 已解決問題

1. ✅ 深色模式下圖表顏色對比度不足 - 調整了圖表的調色板
2. ✅ 某些視覺元素在深色模式下不可見 - 增加了邊框或陰影
3. ✅ 主題切換時頁面閃爍 - 優化了主題切換邏輯

## 未來計劃

1. 添加更多主題顏色選項
2. 實現基於時間的自動主題切換（日出/日落）
3. 針對特定頁面的深色模式優化

## 參考資料

1. [Material Design - Dark Theme Guidelines](https://material.io/design/color/dark-theme.html)
2. [Flutter ThemeData Documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html)
3. [WCAG Contrast Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
