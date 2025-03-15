# 血壓管家 App - OnBoarding 功能需求文檔

## 功能概述

OnBoarding 功能是血壓管家 App 的首次啟動引導流程，旨在向新用戶介紹應用的核心功能和價值。通過視覺化的方式，幫助用戶快速了解應用的主要功能，提高用戶留存率和使用體驗。

## 功能需求

### 1. 基本需求

- 僅在用戶首次啟動應用時顯示 OnBoarding 頁面
- 提供跳過選項，允許用戶直接進入主頁面
- 提供頁面指示器，顯示當前頁面位置和總頁數
- 提供下一步按鈕，引導用戶進入下一頁
- 最後一頁提供開始使用按鈕，完成引導流程

### 2. 頁面內容

OnBoarding 流程包含 4 個頁面，每個頁面包含：

- 主題圖片
- 標題文字
- 描述文字

頁面內容如下：

1. **歡迎頁面**

   - 標題：歡迎使用血壓管家
   - 描述：您的個人血壓管理助手，幫助您更好地了解和管理血壓健康
   - 圖片：展示應用 Logo 和整體界面

2. **記錄功能頁面**

   - 標題：輕鬆記錄血壓數據
   - 描述：簡單快速地記錄您的血壓數據，支持手動輸入和智能設備同步
   - 圖片：展示記錄頁面界面

3. **分析功能頁面**

   - 標題：專業分析健康趨勢
   - 描述：智能分析您的血壓趨勢，提供專業的健康建議和風險評估
   - 圖片：展示統計分析頁面界面

4. **提醒功能頁面**
   - 標題：貼心提醒不遺漏
   - 描述：設置測量提醒，確保您按時測量血壓，不錯過任何重要數據
   - 圖片：展示提醒設置界面

### 3. 技術需求

- 使用 SharedPreferences 保存用戶是否已完成 OnBoarding 的狀態
- 使用 PageView 實現頁面滑動效果
- 使用 AnimatedContainer 實現頁面指示器動畫效果
- 支持左右滑動切換頁面

## 實現方案

### 1. 文件結構

- `lib/services/shared_prefs_service.dart`：共享偏好設定服務，管理 OnBoarding 狀態
- `lib/views/onboarding_page.dart`：OnBoarding 頁面實現
- `lib/constants/app_constants.dart`：添加 OnBoarding 相關常數
- `lib/main.dart`：修改主入口文件，添加判斷邏輯

### 2. 狀態管理

使用 SharedPreferences 保存用戶是否已完成 OnBoarding 的狀態：

- `isOnBoardingCompleted()`：獲取 OnBoarding 完成狀態
- `setOnBoardingCompleted()`：設置 OnBoarding 完成狀態
- `resetOnBoardingStatus()`：重置 OnBoarding 狀態（用於測試）

### 3. 頁面流程

1. 應用啟動時，檢查用戶是否已完成 OnBoarding
2. 如果未完成，顯示 OnBoarding 頁面
3. 用戶可以通過滑動或點擊下一步按鈕瀏覽所有頁面
4. 用戶可以隨時點擊跳過按鈕，直接進入主頁面
5. 當用戶完成所有頁面或點擊跳過按鈕時，保存狀態並進入主頁面
6. 下次啟動應用時，直接進入主頁面

## 進度計劃

- [x] 創建 SharedPrefsService 類
- [x] 在 AppConstants 中添加 OnBoarding 相關常數
- [x] 實現 OnboardingPage 頁面
- [x] 修改 main.dart 添加判斷邏輯
- [x] 添加臨時圖片解決方案
- [x] 創建圖片設計指南文檔
- [x] 測試 OnBoarding 功能
- [ ] 添加專業設計的 OnBoarding 圖片資源
- [ ] 優化 OnBoarding 頁面動畫效果

## 臨時圖片解決方案

由於暫時無法獲得專業設計的圖片，我們採用了以下臨時解決方案：

1. 在 `OnboardingPage` 類中添加了 `_tempIcons` 列表，包含 4 個與頁面主題相關的圖標：

   - 歡迎頁面：`Icons.favorite`（心臟圖標）
   - 記錄頁面：`Icons.add_chart`（添加數據圖標）
   - 分析頁面：`Icons.bar_chart`（圖表圖標）
   - 提醒頁面：`Icons.notifications_active`（通知圖標）

2. 創建了 `_buildImageOrPlaceholder` 方法，顯示臨時圖標和圖片路徑信息

3. 創建了 `docs/onboarding_images_guide.md` 文檔，提供詳細的圖片設計指南，供後續專業設計使用

這個臨時解決方案允許我們在沒有專業設計圖片的情況下測試 OnBoarding 功能，同時為後續的圖片設計提供了明確的指南。

## 注意事項

1. OnBoarding 頁面的設計應與應用整體風格保持一致
2. 圖片資源應準備多種分辨率，適配不同設備
3. 文字內容應簡潔明了，突出應用核心價值
4. 頁面切換動畫應流暢自然，提升用戶體驗
5. 在獲得專業設計的圖片後，應替換臨時圖標，提升視覺效果
