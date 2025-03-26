# 血壓管家 App 文檔目錄

## 文件資訊

- **文件名稱**：血壓管家 App 文檔目錄說明
- **版本**：1.7
- **最後更新日期**：2024 年 5 月 29 日

## 目錄結構

```
docs/
  ├── demand/                               # 需求文檔目錄
  │   ├── todo/                             # 待實現的需求
  │   ├── ok/                               # 已完成的需求
  │   │   ├── dark_mode_feature.md          # 深色模式功能需求
  │   │   ├── multi_language_feature.md     # 多國語系功能需求
  │   │   ├── onboarding_feature.md         # 引導頁功能需求
  │   │   ├── export_feature.md             # 數據匯出功能需求
  │   │   └── typography_system_implementation.md  # 排版系統實現需求
  │   └── cancel/                           # 已取消的需求
  ├── design/                               # 設計文檔目錄
  │   ├── ui_ux_design.md                   # UI/UX 設計文件
  │   ├── typography_guidelines.md          # 排版指南
  │   ├── typography_implementation.md      # 排版實現文檔
  │   ├── ui_prototype.md                   # UI 原型文檔
  │   └── color_system.md                   # 色彩系統文檔
  ├── implementation/                       # 實現文檔目錄
  │   ├── dark_mode_implementation.md       # 深色模式實現文檔
  │   ├── multi_language_implementation.md  # 多國語系實現文檔
  │   └── onboarding_implementation.md      # 引導頁實現文檔
  ├── technical/                            # 技術文檔目錄
  │   └── technical_architecture.md         # 技術架構文檔
  ├── project/                              # 專案管理文檔目錄
  │   ├── development_plan.md               # 開發計劃
  │   ├── implementation_plan.md            # 實現計劃
  │   ├── project_status_summary.md         # 專案進度摘要
  │   ├── changelog.md                      # 更新日誌
  │   ├── blood_pressure_app_prd.md         # 產品需求文檔
  │   └── 文檔整理方案.md                   # 文檔整理方案
  ├── assets/                               # 資源目錄
  │   ├── images/                           # 圖片資源
  │   └── diagrams/                         # 圖表資源
  ├── store/                                # 應用商店相關資源
  └── README.md                             # 文檔目錄說明（本文件）
```

## 文檔說明

### 需求文檔

需求文檔按照實現狀態分為三類：

1. **待實現 (todo)** - 尚未實現的需求

2. **已完成 (ok)** - 已經實現的需求

   - **[深色模式功能需求](demand/ok/dark_mode_feature.md)** - 深色模式功能的需求文檔
   - **[多國語系功能需求](demand/ok/multi_language_feature.md)** - 多國語系功能的需求文檔
   - **[引導頁功能需求](demand/ok/onboarding_feature.md)** - 引導頁功能的需求文檔
   - **[數據匯出功能需求](demand/ok/export_feature.md)** - 數據匯出功能的需求文檔
   - **[排版系統實現需求](demand/ok/typography_system_implementation.md)** - 排版系統的需求文檔

3. **已取消 (cancel)** - 已取消的需求

### 設計文檔

- **[UI/UX 設計文件](design/ui_ux_design.md)** - 應用程式的 UI/UX 設計規範，包含設計理念、品牌識別、設計系統等
- **[排版指南](design/typography_guidelines.md)** - 詳細的文字排版規範，包含字體大小、字重和用途
- **[排版實現文檔](design/typography_implementation.md)** - 排版系統的實現方案
- **[UI 原型文檔](design/ui_prototype.md)** - 應用程式的 UI 原型設計
- **[色彩系統文檔](design/color_system.md)** - 應用程式的色彩系統設計與規範

### 實現文檔

- **[深色模式實現文檔](implementation/dark_mode_implementation.md)** - 深色模式的實現方案和設計考量
- **[多國語系實現文檔](implementation/multi_language_implementation.md)** - 應用程式的多語言支援實現方案
- **[引導頁實現文檔](implementation/onboarding_implementation.md)** - 引導頁面功能實現方案

### 技術文檔

- **[技術架構文檔](technical/technical_architecture.md)** - 應用程式的技術架構和實現細節

### 專案管理文檔

- **[開發計劃](project/development_plan.md)** - 應用程式的開發計劃和時間表
- **[實現計劃](project/implementation_plan.md)** - 應用程式的實現計劃和步驟
- **[專案進度摘要](project/project_status_summary.md)** - 專案進度摘要，包含各階段完成度和當前工作
- **[更新日誌](project/changelog.md)** - 應用程式的更新日誌，記錄各版本更新內容
- **[產品需求文檔](project/blood_pressure_app_prd.md)** - 應用程式的產品需求文檔
- **[文檔整理方案](project/文檔整理方案.md)** - 文檔整理方案與執行情況

## 主要功能實現文檔

### 多國語系支援

血壓管家實現了完整的多國語系支援：

- **支援多種語言**：目前支援繁體中文、簡體中文和英文
- **自動適應系統語言**：根據設備系統語言自動選擇顯示語言
- **手動語言切換**：在設定中可手動選擇偏好的顯示語言
- **統一翻譯管理**：所有 UI 文字都通過本地化系統管理，確保翻譯一致性
- **完整頁面支援**：所有頁面和功能都支援多語言顯示

詳細實現方案請參閱 [多國語系實現文檔](implementation/multi_language_implementation.md)

### 深色模式支援

血壓管家 App 提供了完整的深色模式支援，包括：

- **自動適應系統設定**：跟隨系統深色模式自動切換
- **手動設定選項**：在主題設定頁面可手動切換深淺模式
- **主題顏色自定義**：支援多種主題顏色選擇，在深淺模式下均保持一致性
- **舒適閱讀體驗**：深色模式下優化了色彩對比度，減少夜間使用時的眼睛疲勞
- **完整 UI 適應**：所有頁面和元件都專門設計了深色模式版本

詳細實現方案請參閱 [深色模式實現文檔](implementation/dark_mode_implementation.md)

### 新用戶引導體驗

血壓管家提供精心設計的新用戶引導體驗：

- **吸引人的引導頁面**：展示 App 核心功能和價值的精美引導頁
- **符合應用主題風格**：藍色主題設計，與應用整體視覺體驗一致
- **多語言支援**：引導頁面自動根據系統語言切換顯示語言
- **直觀的導航控制**：水平滑動切換頁面，簡單易用
- **靈活跳過選項**：可隨時跳過引導過程直接進入主應用程式

詳細實現方案請參閱 [引導頁實現文檔](implementation/onboarding_implementation.md)

## 文檔管理規範

1. **需求文檔管理**：

   - 新的需求文檔應放在 `demand/todo` 目錄下
   - 已完成的需求文檔應移至 `demand/ok` 目錄下
   - 已取消的需求文檔應移至 `demand/cancel` 目錄下

2. **文檔命名規範**：

   - 使用英文命名，單詞間使用下劃線連接
   - 文檔名稱應能清晰表達文檔內容
   - 避免使用特殊字符和空格

3. **文檔格式規範**：

   - 使用 Markdown 格式編寫文檔
   - 文檔開頭應包含文件資訊（文件名稱、版本、最後更新日期等）
   - 使用標題層級清晰組織文檔結構
   - 適當使用列表、表格、代碼塊等元素提高可讀性

4. **文檔更新規範**：
   - 更新文檔時應更新「最後更新日期」
   - 重要更新應在文檔開頭的「版本」中反映
   - 保持文檔的一致性和準確性

## 文檔關鍵字索引

以下索引可幫助您快速查找特定主題的文檔：

### 功能特性相關

- **深色模式**

  - [深色模式功能需求](demand/ok/dark_mode_feature.md)
  - [深色模式實現文檔](implementation/dark_mode_implementation.md)

- **多國語系**

  - [多國語系功能需求](demand/ok/multi_language_feature.md)
  - [多國語系實現文檔](implementation/multi_language_implementation.md)

- **新用戶引導頁**

  - [引導頁功能需求](demand/ok/onboarding_feature.md)
  - [引導頁實現文檔](implementation/onboarding_implementation.md)

- **數據匯出**

  - [數據匯出功能需求](demand/ok/export_feature.md)

- **排版系統**
  - [排版系統實現需求](demand/ok/typography_system_implementation.md)
  - [排版指南](design/typography_guidelines.md)
  - [排版實現文檔](design/typography_implementation.md)

### 設計相關

- **UI/UX**

  - [UI/UX 設計文件](design/ui_ux_design.md)
  - [UI 原型文檔](design/ui_prototype.md)

- **視覺設計**
  - [色彩系統文檔](design/color_system.md)
  - [排版指南](design/typography_guidelines.md)

### 技術架構相關

- [技術架構文檔](technical/technical_architecture.md)

### 專案管理相關

- [開發計劃](project/development_plan.md)
- [實現計劃](project/implementation_plan.md)
- [專案進度摘要](project/project_status_summary.md)
- [更新日誌](project/changelog.md)
- [產品需求文檔](project/blood_pressure_app_prd.md)
- [文檔整理方案](project/文檔整理方案.md)

<div align="center">
  <h1><a href="#blood-pressure-manager---health-monitoring-application">English Version</a> | <a href="#血壓管家---健康監測應用程式">繁體中文版</a></h1>
</div>

# Blood Pressure Manager - Health Monitoring Application

<div align="center">
  <img src="docs/assets/images/app_logo.svg" alt="Blood Pressure Manager App Logo" width="200">
</div>

## 📱 Application Overview

"Blood Pressure Manager" is a health management application designed for users who need to regularly monitor their blood pressure. Through a clean and intuitive interface, it helps users record, track, and analyze blood pressure data, provides health recommendations, and promotes cardiovascular health management.

<div align="center">
  <img src="docs/assets/images/screenshot1.png" alt="App Screenshot - Main Page" width="250">
  <img src="docs/assets/images/screenshot2.png" alt="App Screenshot - Data Analysis" width="250">
  <img src="docs/assets/images/screenshot3.png" alt="App Screenshot - Recording Feature" width="250">
</div>

## ✨ Key Features

### 📊 Blood Pressure Recording and Tracking

- Quick recording of systolic pressure, diastolic pressure, and pulse data
- Support for adding measurement posture, arm used, and personal notes
- Automatic classification of blood pressure status (normal, elevated, stage 1 hypertension, stage 2 hypertension)
- Color-coded indicators for different blood pressure levels

### 📈 Data Analysis and Visualization

- Multi-timeframe trend charts (7 days, 2 weeks, 1 month)
- Detailed statistical analysis, including averages, highest/lowest values
- Blood pressure status distribution ratios
- Advanced analysis features including morning surge analysis and measurement condition comparisons
- Beautiful data visualizations with professional medical color scheme

### 🔔 Health Reminders and Recommendations

- Daily measurement reminder function
- Personalized health recommendations based on blood pressure data
- Professional medical knowledge tips
- Risk assessment for cardiovascular diseases
- Smart notification system with adjustable frequency

### 👤 Personal Profile Management

- User profile management
- Personal health goal setting
- Data backup and recovery
- Multi-language support (Traditional Chinese, Simplified Chinese, English)
- Medication tracking and reminder

### 📋 Advanced Features

- Health report generation in PDF format
- Lifestyle correlation analysis
- Blood pressure trend prediction
- User-friendly onboarding experience for new users
- Medication effectiveness analysis
- Data export in CSV and Excel formats

## 🛠️ Technical Features

- **Flutter Framework**: Cross-platform support, smooth user experience
- **MVVM Architecture**: Clear code structure, easy to maintain and extend
- **Local Data Storage**: Protects user privacy, no network connection required
- **Adaptive UI**: Adapts to different device sizes and screens
- **Material Design 3**: Modern design language, providing a consistent visual experience
- **Internationalization**: Full support for multiple languages (English, Traditional Chinese, Simplified Chinese)
- **Theme Customization**: Light and dark mode support
- **Professional Medical Color Scheme**: Medical blue primary color with scientifically calibrated accent colors

## 📋 User Guide

### Recording Blood Pressure

1. Click the "+" button in the bottom right corner of the main page or "Record" in the bottom navigation bar
2. Enter systolic pressure, diastolic pressure, and pulse data
3. Select measurement posture and arm used
4. Add notes (if needed)
5. Click "Save" to complete the record

### Viewing Trends

- The main page automatically displays recent blood pressure trend charts
- Different time ranges can be selected (7 days, 2 weeks, 1 month)
- Click "View Details" to enter the statistics page for more detailed analysis
- Advanced analysis features are available in the Statistics section
- Use the comparison tool to analyze different time periods or conditions

### Health Recommendations

- The main page displays health recommendations based on the user's blood pressure condition
- Click on recommendation cards to get more related information
- Risk assessment provides personalized health advice
- Access a knowledge base of professional health articles

## 🔜 Future Plans

- Multi-user management functionality
- Direct connection to Bluetooth blood pressure monitors
- Intelligent blood pressure analysis and early warning
- Cloud synchronization for data backup
- Additional language support (Japanese, Korean)
- Enhanced onboarding experience with interactive elements

## 📝 Development Status

### Project Progress

| Phase                       | Completion | Status         |
| --------------------------- | ---------- | -------------- |
| Phase 1 (Basic Features)    | 100%       | ✅ Completed   |
| Phase 2 (Advanced Analysis) | 100%       | ✅ Completed   |
| Phase 3 (Deep Analysis)     | 100%       | ✅ Completed   |
| Phase 4 (Feature Extension) | 25%        | 🔄 In Progress |
| Phase 5 (Future Plans)      | 0%         | 📝 Planning    |

### Current Work

- 🔄 User interface optimization

  - Improving visual design
  - Dark mode implementation
  - Enhancing user interaction experience

- 🔄 Data backup and recovery functionality

  - Local data backup
  - Data recovery mechanism
  - Data security safeguards

- 🔄 Application performance optimization
  - Optimizing startup time
  - Improving data processing efficiency
  - Reducing resource consumption

## 📝 Developer Notes

This application is developed using the Flutter framework and adopts the MVVM architectural design pattern.

### Environment Requirements

- Flutter 3.7.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code

### Installation and Running

```bash
# Clone the project
git clone https://github.com/yourusername/blood_pressure_app.git

# Enter the project directory
cd blood_pressure_app

# Install dependencies
flutter pub get

# Run the application
flutter run
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- Thanks to all users who provided suggestions and feedback for this project
- Special thanks to healthcare professionals for guidance on blood pressure classification standards
- Icons and design elements from [Material Design](https://material.io/design)
- Medical data reference from international health organizations

<div align="center">
  <p>Caring for your heart health</p>
  <p>© 2024 Blood Pressure Manager Team</p>
</div>

---

<div align="center">
  <h1><a href="#blood-pressure-manager---health-monitoring-application">English Version</a> | <a href="#血壓管家---健康監測應用程式">繁體中文版</a></h1>
</div>

# 血壓管家 - 健康監測應用程式

<div align="center">
  <img src="docs/assets/images/app_logo.svg" alt="血壓管家應用程式標誌" width="200">
</div>

## 📱 應用程式概述

「血壓管家」是一款專為需要定期監測血壓的用戶設計的健康管理應用程式。透過簡潔直觀的界面，幫助用戶記錄、追蹤和分析血壓數據，提供健康建議，促進心血管健康管理。

<div align="center">
  <img src="docs/assets/images/screenshot1.png" alt="應用程式截圖 - 主頁面" width="250">
  <img src="docs/assets/images/screenshot2.png" alt="應用程式截圖 - 數據分析" width="250">
  <img src="docs/assets/images/screenshot3.png" alt="應用程式截圖 - 記錄功能" width="250">
</div>

## ✨ 主要功能

### 📊 血壓記錄與追蹤

- 快速記錄收縮壓、舒張壓和脈搏數據
- 支援添加測量姿勢、使用手臂和個人備註
- 自動分類血壓狀態（正常、偏高、高血壓一級、高血壓二級）
- 不同血壓級別的顏色編碼指示器

### 📈 數據分析與視覺化

- 多時間範圍趨勢圖表（7 天、2 週、1 個月）
- 詳細統計分析，包括平均值、最高/最低值
- 血壓狀態分佈比例
- 進階分析功能，包括晨峰血壓分析和測量條件比較
- 專業醫療配色方案的精美數據視覺化

### 🔔 健康提醒與建議

- 每日測量提醒功能
- 根據血壓數據提供個性化健康建議
- 專業醫療知識小貼士
- 心血管疾病風險評估
- 可調頻率的智能通知系統

### 👤 個人檔案管理

- 用戶資料管理
- 個人健康目標設定
- 數據備份與恢復
- 多語言支援（繁體中文、簡體中文、英文）
- 用藥追蹤與提醒

### 📋 進階功能

- 健康報告生成（PDF 格式）
- 生活習慣關聯分析
- 血壓趨勢預測
- 友善的新用戶引導體驗
- 藥物有效性分析
- 數據匯出（CSV、Excel 格式）

## 🛠️ 技術特點

- **Flutter 框架**：跨平台支援，流暢的用戶體驗
- **MVVM 架構**：清晰的代碼結構，便於維護和擴展
- **本地數據存儲**：保護用戶隱私，無需網絡連接
- **自適應 UI**：適配不同尺寸的設備和屏幕
- **Material Design 3**：現代化的設計語言，提供一致的視覺體驗
- **國際化**：完整支援多種語言（英文、繁體中文、簡體中文）
- **主題定制**：支援淺色和深色模式
- **專業醫療配色方案**：醫療藍主色調搭配科學校準的輔助色彩

## 📋 使用指南

### 記錄血壓

1. 點擊主頁面右下角的「+」按鈕或底部導航欄的「記錄」
2. 輸入收縮壓、舒張壓和脈搏數據
3. 選擇測量姿勢和使用的手臂
4. 添加備註（如需要）
5. 點擊「保存」完成記錄

### 查看趨勢

- 主頁面自動顯示最近血壓趨勢圖
- 可選擇不同時間範圍（7 天、2 週、1 個月）
- 點擊「查看詳情」進入統計頁面，獲取更詳細的分析
- 在統計部分可使用進階分析功能
- 使用比較工具分析不同時期或條件的數據

### 健康建議

- 主頁面顯示根據用戶血壓狀況提供的健康建議
- 點擊建議卡片獲取更多相關信息
- 風險評估提供個性化健康建議
- 訪問專業健康文章知識庫

## 🔜 未來計劃

- 多用戶管理功能
- 藍牙血壓計直接連接功能
- 智能血壓分析與預警
- 雲端同步數據備份
- 增加更多語言支援（日文、韓文）
- 增強新用戶引導體驗，添加互動元素

## 📝 開發狀態

### 專案進度

| 階段                 | 完成度 | 狀態      |
| -------------------- | ------ | --------- |
| 第一階段（基礎功能） | 100%   | ✅ 已完成 |
| 第二階段（進階分析） | 100%   | ✅ 已完成 |
| 第三階段（深度分析） | 100%   | ✅ 已完成 |
| 第四階段（功能擴展） | 25%    | 🔄 進行中 |
| 第五階段（未來計劃） | 0%     | 📝 規劃中 |

### 目前工作

- 🔄 用戶界面優化

  - 改進視覺設計
  - 實現深色模式
  - 提升用戶交互體驗

- 🔄 數據備份與恢復功能

  - 本地數據備份
  - 數據恢復機制
  - 數據安全保障

- 🔄 應用性能優化
  - 優化啟動時間
  - 提升數據處理效率
  - 減少資源消耗

## 📝 開發者說明

本應用程式使用 Flutter 框架開發，採用 MVVM 架構設計模式。

### 環境要求

- Flutter 3.7.0 或更高版本
- Dart 3.0.0 或更高版本
- Android Studio / VS Code

### 安裝與運行

```bash
# 克隆專案
git clone https://github.com/yourusername/blood_pressure_app.git

# 進入專案目錄
cd blood_pressure_app

# 安裝依賴
flutter pub get

# 運行應用
flutter run
```

## 📄 授權協議

本專案採用 MIT 授權協議 - 詳情請參閱 [LICENSE](LICENSE) 文件。

## 🙏 致謝

- 感謝所有為本專案提供建議和反饋的用戶
- 特別感謝醫療專業人士對血壓分類標準的指導
- 圖標和設計元素來自 [Material Design](https://material.io/design)
- 醫療數據參考來自國際健康組織

<div align="center">
  <p>用心守護您的心臟健康</p>
  <p>© 2024 血壓管家團隊</p>
</div>

## 深色模式支援

血壓管家 App 提供了完整的深色模式支援，包括：

- **自動適應系統設定**：跟隨系統深色模式自動切換
- **手動設定選項**：在主題設定頁面可手動切換深淺模式
- **主題顏色自定義**：支援多種主題顏色選擇，在深淺模式下均保持一致性
- **舒適閱讀體驗**：深色模式下優化了色彩對比度，減少夜間使用時的眼睛疲勞
- **完整 UI 適應**：所有頁面和元件都專門設計了深色模式版本

要切換深色模式，請前往：我的 > 主題設定，選擇您喜歡的顯示模式。

## 新用戶引導體驗

血壓管家提供精心設計的新用戶引導體驗：

- **吸引人的引導頁面**：展示 App 核心功能和價值的精美引導頁
- **符合應用主題風格**：藍色主題設計，與應用整體視覺體驗一致
- **多語言支援**：引導頁面自動根據系統語言切換顯示語言
- **直觀的導航控制**：水平滑動切換頁面，簡單易用
- **靈活跳過選項**：可隨時跳過引導過程直接進入主應用程式

首次安裝應用後，您將自動看到這個引導體驗，幫助您快速了解如何使用血壓管家的各項功能。

## 多國語系支援

血壓管家實現了完整的多國語系支援：

- **支援多種語言**：目前支援繁體中文、簡體中文和英文
- **自動適應系統語言**：根據設備系統語言自動選擇顯示語言
- **手動語言切換**：在設定中可手動選擇偏好的顯示語言
- **統一翻譯管理**：所有 UI 文字都通過本地化系統管理，確保翻譯一致性
- **完整頁面支援**：所有頁面和功能都支援多語言顯示

未來計劃擴展支援更多語言，如日文和韓文，以滿足更廣泛用戶的需求。
