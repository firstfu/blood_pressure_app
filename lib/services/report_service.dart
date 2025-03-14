/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 11:30:30
 * @ Description: 血壓記錄 App 報告生成服務
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/blood_pressure_record.dart';
import '../constants/app_constants.dart';
import '../utils/date_time_utils.dart';

class ReportService {
  /// 生成健康報告 PDF
  static Future<Uint8List> generateReport({
    required List<BloodPressureRecord> records,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, int> categoryCounts,
    required Map<String, double> statistics,
    required String timeRangeText,
  }) async {
    // 加載字體
    final fontData = await rootBundle.load('assets/fonts/NotoSansTC-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load('assets/fonts/NotoSansTC-Bold.ttf');
    final boldTtf = pw.Font.ttf(boldFontData);

    // 創建 PDF 文檔
    final pdf = pw.Document();

    // 添加頁面
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildReportHeader(context, ttf, boldTtf, startDate, endDate),
        footer: (context) => _buildReportFooter(context, ttf),
        build:
            (context) => [
              // 統計摘要
              _buildStatisticsSummary(context, ttf, boldTtf, statistics, records.length),
              pw.SizedBox(height: 20),
              // 血壓分類統計
              _buildCategoryStatistics(context, ttf, boldTtf, categoryCounts, records.length),
              pw.SizedBox(height: 20),
              // 健康建議
              _buildHealthTips(context, ttf, boldTtf),
              pw.SizedBox(height: 20),
              // 記錄詳情
              _buildRecordsTable(context, ttf, boldTtf, records),
            ],
      ),
    );

    // 返回 PDF 文檔的字節數據
    return pdf.save();
  }

  /// 構建報告頁眉
  static pw.Widget _buildReportHeader(pw.Context context, pw.Font ttf, pw.Font boldTtf, DateTime startDate, DateTime endDate) {
    final dateFormat = DateFormat('yyyy年MM月dd日');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('血壓健康報告', style: pw.TextStyle(font: boldTtf, fontSize: 24, color: PdfColors.blue800)),
            pw.Text('生成日期: ${dateFormat.format(DateTime.now())}', style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey700)),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '報告期間: ${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
          style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey700),
        ),
        pw.Divider(color: PdfColors.grey400),
      ],
    );
  }

  /// 構建報告頁腳
  static pw.Widget _buildReportFooter(pw.Context context, pw.Font ttf) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('血壓管家 App', style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
            pw.Text('第 ${context.pageNumber} 頁，共 ${context.pagesCount} 頁', style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
          ],
        ),
      ],
    );
  }

  /// 構建統計摘要
  static pw.Widget _buildStatisticsSummary(pw.Context context, pw.Font ttf, pw.Font boldTtf, Map<String, double> statistics, int recordCount) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('血壓統計摘要', style: pw.TextStyle(font: boldTtf, fontSize: 16, color: PdfColors.blue800)),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(color: PdfColors.blue50, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
          child: pw.Column(
            children: [
              pw.Row(
                children: [
                  _buildStatItem(ttf, boldTtf, '平均收縮壓', '${statistics['avgSystolic']?.toStringAsFixed(1)} mmHg', PdfColors.red),
                  _buildStatItem(ttf, boldTtf, '平均舒張壓', '${statistics['avgDiastolic']?.toStringAsFixed(1)} mmHg', PdfColors.green),
                  _buildStatItem(ttf, boldTtf, '平均心率', '${statistics['avgPulse']?.toStringAsFixed(1)} bpm', PdfColors.orange),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  _buildStatItem(ttf, boldTtf, '最高收縮壓', '${statistics['maxSystolic']?.toInt()} mmHg', PdfColors.red),
                  _buildStatItem(ttf, boldTtf, '最高舒張壓', '${statistics['maxDiastolic']?.toInt()} mmHg', PdfColors.green),
                  _buildStatItem(ttf, boldTtf, '最高心率', '${statistics['maxPulse']?.toInt()} bpm', PdfColors.orange),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  _buildStatItem(ttf, boldTtf, '最低收縮壓', '${statistics['minSystolic']?.toInt()} mmHg', PdfColors.red),
                  _buildStatItem(ttf, boldTtf, '最低舒張壓', '${statistics['minDiastolic']?.toInt()} mmHg', PdfColors.green),
                  _buildStatItem(ttf, boldTtf, '最低心率', '${statistics['minPulse']?.toInt()} bpm', PdfColors.orange),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  _buildStatItem(ttf, boldTtf, '記錄總數', '$recordCount 筆', PdfColors.blue800),
                  pw.Expanded(child: pw.Container()),
                  pw.Expanded(child: pw.Container()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 構建統計項目
  static pw.Expanded _buildStatItem(pw.Font ttf, pw.Font boldTtf, String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey700)),
          pw.SizedBox(height: 4),
          pw.Text(value, style: pw.TextStyle(font: boldTtf, fontSize: 14, color: color)),
        ],
      ),
    );
  }

  /// 構建血壓分類統計
  static pw.Widget _buildCategoryStatistics(pw.Context context, pw.Font ttf, pw.Font boldTtf, Map<String, int> categoryCounts, int totalCount) {
    // 定義各類別的顏色
    final Map<String, PdfColor> categoryColors = {
      AppConstants.normalStatus: PdfColors.green,
      AppConstants.elevatedStatus: PdfColors.orange,
      AppConstants.hypertension1Status: PdfColors.red,
      AppConstants.hypertension2Status: PdfColors.red900,
      AppConstants.hypertensionCrisisStatus: PdfColors.deepPurple900,
    };

    final List<pw.Widget> categoryItems = [];

    categoryCounts.forEach((category, count) {
      final percentage = (count / totalCount * 100).toStringAsFixed(1);
      final color = categoryColors[category] ?? PdfColors.grey;

      categoryItems.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            children: [
              pw.Container(width: 12, height: 12, decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle)),
              pw.SizedBox(width: 8),
              pw.Expanded(child: pw.Text(category, style: pw.TextStyle(font: ttf, fontSize: 12, color: PdfColors.grey800))),
              pw.SizedBox(width: 8),
              pw.Text('$count 筆 ($percentage%)', style: pw.TextStyle(font: boldTtf, fontSize: 12, color: color)),
            ],
          ),
        ),
      );
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('血壓分類統計', style: pw.TextStyle(font: boldTtf, fontSize: 16, color: PdfColors.blue800)),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(color: PdfColors.blue50, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: categoryItems),
        ),
      ],
    );
  }

  /// 構建健康建議
  static pw.Widget _buildHealthTips(pw.Context context, pw.Font ttf, pw.Font boldTtf) {
    final List<pw.Widget> tipItems = [];

    for (final tip in AppConstants.healthTipsList) {
      tipItems.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 6,
                height: 6,
                margin: const pw.EdgeInsets.only(top: 4),
                decoration: const pw.BoxDecoration(color: PdfColors.blue800, shape: pw.BoxShape.circle),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(child: pw.Text(tip, style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey800))),
            ],
          ),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('健康建議', style: pw.TextStyle(font: boldTtf, fontSize: 16, color: PdfColors.blue800)),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(color: PdfColors.blue50, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: tipItems),
        ),
      ],
    );
  }

  /// 構建記錄表格
  static pw.Widget _buildRecordsTable(pw.Context context, pw.Font ttf, pw.Font boldTtf, List<BloodPressureRecord> records) {
    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => b.measureTime.compareTo(a.measureTime));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('血壓記錄詳情', style: pw.TextStyle(font: boldTtf, fontSize: 16, color: PdfColors.blue800)),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(2),
            4: const pw.FlexColumnWidth(3),
          },
          children: [
            // 表頭
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                _buildTableCell(ttf, '測量時間', isHeader: true),
                _buildTableCell(ttf, '收縮壓', isHeader: true),
                _buildTableCell(ttf, '舒張壓', isHeader: true),
                _buildTableCell(ttf, '心率', isHeader: true),
                _buildTableCell(ttf, '備註', isHeader: true),
              ],
            ),
            // 表格內容
            ...sortedRecords.map((record) {
              final dateFormat = DateFormat('yyyy/MM/dd HH:mm');
              return pw.TableRow(
                children: [
                  _buildTableCell(ttf, dateFormat.format(record.measureTime)),
                  _buildTableCell(ttf, '${record.systolic} mmHg'),
                  _buildTableCell(ttf, '${record.diastolic} mmHg'),
                  _buildTableCell(ttf, '${record.pulse} bpm'),
                  _buildTableCell(ttf, record.note ?? '-'),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  /// 構建表格單元格
  static pw.Widget _buildTableCell(pw.Font ttf, String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: ttf,
          fontSize: isHeader ? 10 : 9,
          color: isHeader ? PdfColors.blue800 : PdfColors.grey800,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// 保存報告到文件並分享
  static Future<void> saveAndShareReport(Uint8List pdfData, String fileName) async {
    try {
      // 獲取臨時目錄
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');

      // 寫入文件
      await file.writeAsBytes(pdfData);

      // 分享文件
      await Share.shareXFiles([XFile(file.path)], text: '血壓健康報告');
    } catch (e) {
      print('保存或分享報告時出錯: $e');
      rethrow;
    }
  }
}
