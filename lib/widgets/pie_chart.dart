/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-16 16:16:42
 * @ Description: 血壓記錄 App 圓餅圖組件 - 顯示血壓分佈情況
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/blood_pressure_record.dart';
import '../themes/app_theme.dart';

class BloodPressurePieChart extends StatelessWidget {
  final List<BloodPressureRecord> records;

  const BloodPressurePieChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 48, color: AppTheme.textSecondaryColor.withAlpha(128)),
            const SizedBox(height: 16),
            Text('暫無數據', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondaryColor.withAlpha(179))),
          ],
        ),
      );
    }

    // 計算血壓分類數量
    final Map<String, int> bloodPressureCategories = _calculateBloodPressureCategories();

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: _getSections(bloodPressureCategories),
        pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {}, enabled: true),
      ),
    );
  }

  // 計算血壓分類數量
  Map<String, int> _calculateBloodPressureCategories() {
    final Map<String, int> categories = {'正常': 0, '偏高': 0, '高血壓': 0};

    for (final record in records) {
      if (record.systolic < 120 && record.diastolic < 80) {
        categories['正常'] = (categories['正常'] ?? 0) + 1;
      } else if (record.systolic < 140 && record.diastolic < 90) {
        categories['偏高'] = (categories['偏高'] ?? 0) + 1;
      } else {
        categories['高血壓'] = (categories['高血壓'] ?? 0) + 1;
      }
    }

    return categories;
  }

  // 獲取圓餅圖區塊
  List<PieChartSectionData> _getSections(Map<String, int> categories) {
    final List<PieChartSectionData> sections = [];
    final int total = records.length;

    // 正常血壓 - 綠色
    if (categories['正常']! > 0) {
      sections.add(
        PieChartSectionData(
          color: AppTheme.successColor,
          value: categories['正常']!.toDouble(),
          title: '${((categories['正常']! / total) * 100).toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }

    // 偏高血壓 - 黃色
    if (categories['偏高']! > 0) {
      sections.add(
        PieChartSectionData(
          color: AppTheme.warningColor,
          value: categories['偏高']!.toDouble(),
          title: '${((categories['偏高']! / total) * 100).toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }

    // 高血壓 - 橙色
    if (categories['高血壓']! > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.orange,
          value: categories['高血壓']!.toDouble(),
          title: '${((categories['高血壓']! / total) * 100).toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }

    return sections;
  }
}
