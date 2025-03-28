# 血壓管家應用程式色彩系統

## 文件資訊

- **文件名稱**：血壓管家應用程式色彩系統
- **版本**：1.0
- **最後更新日期**：2024 年 5 月 29 日
- **狀態**：已實現
- **作者**：firstfu

## 色彩系統概述

「血壓管家」應用程式的色彩系統旨在創建一個專業、可信賴且易於使用的健康管理工具。色彩選擇基於以下原則：

1. **醫療專業性**：使用以藍色為基礎的配色方案，呼應醫療健康領域的專業形象
2. **數據清晰度**：確保數據視覺化元素的色彩選擇有助於快速理解健康資訊
3. **視覺舒適性**：色彩方案在淺色和深色模式下都能提供舒適的閱讀體驗
4. **可訪問性**：遵循 WCAG 2.1 AA 級別標準，確保足夠的對比度和色彩區分度
5. **系統一致性**：在整個應用程式中保持一致的色彩語言

## 主色調

### 基礎藍（Primary Blue）

醫療藍是整個應用程式的核心色調，代表專業、可靠和平靜。

| 色階   | 淺色模式           | 深色模式           | 用途                           |
| ------ | ------------------ | ------------------ | ------------------------------ |
| 主色   | #1976D2 (藍色 700) | #90CAF9 (藍色 200) | 主要按鈕、頂部應用欄、重要控件 |
| 次要色 | #42A5F5 (藍色 400) | #64B5F6 (藍色 300) | 次要元素、選中狀態             |
| 輕量色 | #BBDEFB (藍色 100) | #0D47A1 (藍色 900) | 背景提示、分割線、輕微強調     |
| 極淺色 | #E3F2FD (藍色 50)  | #1A237E (藍色 900) | 卡片背景、分組背景             |

## 輔助色彩

### 強調色（Accent Colors）

強調色用於突出顯示特定功能或吸引用戶注意。

| 色調   | 淺色模式           | 深色模式            | 用途                             |
| ------ | ------------------ | ------------------- | -------------------------------- |
| 薄荷綠 | #00BFA5 (青色 600) | #64FFDA (青色 A200) | 成功提示、健康狀態良好、完成操作 |
| 陽光黃 | #FFC107 (黃色 600) | #FFD54F (黃色 300)  | 警告、需要注意、進行中的操作     |
| 珊瑚紅 | #F44336 (紅色 500) | #FF8A80 (紅色 A100) | 錯誤提示、危險操作、刪除按鈕     |

### 血壓狀態色彩

特別針對血壓數據的分類而設計，幫助用戶快速識別血壓狀態。

| 狀態           | 淺色模式           | 深色模式           | 對應血壓範圍                   |
| -------------- | ------------------ | ------------------ | ------------------------------ |
| 正常           | #4CAF50 (綠色 500) | #81C784 (綠色 300) | 收縮壓 < 120 且 舒張壓 < 80    |
| 偏高           | #FFEB3B (黃色 500) | #FFF176 (黃色 300) | 收縮壓 120-129 且 舒張壓 < 80  |
| 高血壓第一階段 | #FF9800 (橙色 500) | #FFB74D (橙色 300) | 收縮壓 130-139 或 舒張壓 80-89 |
| 高血壓第二階段 | #F44336 (紅色 500) | #E57373 (紅色 300) | 收縮壓 ≥ 140 或 舒張壓 ≥ 90    |
| 高血壓危象     | #8E24AA (紫色 600) | #CE93D8 (紫色 200) | 收縮壓 > 180 或 舒張壓 > 120   |

## 中性色調

中性色用於文本、背景和邊框等基礎元素。

### 淺色模式中性色

| 色階     | 色碼               | 用途                   |
| -------- | ------------------ | ---------------------- |
| 背景     | #FFFFFF (白色)     | 主要背景色             |
| 表面     | #F5F5F5 (灰色 100) | 卡片、對話框等元素背景 |
| 分隔線   | #E0E0E0 (灰色 300) | 列表分隔線、邊框       |
| 禁用     | #9E9E9E (灰色 500) | 禁用狀態的控件         |
| 次要文本 | #757575 (灰色 600) | 次要文本、說明文字     |
| 主要文本 | #212121 (灰色 900) | 主要文本、標題         |

### 深色模式中性色

| 色階     | 色碼               | 用途                   |
| -------- | ------------------ | ---------------------- |
| 背景     | #121212 (深灰色)   | 主要背景色             |
| 表面     | #1E1E1E (灰色 900) | 卡片、對話框等元素背景 |
| 提升表面 | #2C2C2C (灰色 850) | 浮動元素、彈出窗口     |
| 分隔線   | #373737 (灰色 800) | 列表分隔線、邊框       |
| 禁用     | #6D6D6D (灰色 600) | 禁用狀態的控件         |
| 次要文本 | #B0B0B0 (灰色 400) | 次要文本、說明文字     |
| 主要文本 | #EEEEEE (灰色 100) | 主要文本、標題         |

## 圖表與數據視覺化色彩

為確保數據視覺化的清晰度和專業性，特別設計了以下圖表色彩：

### 收縮壓趨勢圖

| 元素     | 淺色模式           | 深色模式           |
| -------- | ------------------ | ------------------ |
| 線條     | #1976D2 (藍色 700) | #90CAF9 (藍色 200) |
| 區域填充 | #BBDEFB (藍色 100) | #1565C0 (藍色 800) |
| 數據點   | #0D47A1 (藍色 900) | #E3F2FD (藍色 50)  |

### 舒張壓趨勢圖

| 元素     | 淺色模式           | 深色模式           |
| -------- | ------------------ | ------------------ |
| 線條     | #5E35B1 (紫色 600) | #B39DDB (紫色 200) |
| 區域填充 | #D1C4E9 (紫色 100) | #4527A0 (紫色 800) |
| 數據點   | #311B92 (紫色 900) | #EDE7F6 (紫色 50)  |

### 多數據對比圖表

| 數據系列 | 淺色模式           | 深色模式           |
| -------- | ------------------ | ------------------ |
| 系列 1   | #1976D2 (藍色 700) | #90CAF9 (藍色 200) |
| 系列 2   | #5E35B1 (紫色 600) | #B39DDB (紫色 200) |
| 系列 3   | #00897B (青色 600) | #80CBC4 (青色 200) |
| 系列 4   | #FFA000 (橙色 700) | #FFCC80 (橙色 200) |
| 系列 5   | #E53935 (紅色 600) | #EF9A9A (紅色 200) |

### 統計圖標記色彩

| 標記元素 | 淺色模式           | 深色模式           |
| -------- | ------------------ | ------------------ |
| 平均線   | #4CAF50 (綠色 500) | #81C784 (綠色 300) |
| 警戒線   | #F44336 (紅色 500) | #E57373 (紅色 300) |
| 目標區域 | #C5E1A5 (綠色 200) | #558B2F (綠色 800) |
| 網格線   | #E0E0E0 (灰色 300) | #424242 (灰色 800) |

## 設計原則與應用

### 色彩比例

為保持視覺和諧，推薦以下色彩使用比例：

- **60%**：中性色（背景、文本等）
- **30%**：主色調（藍色系列）
- **10%**：強調色和血壓狀態色彩

### 可訪問性準則

所有色彩組合都經過檢查，以確保符合以下可訪問性標準：

- 文本與背景的對比度達到 WCAG 2.1 AA 級（4.5:1 對於普通文本，3:1 對於大文本）
- 避免單純依靠顏色傳達重要信息，總是搭配圖標或文本說明
- 為色盲用戶提供適當的色彩方案，特別是在數據視覺化部分

### 深色模式適配

深色模式的色彩選擇遵循以下原則：

1. **減少藍光**：深色背景使用略微偏暖的深灰色，而非純黑，減少屏幕發藍光
2. **增強對比度**：主色調和強調色在深色模式下調整為更亮的色調，提高可見度
3. **減少飽和度**：某些高飽和度顏色在深色模式下調整為較低飽和度，減少視覺疲勞
4. **保持一致性**：深淺模式下的色彩語義保持一致，相同功能使用相同色彩系列

## 實現指南

### 代碼實現

應用程式中的色彩系統通過以下方式實現：

```dart
// 淺色模式主題色彩
class LightThemeColors {
  static const primary = Color(0xFF1976D2);
  static const primaryVariant = Color(0xFF42A5F5);
  static const primaryLight = Color(0xFFBBDEFB);
  static const primaryExtraLight = Color(0xFFE3F2FD);

  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF5F5F5);
  static const divider = Color(0xFFE0E0E0);
  static const disabled = Color(0xFF9E9E9E);
  static const secondaryText = Color(0xFF757575);
  static const primaryText = Color(0xFF212121);

  // ... 其他顏色定義
}

// 深色模式主題色彩
class DarkThemeColors {
  static const primary = Color(0xFF90CAF9);
  static const primaryVariant = Color(0xFF64B5F6);
  static const primaryLight = Color(0xFF0D47A1);
  static const primaryExtraLight = Color(0xFF1A237E);

  static const background = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const elevatedSurface = Color(0xFF2C2C2C);
  static const divider = Color(0xFF373737);
  static const disabled = Color(0xFF6D6D6D);
  static const secondaryText = Color(0xFFB0B0B0);
  static const primaryText = Color(0xFFEEEEEE);

  // ... 其他顏色定義
}
```

### 設計資源

產品設計師和開發人員應使用以下資源：

1. **色彩系統 Figma 庫**：包含所有色彩定義和使用示例
2. **色彩對比度檢查工具**：用於驗證設計的色彩對比是否符合可訪問性標準
3. **血壓管家設計系統文檔**：詳細的色彩應用指南和最佳實踐

## 色彩使用案例

### 首頁血壓狀態卡片

| 血壓狀態       | 卡片邊框顏色   | 狀態文本顏色   | 背景顏色       |
| -------------- | -------------- | -------------- | -------------- |
| 正常           | #4CAF50 (綠色) | #2E7D32 (深綠) | #E8F5E9 (淺綠) |
| 偏高           | #FFEB3B (黃色) | #F57F17 (深黃) | #FFFDE7 (淺黃) |
| 高血壓第一階段 | #FF9800 (橙色) | #E65100 (深橙) | #FFF3E0 (淺橙) |
| 高血壓第二階段 | #F44336 (紅色) | #B71C1C (深紅) | #FFEBEE (淺紅) |
| 高血壓危象     | #8E24AA (紫色) | #4A148C (深紫) | #F3E5F5 (淺紫) |

### 統計分析頁面

| 元素         | 顏色           | 用途                         |
| ------------ | -------------- | ---------------------------- |
| 平均收縮壓   | #1976D2 (藍色) | 平均值標記線和數值           |
| 平均舒張壓   | #5E35B1 (紫色) | 平均值標記線和數值           |
| 平均心率     | #E53935 (紅色) | 平均值標記線和數值           |
| 正常範圍區域 | #C5E1A5 (淺綠) | 圖表中正常血壓範圍的背景填充 |
| 數據選擇器   | #1976D2 (藍色) | 時間範圍選擇器的邊框和文本   |

## 未來發展

色彩系統將根據用戶反饋和應用發展不斷優化，未來的發展方向包括：

1. **個性化色彩主題**：允許用戶在預設的色彩主題中選擇，或自定義主色調
2. **色彩情感反饋**：根據用戶健康數據的變化，提供相應的色彩反饋，增強用戶體驗
3. **季節性色彩更新**：在特定節日和季節提供限時主題色彩
4. **擴展色盲友好色彩**：增加專為不同類型色盲用戶設計的色彩模式

## 參考資源

- [Material Design Color System](https://material.io/design/color/the-color-system.html)
- [WCAG 2.1 Color Contrast Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [Color Psychology in Healthcare Applications](https://healthcare-communications.imedpub.com/the-psychology-of-color-in-healthcare-settings.php)
- [IBM Carbon Design System](https://www.carbondesignsystem.com/guidelines/color/overview/)
