# 更改日誌

## 2025-05-27

### 深色模式支持

- 實現完整的深色模式支持
  - 所有頁面和元件都適配深色模式
  - 優化深色模式下的色彩對比度
  - 確保文字和圖標在深色模式下清晰可見
- 添加深色模式設定頁面
  - 自動跟隨系統設定
  - 手動切換深淺模式選項
  - 主題顏色選擇保持一致性

## 2025-04-15

### 引導頁面優化

- 更新引導頁面設計，採用藍色主題
  - 與應用整體視覺風格保持一致
  - 優化頁面佈局和過渡動畫
- 添加多語言支持，使引導頁面內容根據系統語言自動切換
- 改進引導頁面的可訪問性
  - 增加頁面指示器顏色對比度
  - 優化按鈕大小和位置

## 2025-03-23

### Add Record 頁面改進

- 在 AppBar 右上角添加了保存按鈕，方便用戶快速保存記錄
- 修復了底部按鈕文字被截斷的問題
  - 增加按鈕高度從 48 到 52
  - 增加按鈕內邊距
  - 使用 FittedBox 確保文字正確縮放
- 添加並完善了多國語系支持
  - 添加所有缺失的文字翻譯
  - 確保所有 UI 元素都使用本地化文字
