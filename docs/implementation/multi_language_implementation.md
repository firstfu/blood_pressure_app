# 血壓管家 App 多國語系實現

## 需求分析

### 目標

- 實現應用程式的多國語系支援，初期支援繁體中文和英文
- 使用中文作為語系調用的 key
- 提供語系切換功能
- 保存用戶的語系偏好設定

### 技術方案

1. **語系文件結構**

   - 使用 Map<String, String> 存儲語系鍵值對
   - 將語系文件放在 lib/l10n 目錄下
   - 使用中文作為 key，對應不同語系的翻譯

2. **語系管理**

   - 使用 Provider 管理語系狀態
   - 使用 SharedPreferences 保存用戶語系偏好
   - 提供語系切換功能

3. **語系使用方式**
   - 提供 BuildContext 擴展方法 tr() 方便在代碼中使用
   - 使用 context.tr('中文 key') 獲取當前語系的翻譯

## 實現步驟

### 1. 創建語系文件

- 創建 lib/l10n 目錄
- 創建繁體中文語系文件 app_zh_TW.dart
- 創建英文語系文件 app_en_US.dart

### 2. 創建語系管理類

- 創建 AppLocalizations 類管理語系資源
- 創建 AppLocalizationsDelegate 類實現 LocalizationsDelegate

### 3. 創建語系擴展方法

- 創建 BuildContext 擴展方法 tr() 方便在代碼中使用

### 4. 創建語系提供者

- 創建 LocaleProvider 類管理語系狀態
- 使用 SharedPreferences 保存用戶語系偏好

### 5. 創建語系設定頁面

- 創建 LanguageSettingsPage 頁面提供語系切換功能

### 6. 修改主入口文件

- 修改 main.dart 文件，整合多國語系功能
- 使用 Provider 管理語系狀態

### 7. 修改現有頁面

- 修改 MainPage 頁面，使用多國語系
- 修改 ProfilePage 頁面，添加語言設定選項

## 進度追蹤

- [x] 創建語系文件目錄和文件
- [x] 創建語系管理類
- [x] 創建語系擴展方法
- [x] 創建語系提供者
- [x] 創建語系設定頁面
- [x] 修改主入口文件
- [x] 修改 MainPage 頁面
- [x] 修改 ProfilePage 頁面
- [ ] 修改其他頁面以支持多國語系
- [ ] 測試不同語系下的顯示效果
- [ ] 優化語系切換體驗

## 注意事項

1. 所有硬編碼的文字都應該使用 context.tr('中文 key') 方式獲取翻譯
2. 新增頁面或功能時，需要同時更新語系文件
3. 語系文件的 key 使用中文，方便開發和維護
4. 語系切換後，需要重新構建頁面以顯示新的語系
