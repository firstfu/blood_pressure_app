/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 12:30:42
 * @ Description: 血壓記錄 App 測量條件分析組件 - 顯示不同測量條件下的血壓差異
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blood_pressure_app/l10n/app_localizations_extension.dart';

class PositionArmEffectWidget extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const PositionArmEffectWidget({super.key, required this.analysis});

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
              Text(analysis['message'] ?? context.tr('沒有足夠的數據進行分析'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(context.tr('請確保您有記錄不同測量條件下的血壓數據'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    final positionAnalysis = analysis['positionAnalysis'];
    final armAnalysis = analysis['armAnalysis'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 測量姿勢分析
        if (positionAnalysis['hasData'] == true) ...[
          Text(context.tr('測量姿勢分析'), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green.withAlpha(26), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPositionSummaryItem(
                        context,
                        context.tr('坐姿'),
                        '${positionAnalysis['sitting']['systolic'].toStringAsFixed(1)}/${positionAnalysis['sitting']['diastolic'].toStringAsFixed(1)}',
                        positionAnalysis['sitting']['count'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _buildPositionSummaryItem(
                        context,
                        context.tr('臥姿'),
                        '${positionAnalysis['lying']['systolic'].toStringAsFixed(1)}/${positionAnalysis['lying']['diastolic'].toStringAsFixed(1)}',
                        positionAnalysis['lying']['count'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _buildDifferenceSummaryItem(
                        context,
                        context.tr('差異'),
                        '${positionAnalysis['difference']['systolic'].abs().toStringAsFixed(1)}/${positionAnalysis['difference']['diastolic'].abs().toStringAsFixed(1)}',
                        context.tr(positionAnalysis['difference']['systolic'] > 0 ? '坐姿較高' : '臥姿較高'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 160,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String title;
                      String value;
                      if (group.x == 0) {
                        title = rodIndex == 0 ? context.tr('坐姿收縮壓') : context.tr('臥姿收縮壓');
                      } else {
                        title = rodIndex == 0 ? context.tr('坐姿舒張壓') : context.tr('臥姿舒張壓');
                      }
                      value = rod.toY.toStringAsFixed(1);
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
                        String text = value == 0 ? context.tr('收縮壓') : context.tr('舒張壓');
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
                        if (value % 40 == 0) {
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
                  horizontalInterval: 40,
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
                        toY: positionAnalysis['sitting']['systolic'],
                        color: Colors.green,
                        width: 15,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: positionAnalysis['lying']['systolic'],
                        color: Colors.purple,
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
                        toY: positionAnalysis['sitting']['diastolic'],
                        color: Colors.green,
                        width: 15,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: positionAnalysis['lying']['diastolic'],
                        color: Colors.purple,
                        width: 15,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
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
            children: [
              _buildLegendItem(context.tr('坐姿'), Colors.green),
              const SizedBox(width: 24),
              _buildLegendItem(context.tr('臥姿'), Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // 測量部位分析
        if (armAnalysis['hasData'] == true) ...[
          Text(context.tr('測量部位分析'), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.blue.withAlpha(26), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPositionSummaryItem(
                        context,
                        context.tr('左臂'),
                        '${armAnalysis['leftArm']['systolic'].toStringAsFixed(1)}/${armAnalysis['leftArm']['diastolic'].toStringAsFixed(1)}',
                        armAnalysis['leftArm']['count'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _buildPositionSummaryItem(
                        context,
                        context.tr('右臂'),
                        '${armAnalysis['rightArm']['systolic'].toStringAsFixed(1)}/${armAnalysis['rightArm']['diastolic'].toStringAsFixed(1)}',
                        armAnalysis['rightArm']['count'].toString(),
                      ),
                    ),
                    Expanded(
                      child: _buildDifferenceSummaryItem(
                        context,
                        context.tr('差異'),
                        '${armAnalysis['difference']['systolic'].abs().toStringAsFixed(1)}/${armAnalysis['difference']['diastolic'].abs().toStringAsFixed(1)}',
                        context.tr(armAnalysis['difference']['systolic'] > 0 ? '左臂較高' : '右臂較高'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 160,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String title;
                      String value;
                      if (group.x == 0) {
                        title = rodIndex == 0 ? context.tr('左臂收縮壓') : context.tr('右臂收縮壓');
                      } else {
                        title = rodIndex == 0 ? context.tr('左臂舒張壓') : context.tr('右臂舒張壓');
                      }
                      value = rod.toY.toStringAsFixed(1);
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
                        String text = value == 0 ? context.tr('收縮壓') : context.tr('舒張壓');
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
                        if (value % 40 == 0) {
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
                  horizontalInterval: 40,
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
                        toY: armAnalysis['leftArm']['systolic'],
                        color: Colors.blue,
                        width: 15,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: armAnalysis['rightArm']['systolic'],
                        color: Colors.orange,
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
                        toY: armAnalysis['leftArm']['diastolic'],
                        color: Colors.blue,
                        width: 15,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: armAnalysis['rightArm']['diastolic'],
                        color: Colors.orange,
                        width: 15,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
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
            children: [_buildLegendItem(context.tr('左臂'), Colors.blue), const SizedBox(width: 24), _buildLegendItem(context.tr('右臂'), Colors.orange)],
          ),
        ],

        // 測量建議
        const SizedBox(height: 24),
        Text(context.tr('測量建議'), style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey.withAlpha(26), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('測量姿勢建議'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          positionAnalysis['hasData'] == true
                              ? positionAnalysis['difference']['systolic'].abs() > 5
                                  ? context.tr('您的血壓在不同姿勢下有明顯差異，建議固定使用') +
                                      context.tr(positionAnalysis['difference']['systolic'] < 0 ? '臥姿' : '坐姿') +
                                      context.tr('測量，以獲得更一致的結果。')
                                  : context.tr('您的血壓在不同姿勢下差異不大，可以選擇最舒適的姿勢測量。')
                              : context.tr('暫無足夠數據提供建議，請嘗試在不同姿勢下測量血壓。'),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('測量部位建議'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          armAnalysis['hasData'] == true
                              ? armAnalysis['difference']['systolic'].abs() > 10
                                  ? context.tr('您的左右臂血壓差異較大（超過10mmHg），建議諮詢醫生。通常應選擇血壓較高的') +
                                      context.tr(armAnalysis['difference']['systolic'] > 0 ? '左臂' : '右臂') +
                                      context.tr('進行常規測量。')
                                  : context.tr('您的左右臂血壓差異在正常範圍內，可以選擇任一側測量，但建議保持一致。')
                              : context.tr('暫無足夠數據提供建議，請嘗試在左右臂分別測量血壓。'),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPositionSummaryItem(BuildContext context, String title, String value, String count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
        Text('$count ${context.tr('次測量')}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDifferenceSummaryItem(BuildContext context, String title, String value, String note) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.red)),
        Text(note, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [Container(width: 16, height: 16, color: color), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 12))],
    );
  }
}
