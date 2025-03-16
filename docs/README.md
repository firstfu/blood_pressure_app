# 血壓管家 App 文檔目錄

## 文件資訊

- **文件名稱**：血壓管家 App 文檔目錄說明
- **版本**：1.0
- **最後更新日期**：2024 年 5 月 16 日

## 目錄結構

```
docs/
  ├── demand/                                # 需求文檔目錄
  │   ├── todo/                              # 待實現的需求
  │   │   ├── multi_language_implementation.md  # 多語言實現需求
  │   │   └── onboarding_feature_implementation.md  # 引導頁面功能實現需求
  │   ├── ok/                                # 已完成的需求
  │   │   └── typography_system_implementation.md  # 排版系統實現需求
  │   └── cancel/                            # 已取消的需求
  ├── imgs/                                  # 圖片資源目錄
  ├── blood_pressure_app_ui_ux_design.md     # UI/UX 設計文件
  ├── typography_guidelines.md               # 排版指南
  ├── typography_implementation.md           # 排版系統實現指南
  ├── multi_language_implementation.md       # 多語言實現方案
  ├── 多國語系實現.md                         # 多語言實現方案 (繁體中文版)
  ├── onboarding_feature.md                  # 引導頁面功能文檔
  ├── onboarding_images_guide.md             # 引導頁面圖片指南
  ├── onboarding_image_prompts.md            # 引導頁面圖片提示詞
  ├── development_plan.md                    # 開發計劃
  ├── blood_pressure_app_technical_architecture.md  # 技術架構文檔
  ├── blood_pressure_app_implementation_plan.md     # 實現計劃
  ├── blood_pressure_app_prd.md              # 產品需求文檔
  └── blood_pressure_app_ui_prototype.md     # UI 原型文檔
```

## 文檔說明

### 設計文檔

- **[UI/UX 設計文件](blood_pressure_app_ui_ux_design.md)** - 應用程式的 UI/UX 設計規範，包含設計理念、品牌識別、設計系統等
- **[排版指南](typography_guidelines.md)** - 詳細的文字排版規範，包含字體大小、字重和用途
- **[排版系統實現指南](typography_implementation.md)** - 排版系統在程式碼中的實現方法和最佳實踐
- **[多語言實現方案](multi_language_implementation.md)** - 應用程式的多語言支援實現方案
- **[引導頁面功能文檔](onboarding_feature.md)** - 引導頁面功能說明
- **[引導頁面圖片指南](onboarding_images_guide.md)** - 引導頁面圖片設計指南
- **[引導頁面圖片提示詞](onboarding_image_prompts.md)** - 用於生成引導頁面圖片的提示詞

### 需求文檔

需求文檔按照實現狀態分為三類：

1. **待實現 (todo)** - 尚未實現的需求

   - **[多語言實現需求](demand/todo/multi_language_implementation.md)** - 多語言支援功能的需求文檔
   - **[引導頁面功能實現需求](demand/todo/onboarding_feature_implementation.md)** - 引導頁面功能的需求文檔

2. **已完成 (ok)** - 已經實現的需求

   - **[排版系統實現需求](demand/ok/typography_system_implementation.md)** - 排版系統的需求文檔

3. **已取消 (cancel)** - 已取消的需求

### 開發文檔

- **[開發計劃](development_plan.md)** - 應用程式的開發計劃和時間表
- **[技術架構文檔](blood_pressure_app_technical_architecture.md)** - 應用程式的技術架構和實現細節
- **[實現計劃](blood_pressure_app_implementation_plan.md)** - 應用程式的實現計劃和步驟

### 產品文檔

- **[產品需求文檔](blood_pressure_app_prd.md)** - 應用程式的產品需求文檔
- **[UI 原型文檔](blood_pressure_app_ui_prototype.md)** - 應用程式的 UI 原型文檔

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
