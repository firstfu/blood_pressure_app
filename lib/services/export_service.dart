/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-27 15:20:30
 * @ Description: 血壓記錄 App 數據匯出服務 - 支援 CSV 和 Excel 格式匯出
 */

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import '../models/blood_pressure_record.dart';
import '../constants/app_constants.dart';

class ExportService {
  /// 生成 CSV 格式的血壓記錄數據
  static Future<String> generateCSV(List<BloodPressureRecord> records) async {
    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => b.measureTime.compareTo(a.measureTime));

    // 創建 CSV 數據
    List<List<dynamic>> csvData = [];

    // 添加標題行
    csvData.add(['測量時間', '收縮壓 (mmHg)', '舒張壓 (mmHg)', '心率 (bpm)', '測量姿勢', '測量部位', '是否服藥', '備註', '血壓狀態']);

    // 添加數據行
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
    for (var record in sortedRecords) {
      csvData.add([
        dateFormat.format(record.measureTime),
        record.systolic,
        record.diastolic,
        record.pulse,
        record.position,
        record.arm,
        record.isMedicated ? '是' : '否',
        record.note ?? '',
        record.getBloodPressureStatus(),
      ]);
    }

    // 轉換為 CSV 字符串
    String csv = const ListToCsvConverter().convert(csvData);

    // 獲取臨時目錄
    final tempDir = await getTemporaryDirectory();
    final fileName = '血壓記錄_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
    final file = File('${tempDir.path}/$fileName');

    // 寫入文件
    await file.writeAsString(csv);

    return file.path;
  }

  /// 生成 Excel 格式的血壓記錄數據
  static Future<String> generateExcel(List<BloodPressureRecord> records) async {
    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => b.measureTime.compareTo(a.measureTime));

    // 創建 Excel 文檔
    final excel = Excel.createExcel();
    final sheet = excel['血壓記錄'];

    // 設置標題行樣式
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#E3F2FD'),
      fontColorHex: ExcelColor.fromHexString('#1565C0'),
    );

    // 添加標題行
    final headers = ['測量時間', '收縮壓 (mmHg)', '舒張壓 (mmHg)', '心率 (bpm)', '測量姿勢', '測量部位', '是否服藥', '備註', '血壓狀態'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // 添加數據行
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
    for (var i = 0; i < sortedRecords.length; i++) {
      final record = sortedRecords[i];
      final rowIndex = i + 1;

      // 設置單元格值
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue(dateFormat.format(record.measureTime));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = IntCellValue(record.systolic);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex)).value = IntCellValue(record.diastolic);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex)).value = IntCellValue(record.pulse);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex)).value = TextCellValue(record.position);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex)).value = TextCellValue(record.arm);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex)).value = TextCellValue(record.isMedicated ? '是' : '否');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex)).value = TextCellValue(record.note ?? '');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex)).value = TextCellValue(record.getBloodPressureStatus());

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
    final fileName = '血壓記錄_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
    final file = File('${tempDir.path}/$fileName');

    // 寫入文件
    final excelBytes = excel.encode();
    if (excelBytes != null) {
      await file.writeAsBytes(excelBytes);
    }

    return file.path;
  }
}
