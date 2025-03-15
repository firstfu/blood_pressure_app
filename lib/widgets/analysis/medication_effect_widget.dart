/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 12:25:42
 * @ Description: 血壓記錄 App 服藥效果分析組件 - 顯示服藥前後的血壓變化
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MedicationEffectWidget extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const MedicationEffectWidget({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    if (!analysis['hasData']) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(analysis['message'] ?? '沒有足夠的數據進行分析', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              const Text('請確保您有記錄服藥和未服藥時的血壓數據', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    final medicatedAvg = analysis['medicatedAvg'];
    final nonMedicatedAvg = analysis['nonMedicatedAvg'];
    final difference = analysis['difference'];
    final percentChange = analysis['percentChange'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 服藥效果摘要
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.withAlpha(26), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('服藥效果摘要', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildEffectSummaryItem(
                      '收縮壓',
                      '${difference['systolic'].toStringAsFixed(1)} mmHg',
                      percentChange['systolic'].toStringAsFixed(1) + '%',
                      difference['systolic'] > 0,
                    ),
                  ),
                  Expanded(
                    child: _buildEffectSummaryItem(
                      '舒張壓',
                      '${difference['diastolic'].toStringAsFixed(1)} mmHg',
                      percentChange['diastolic'].toStringAsFixed(1) + '%',
                      difference['diastolic'] > 0,
                    ),
                  ),
                  Expanded(
                    child: _buildEffectSummaryItem(
                      '心率',
                      '${difference['pulse'].toStringAsFixed(1)} bpm',
                      percentChange['pulse'].toStringAsFixed(1) + '%',
                      difference['pulse'] > 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 服藥效果對比圖
        const Text('服藥效果對比', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 200,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String title;
                    String value;
                    if (groupIndex == 0) {
                      title = '收縮壓';
                      value = rod.toY.toStringAsFixed(1);
                    } else if (groupIndex == 1) {
                      title = '舒張壓';
                      value = rod.toY.toStringAsFixed(1);
                    } else {
                      title = '心率';
                      value = rod.toY.toStringAsFixed(1);
                    }
                    return BarTooltipItem('$title\n$value', const TextStyle(color: Colors.white));
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String text = '';
                      if (value == 0) {
                        text = '收縮壓';
                      } else if (value == 1) {
                        text = '舒張壓';
                      } else if (value == 2) {
                        text = '心率';
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(text, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value % 50 == 0) {
                        return Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10));
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 50,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                // 收縮壓
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: nonMedicatedAvg['systolic'],
                      color: Colors.red,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: medicatedAvg['systolic'],
                      color: Colors.blue,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                  ],
                ),
                // 舒張壓
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: nonMedicatedAvg['diastolic'],
                      color: Colors.red,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: medicatedAvg['diastolic'],
                      color: Colors.blue,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                  ],
                ),
                // 心率
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: nonMedicatedAvg['pulse'],
                      color: Colors.red,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: medicatedAvg['pulse'],
                      color: Colors.blue,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildLegendItem('未服藥', Colors.red), const SizedBox(width: 24), _buildLegendItem('服藥後', Colors.blue)],
        ),
        const SizedBox(height: 24),

        // 服藥效果詳細數據
        const Text('詳細數據', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey.withAlpha(77)),
          columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3), 2: FlexColumnWidth(3)},
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Colors.grey),
              children: [
                Padding(padding: EdgeInsets.all(8.0), child: Text('指標', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                Padding(padding: EdgeInsets.all(8.0), child: Text('未服藥', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                Padding(padding: EdgeInsets.all(8.0), child: Text('服藥後', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              ],
            ),
            TableRow(
              children: [
                const Padding(padding: EdgeInsets.all(8.0), child: Text('收縮壓')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${nonMedicatedAvg['systolic'].toStringAsFixed(1)} mmHg')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${medicatedAvg['systolic'].toStringAsFixed(1)} mmHg')),
              ],
            ),
            TableRow(
              children: [
                const Padding(padding: EdgeInsets.all(8.0), child: Text('舒張壓')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${nonMedicatedAvg['diastolic'].toStringAsFixed(1)} mmHg')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${medicatedAvg['diastolic'].toStringAsFixed(1)} mmHg')),
              ],
            ),
            TableRow(
              children: [
                const Padding(padding: EdgeInsets.all(8.0), child: Text('心率')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${nonMedicatedAvg['pulse'].toStringAsFixed(1)} bpm')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${medicatedAvg['pulse'].toStringAsFixed(1)} bpm')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEffectSummaryItem(String title, String value, String percent, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isPositive ? Icons.arrow_downward : Icons.arrow_upward, color: isPositive ? Colors.green : Colors.red, size: 16),
            const SizedBox(width: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isPositive ? Colors.green : Colors.red)),
          ],
        ),
        Text(percent, style: TextStyle(fontSize: 12, color: isPositive ? Colors.green : Colors.red)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [Container(width: 16, height: 16, color: color), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 12))],
    );
  }
}
