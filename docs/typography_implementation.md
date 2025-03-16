# 血壓管家 App 排版系統實現指南

## 文件資訊

- **文件名稱**：血壓管家 App 排版系統實現指南
- **版本**：1.0
- **最後更新日期**：2024 年 5 月 15 日
- **相關文檔**：
  - [排版指南](/Users/firstfu/Desktop/blood_pressure_app/docs/typography_guidelines.md)
  - [UI/UX 設計文件](/Users/firstfu/Desktop/blood_pressure_app/docs/blood_pressure_app_ui_ux_design.md)

## 目錄

1. [概述](#概述)
2. [文件結構](#文件結構)
3. [排版主題實現](#排版主題實現)
4. [使用方法](#使用方法)
5. [最佳實踐](#最佳實踐)
6. [常見問題](#常見問題)

## 概述

本文檔說明如何在「血壓管家」App 中實現和使用排版系統。排版系統是確保應用程式視覺一致性的關鍵，它定義了文字大小、字重和顏色等屬性，使開發團隊能夠輕鬆地維持一致的用戶界面。

## 文件結構

排版系統的實現主要涉及以下文件：

1. **`lib/themes/typography_theme.dart`**：定義所有文字樣式和排版規則
2. **`lib/themes/app_theme.dart`**：整合排版主題到應用程式的主題中
3. **`docs/typography_guidelines.md`**：詳細的排版指南文檔

## 排版主題實現

### TypographyTheme 類

`typography_theme.dart` 文件中的 `TypographyTheme` 類是排版系統的核心，它定義了：

1. **基本文字樣式**：頁面標題、大標題、標題、副標題、正文等
2. **特定元素樣式**：按鈕文字、表單標籤、數據值等
3. **完整的 TextTheme**：用於配置 ThemeData

```dart
/// TypographyTheme 類別
///
/// 定義應用程式的所有文字排版樣式
/// 根據 /docs/typography_guidelines.md 文件實現
class TypographyTheme {
  // 主要文字顏色
  static const Color textPrimaryColor = Color(0xFF212121);

  // 次要文字顏色
  static const Color textSecondaryColor = Color(0xFF757575);

  // 主色調
  static const Color primaryColor = Color(0xFF1976D2);

  // 主要字體
  static const String fontFamily = 'NotoSansTC';

  /// 頁面標題樣式 (22sp)
  /// 用於 AppBar 標題
  static const TextStyle pageTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: fontFamily,
  );

  // 其他樣式...

  /// 獲取完整的 TextTheme
  /// 用於配置 ThemeData
  static TextTheme get textTheme {
    return const TextTheme(
      // 標題系列
      displayLarge: largeTitle,    // 24sp, 大標題
      displayMedium: title,        // 20sp, 標題
      displaySmall: subtitle,      // 18sp, 副標題
      // 其他樣式...
    );
  }
}
```

### 整合到 AppTheme

在 `app_theme.dart` 文件中，我們將 `TypographyTheme` 整合到應用程式的主題中：

```dart
static ThemeData get lightTheme {
  return ThemeData(
    // 其他主題設定...

    // 使用新的排版主題
    textTheme: TypographyTheme.textTheme,

    appBarTheme: const AppBarTheme(
      // 其他設定...
      titleTextStyle: TypographyTheme.pageTitle,
    ),

    // 其他元件主題...
  );
}
```

## 使用方法

### 基本用法

在 UI 元件中使用排版樣式有以下幾種方法：

#### 1. 直接使用 TypographyTheme 中的樣式

```dart
Text('標題文字', style: TypographyTheme.title)
```

#### 2. 使用 Theme.of(context).textTheme

```dart
Text('標題文字', style: Theme.of(context).textTheme.displayMedium)
```

#### 3. 修改現有樣式

```dart
Text('標題文字', style: TypographyTheme.title.copyWith(color: Colors.red))
```

### 實際範例

以下是在「幫助與反饋」頁面中使用排版樣式的範例：

```dart
// AppBar 標題
appBar: AppBar(
  title: Text(context.tr('幫助與反饋'), style: TypographyTheme.pageTitle),
  // 其他設定...
),

// 章節標題
Text('常見問題解答', style: TypographyTheme.subtitle.copyWith(color: AppTheme.primaryColor)),

// 問題文字
Text(question, style: TypographyTheme.emphasized),

// 答案文字
Text(answer, style: TypographyTheme.body),
```

## 最佳實踐

1. **避免硬編碼文字樣式**：始終使用 `TypographyTheme` 中定義的樣式，而不是直接在 UI 元件中定義樣式。

   ```dart
   // 不推薦
   Text('標題', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))

   // 推薦
   Text('標題', style: TypographyTheme.title)
   ```

2. **使用語義化的樣式名稱**：根據文字的用途選擇合適的樣式，而不是根據外觀。

   ```dart
   // 不推薦
   Text('錯誤訊息', style: TypographyTheme.small)

   // 推薦
   Text('錯誤訊息', style: TypographyTheme.secondary)
   ```

3. **保持一致性**：同類型的元素應使用相同的文字樣式。

   ```dart
   // 所有表單標籤使用相同的樣式
   Text('姓名', style: TypographyTheme.formLabel)
   Text('電話', style: TypographyTheme.formLabel)
   ```

4. **適當調整**：在特殊情況下，可以使用 `copyWith` 方法調整樣式，但應保持基本屬性不變。

   ```dart
   // 調整顏色但保持大小和字重不變
   Text('特殊標題', style: TypographyTheme.title.copyWith(color: specialColor))
   ```

## 常見問題

### 1. 如何處理不同螢幕大小的文字大小調整？

Flutter 使用的 `sp` 單位會根據系統字體大小設定自動調整，但在某些情況下，您可能需要根據螢幕大小進一步調整：

```dart
// 根據螢幕寬度調整文字大小
double fontSize = MediaQuery.of(context).size.width < 360 ? 18 : 22;
Text('標題', style: TypographyTheme.title.copyWith(fontSize: fontSize))
```

### 2. 如何支援系統級別的文字大小調整？

確保在 `MaterialApp` 中啟用 `textScaleFactor` 支援：

```dart
MaterialApp(
  builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.4),
      ),
      child: child!,
    );
  },
  // 其他設定...
)
```

### 3. 如何處理多語言文字長度差異？

對於可能因語言而異的文字長度，可以使用自適應佈局和彈性容器：

```dart
Flexible(
  child: Text(
    context.tr('長文字標題可能在不同語言中有不同長度'),
    style: TypographyTheme.title,
    overflow: TextOverflow.ellipsis,
  ),
)
```

## 結論

良好的排版系統是建立專業、一致的用戶界面的基礎。通過遵循本文檔中的指南和最佳實踐，開發團隊可以確保「血壓管家」App 在所有頁面和元件中保持視覺一致性，提供更好的用戶體驗。
