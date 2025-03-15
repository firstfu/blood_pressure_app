/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 10:45:30
 * @ Description: 血壓分類統計圓餅圖元件
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/blood_pressure_record.dart';
import '../constants/app_constants.dart';

class BPCategoryPieChart extends StatefulWidget {
  final List<BloodPressureRecord> records;
  final double size;

  const BPCategoryPieChart({super.key, required this.records, this.size = 200});

  @override
  State<BPCategoryPieChart> createState() => _BPCategoryPieChartState();
}

class _BPCategoryPieChartState extends State<BPCategoryPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.records.isEmpty) {
      return SizedBox(
        height: widget.size,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('暫無數據', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            ],
          ),
        ),
      );
    }

    // 計算各類血壓的數量
    final Map<String, int> categoryCounts = _calculateCategoryCounts();
    final List<PieChartSectionData> sections = _createPieChartSections(categoryCounts);

    return Column(
      children: [
        SizedBox(
          height: widget.size,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
                enabled: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(spacing: 16, runSpacing: 12, alignment: WrapAlignment.center, children: _buildLegendItems(categoryCounts)),
      ],
    );
  }

  Map<String, int> _calculateCategoryCounts() {
    final Map<String, int> categoryCounts = {
      AppConstants.normalStatus: 0,
      AppConstants.elevatedStatus: 0,
      AppConstants.hypertension1Status: 0,
      AppConstants.hypertension2Status: 0,
      AppConstants.hypertensionCrisisStatus: 0,
    };

    for (final record in widget.records) {
      final status = record.getBloodPressureStatus();
      categoryCounts[status] = (categoryCounts[status] ?? 0) + 1;
    }

    // 移除計數為0的類別
    categoryCounts.removeWhere((key, value) => value == 0);

    return categoryCounts;
  }

  List<PieChartSectionData> _createPieChartSections(Map<String, int> categoryCounts) {
    final List<PieChartSectionData> sections = [];
    final totalCount = widget.records.length;

    // 定義各類別的顏色
    final Map<String, Color> categoryColors = {
      AppConstants.normalStatus: const Color(0xFF43A047), // 綠色
      AppConstants.elevatedStatus: const Color(0xFFFB8C00), // 橙色
      AppConstants.hypertension1Status: const Color(0xFFE53935), // 紅色
      AppConstants.hypertension2Status: const Color(0xFFD32F2F), // 深紅色
      AppConstants.hypertensionCrisisStatus: const Color(0xFFB71C1C), // 更深的紅色
    };

    int index = 0;
    categoryCounts.forEach((category, count) {
      final percentage = (count / totalCount * 100).toStringAsFixed(1);
      final color = categoryColors[category] ?? Colors.grey;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 70.0 : 60.0;
      final fontSize = isTouched ? 16.0 : 14.0;
      final fontWeight = isTouched ? FontWeight.bold : FontWeight.normal;

      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$percentage%',
          color: color,
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: Colors.white),
          badgeWidget: isTouched ? _Badge(category: category, count: count, percentage: percentage, color: color) : null,
          badgePositionPercentageOffset: 1.2,
        ),
      );
      index++;
    });

    return sections;
  }

  List<Widget> _buildLegendItems(Map<String, int> categoryCounts) {
    final List<Widget> legendItems = [];
    final totalCount = widget.records.length;

    // 定義各類別的顏色
    final Map<String, Color> categoryColors = {
      AppConstants.normalStatus: const Color(0xFF43A047), // 綠色
      AppConstants.elevatedStatus: const Color(0xFFFB8C00), // 橙色
      AppConstants.hypertension1Status: const Color(0xFFE53935), // 紅色
      AppConstants.hypertension2Status: const Color(0xFFD32F2F), // 深紅色
      AppConstants.hypertensionCrisisStatus: const Color(0xFFB71C1C), // 更深的紅色
    };

    categoryCounts.forEach((category, count) {
      final percentage = (count / totalCount * 100).toStringAsFixed(1);
      final color = categoryColors[category] ?? Colors.grey;

      legendItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text('$category: $count 筆 ($percentage%)', style: const TextStyle(fontSize: 14)),
          ],
        ),
      );
    });

    return legendItems;
  }
}

class _Badge extends StatelessWidget {
  final String category;
  final int count;
  final String percentage;
  final Color color;

  const _Badge({required this.category, required this.count, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 4, offset: const Offset(0, 2))],
        border: Border.all(color: color.withAlpha(51), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text('$count 筆 ($percentage%)', style: const TextStyle(color: Colors.black87, fontSize: 12)),
        ],
      ),
    );
  }
}
