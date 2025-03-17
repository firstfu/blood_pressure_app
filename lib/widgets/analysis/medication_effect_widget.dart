/*
 * @ Author: firstfu
 * @ Create Time: 2024-07-23 17:15:12
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
        // 服藥效果摘要 - 優化後的設計
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.withAlpha(26), Colors.lightBlue.withAlpha(13)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medication_outlined, color: Colors.blue.withAlpha(179), size: 18),
                  const SizedBox(width: 8),
                  const Text('服藥效果摘要', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildEffectSummaryItem(
                      '收縮壓',
                      '${difference['systolic'].toStringAsFixed(1)} mmHg',
                      percentChange['systolic'].toStringAsFixed(1) + '%',
                      difference['systolic'] > 0,
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.withAlpha(51)),
                  Expanded(
                    child: _buildEffectSummaryItem(
                      '舒張壓',
                      '${difference['diastolic'].toStringAsFixed(1)} mmHg',
                      percentChange['diastolic'].toStringAsFixed(1) + '%',
                      difference['diastolic'] > 0,
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.withAlpha(51)),
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
        Row(
          children: [
            Icon(Icons.bar_chart_outlined, color: Colors.blue.withAlpha(179), size: 16),
            const SizedBox(width: 6),
            const Text('服藥效果對比', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 220,
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
                          return BarTooltipItem('$title\n$value', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
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
                        return FlLine(color: Colors.grey.withAlpha(26), strokeWidth: 1, dashArray: [5, 5]);
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
                            color: Colors.red.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                          BarChartRodData(
                            toY: medicatedAvg['systolic'],
                            color: Colors.blue.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                        ],
                      ),
                      // 舒張壓
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: nonMedicatedAvg['diastolic'],
                            color: Colors.red.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                          BarChartRodData(
                            toY: medicatedAvg['diastolic'],
                            color: Colors.blue.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                        ],
                      ),
                      // 心率
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: nonMedicatedAvg['pulse'],
                            color: Colors.red.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                          BarChartRodData(
                            toY: medicatedAvg['pulse'],
                            color: Colors.blue.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildLegendItem('未服藥', Colors.red), const SizedBox(width: 24), _buildLegendItem('服藥後', Colors.blue)],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 服藥效果詳細數據
        Row(
          children: [
            Icon(Icons.analytics_outlined, color: Colors.blue.withAlpha(179), size: 16),
            const SizedBox(width: 6),
            const Text('詳細數據', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withAlpha(51)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 2, offset: const Offset(0, 1))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.withAlpha(51)),
                verticalInside: BorderSide(color: Colors.grey.withAlpha(51)),
              ),
              columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3), 2: FlexColumnWidth(3)},
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.withAlpha(77), Colors.blue.withAlpha(51)],
                    ),
                  ),
                  children: const [
                    Padding(padding: EdgeInsets.all(10.0), child: Text('指標', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                    Padding(padding: EdgeInsets.all(10.0), child: Text('未服藥', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                    Padding(padding: EdgeInsets.all(10.0), child: Text('服藥後', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: Colors.white),
                  children: [
                    const Padding(padding: EdgeInsets.all(10.0), child: Text('收縮壓', style: TextStyle(color: Colors.black87))),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${nonMedicatedAvg['systolic'].toStringAsFixed(1)} mmHg',
                        style: TextStyle(color: Colors.red.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${medicatedAvg['systolic'].toStringAsFixed(1)} mmHg',
                        style: TextStyle(color: Colors.blue.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.withAlpha(13)),
                  children: [
                    const Padding(padding: EdgeInsets.all(10.0), child: Text('舒張壓', style: TextStyle(color: Colors.black87))),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${nonMedicatedAvg['diastolic'].toStringAsFixed(1)} mmHg',
                        style: TextStyle(color: Colors.red.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${medicatedAvg['diastolic'].toStringAsFixed(1)} mmHg',
                        style: TextStyle(color: Colors.blue.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: Colors.white),
                  children: [
                    const Padding(padding: EdgeInsets.all(10.0), child: Text('心率', style: TextStyle(color: Colors.black87))),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${nonMedicatedAvg['pulse'].toStringAsFixed(1)} bpm',
                        style: TextStyle(color: Colors.red.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${medicatedAvg['pulse'].toStringAsFixed(1)} bpm',
                        style: TextStyle(color: Colors.blue.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEffectSummaryItem(String title, String value, String percent, bool isPositive) {
    final Color valueColor = isPositive ? Colors.green : Colors.red;
    final Color percentColor = isPositive ? Colors.green.withAlpha(204) : Colors.red.withAlpha(204);
    final IconData arrowIcon = isPositive ? Icons.arrow_downward : Icons.arrow_upward;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(arrowIcon, color: valueColor, size: 14),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, color: valueColor, fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(color: percentColor.withAlpha(26), borderRadius: BorderRadius.circular(10)),
          child: Text(percent, style: TextStyle(fontSize: 10, color: percentColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(51), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5))),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color.withAlpha(204))),
        ],
      ),
    );
  }
}
