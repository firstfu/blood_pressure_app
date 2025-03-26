/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-27 15:20:30
 * @ Description: 血壓記錄 App 數據匯出服務 - 支援 CSV 和 Excel 格式匯出
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import '../models/blood_pressure_record.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';

class ExportService {
  /// 生成 CSV 格式的血壓記錄數據
  static Future<String> generateCSV(List<BloodPressureRecord> records, {BuildContext? context}) async {
    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => b.measureTime.compareTo(a.measureTime));

    // 創建 CSV 數據
    List<List<dynamic>> csvData = [];

    // 從 context 獲取多語系支援或使用預設值
    final translations = _getTranslations(context);

    // 添加標題行
    csvData.add([
      translations['測量時間']!,
      '${translations['收縮壓']!} (mmHg)',
      '${translations['舒張壓']!} (mmHg)',
      '${translations['心率']!} (bpm)',
      translations['測量姿勢']!,
      translations['測量部位']!,
      translations['是否服藥']!,
      translations['備註']!,
      translations['血壓狀態']!,
    ]);

    // 添加數據行
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
    final yesText = translations['是'] ?? '是';
    final noText = translations['否'] ?? '否';

    for (var record in sortedRecords) {
      csvData.add([
        dateFormat.format(record.measureTime),
        record.systolic,
        record.diastolic,
        record.pulse,
        _getLocalizedPositionText(record.position, translations),
        _getLocalizedArmText(record.arm, translations),
        record.isMedicated ? yesText : noText,
        record.note ?? '',
        _getLocalizedBloodPressureStatus(record.getBloodPressureStatus(), translations),
      ]);
    }

    // 轉換為 CSV 字符串
    String csv = const ListToCsvConverter().convert(csvData);

    // 獲取臨時目錄
    final tempDir = await getTemporaryDirectory();
    final fileName = '${translations['血壓記錄'] ?? '血壓記錄'}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
    final file = File('${tempDir.path}/$fileName');

    // 寫入文件
    await file.writeAsString(csv);

    return file.path;
  }

  /// 生成 Excel 格式的血壓記錄數據
  static Future<String> generateExcel(List<BloodPressureRecord> records, {BuildContext? context}) async {
    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => b.measureTime.compareTo(a.measureTime));

    // 創建 Excel 文檔
    final excel = Excel.createExcel();

    // 從 context 獲取多語系支援或使用預設值
    final translations = _getTranslations(context);

    // 使用翻譯後的 sheet 名稱
    final sheetName = translations['血壓記錄'] ?? '血壓記錄';
    final sheet = excel[sheetName];

    // 設置標題行樣式
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#E3F2FD'),
      fontColorHex: ExcelColor.fromHexString('#1565C0'),
    );

    // 添加標題行
    final headers = [
      translations['測量時間']!,
      '${translations['收縮壓']!} (mmHg)',
      '${translations['舒張壓']!} (mmHg)',
      '${translations['心率']!} (bpm)',
      translations['測量姿勢']!,
      translations['測量部位']!,
      translations['是否服藥']!,
      translations['備註']!,
      translations['血壓狀態']!,
    ];

    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // 添加數據行
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
    final yesText = translations['是'] ?? '是';
    final noText = translations['否'] ?? '否';

    for (var i = 0; i < sortedRecords.length; i++) {
      final record = sortedRecords[i];
      final rowIndex = i + 1;

      // 設置單元格值
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue(dateFormat.format(record.measureTime));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = IntCellValue(record.systolic);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).value = IntCellValue(record.diastolic);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).value = IntCellValue(record.pulse);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex)).value = TextCellValue(
        _getLocalizedPositionText(record.position, translations),
      );
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex)).value = TextCellValue(
        _getLocalizedArmText(record.arm, translations),
      );
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex)).value = TextCellValue(record.isMedicated ? yesText : noText);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex)).value = TextCellValue(record.note ?? '');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex)).value = TextCellValue(
        _getLocalizedBloodPressureStatus(record.getBloodPressureStatus(), translations),
      );

      // 根據血壓狀態設置顏色
      String status = record.getBloodPressureStatus();
      String colorHexStr = '#FFFFFF'; // 默認白色

      if (status == AppConstants.normalStatus) {
        colorHexStr = '#E8F5E9'; // 淺綠色
      } else if (status == AppConstants.elevatedStatus) {
        colorHexStr = '#FFF3E0'; // 淺橙色
      } else if (status == AppConstants.hypertension1Status) {
        colorHexStr = '#FFEBEE'; // 淺紅色
      } else if (status == AppConstants.hypertension2Status) {
        colorHexStr = '#FFCDD2'; // 中紅色
      } else if (status == AppConstants.hypertensionCrisisStatus) {
        colorHexStr = '#EF9A9A'; // 深紅色
      }

      // 創建顏色對象
      final colorHex = ExcelColor.fromHexString(colorHexStr);

      // 設置行背景色
      final rowStyle = CellStyle(backgroundColorHex: colorHex);
      for (var j = 0; j < headers.length; j++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: rowIndex)).cellStyle = rowStyle;
      }
    }

    // 調整列寬
    sheet.setColumnWidth(0, 20); // 測量時間
    sheet.setColumnWidth(7, 25); // 備註
    sheet.setColumnWidth(8, 15); // 血壓狀態

    // 獲取臨時目錄
    final tempDir = await getTemporaryDirectory();
    final fileName = '${translations['血壓記錄'] ?? '血壓記錄'}_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
    final file = File('${tempDir.path}/$fileName');

    // 寫入文件
    final excelBytes = excel.encode();
    if (excelBytes != null) {
      await file.writeAsBytes(excelBytes);
    }

    return file.path;
  }

  // 獲取多語系翻譯
  static Map<String, String> _getTranslations(BuildContext? context) {
    if (context == null) {
      // 默認中文翻譯
      return {
        '測量時間': '測量時間',
        '收縮壓': '收縮壓',
        '舒張壓': '舒張壓',
        '心率': '心率',
        '測量姿勢': '測量姿勢',
        '測量部位': '測量部位',
        '是否服藥': '是否服藥',
        '備註': '備註',
        '血壓狀態': '血壓狀態',
        '是': '是',
        '否': '否',
        '血壓記錄': '血壓記錄',
        '正常': '正常',
        '偏高': '偏高',
        '高血壓一級': '高血壓一級',
        '高血壓二級': '高血壓二級',
        '高血壓危象': '高血壓危象',
        '坐姿': '坐姿',
        '臥姿': '臥姿',
        '站姿': '站姿',
        '左臂': '左臂',
        '右臂': '右臂',
      };
    }

    // 使用 context 獲取當前語系翻譯
    return {
      '測量時間': AppLocalizations.of(context).translate('測量時間'),
      '收縮壓': AppLocalizations.of(context).translate('收縮壓'),
      '舒張壓': AppLocalizations.of(context).translate('舒張壓'),
      '心率': AppLocalizations.of(context).translate('心率'),
      '測量姿勢': AppLocalizations.of(context).translate('測量姿勢'),
      '測量部位': AppLocalizations.of(context).translate('測量部位'),
      '是否服藥': AppLocalizations.of(context).translate('是否服藥'),
      '備註': AppLocalizations.of(context).translate('備註'),
      '血壓狀態': AppLocalizations.of(context).translate('血壓狀態'),
      '是': AppLocalizations.of(context).translate('是'),
      '否': AppLocalizations.of(context).translate('否'),
      '血壓記錄': AppLocalizations.of(context).translate('血壓記錄'),
      '正常': AppLocalizations.of(context).translate('正常'),
      '偏高': AppLocalizations.of(context).translate('偏高'),
      '高血壓一級': AppLocalizations.of(context).translate('高血壓一級'),
      '高血壓二級': AppLocalizations.of(context).translate('高血壓二級'),
      '高血壓危象': AppLocalizations.of(context).translate('高血壓危象'),
      '坐姿': AppLocalizations.of(context).translate('坐姿'),
      '臥姿': AppLocalizations.of(context).translate('臥姿'),
      '站姿': AppLocalizations.of(context).translate('站姿'),
      '左臂': AppLocalizations.of(context).translate('左臂'),
      '右臂': AppLocalizations.of(context).translate('右臂'),
    };
  }

  // 獲取本地化的姿勢文本
  static String _getLocalizedPositionText(String position, Map<String, String> translations) {
    switch (position) {
      case '坐姿':
        return translations['坐姿'] ?? '坐姿';
      case '臥姿':
        return translations['臥姿'] ?? '臥姿';
      case '站姿':
        return translations['站姿'] ?? '站姿';
      default:
        return position;
    }
  }

  // 獲取本地化的測量部位文本
  static String _getLocalizedArmText(String arm, Map<String, String> translations) {
    switch (arm) {
      case '左臂':
        return translations['左臂'] ?? '左臂';
      case '右臂':
        return translations['右臂'] ?? '右臂';
      default:
        return arm;
    }
  }

  // 獲取本地化的血壓狀態
  static String _getLocalizedBloodPressureStatus(String status, Map<String, String> translations) {
    switch (status) {
      case '正常':
        return translations['正常'] ?? '正常';
      case '偏高':
        return translations['偏高'] ?? '偏高';
      case '高血壓一級':
        return translations['高血壓一級'] ?? '高血壓一級';
      case '高血壓二級':
        return translations['高血壓二級'] ?? '高血壓二級';
      case '高血壓危象':
        return translations['高血壓危象'] ?? '高血壓危象';
      default:
        return status;
    }
  }
}
