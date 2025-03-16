/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-16 14:30:00
 * @ Description: 匯出格式選擇器組件 - 提供 CSV 和 Excel 匯出選項
 */

import 'package:flutter/material.dart';
import '../../l10n/app_localizations_extension.dart';

/// 匯出格式選擇器
///
/// 顯示一個底部彈出選單，讓用戶選擇匯出格式（CSV 或 Excel）
///
/// 參數:
/// - `onExportCSV`: 當用戶選擇 CSV 格式時的回調函數
/// - `onExportExcel`: 當用戶選擇 Excel 格式時的回調函數
/// - `hasData`: 是否有數據可以匯出，默認為 true
class ExportFormatSelector {
  /// 顯示匯出格式選擇器
  static Future<void> show({
    required BuildContext context,
    required Function() onExportCSV,
    required Function() onExportExcel,
    bool hasData = true,
  }) async {
    if (!hasData) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('暫無數據，無法匯出'))));
      return;
    }

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(context.tr('選擇匯出格式'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: Text(context.tr('匯出為 CSV 檔案')),
                subtitle: Text(context.tr('適用於 Excel、Google 試算表等')),
                onTap: () {
                  Navigator.pop(context);
                  onExportCSV();
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_view, color: Colors.blue),
                title: Text(context.tr('匯出為 Excel 檔案')),
                subtitle: Text(context.tr('包含格式化和顏色標記')),
                onTap: () {
                  Navigator.pop(context);
                  onExportExcel();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
