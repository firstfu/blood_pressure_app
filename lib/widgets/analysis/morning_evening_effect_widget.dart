/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 15:45:12
 * @ Description: 血壓記錄 App 晨峰血壓分析組件 - 顯示晨間與晚間血壓差異
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blood_pressure_app/l10n/app_localizations_extension.dart';

class MorningEveningEffectWidget extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const MorningEveningEffectWidget({super.key, required this.analysis});

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
              Text(context.tr('請確保您有記錄早晨和晚間的血壓數據'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    final morningData = analysis['morningData'] ?? {'systolic': 0.0, 'diastolic': 0.0, 'count': 0};
    final eveningData = analysis['eveningData'] ?? {'systolic': 0.0, 'diastolic': 0.0, 'count': 0};
    final difference = analysis['difference'] ?? {'systolic': 0.0, 'diastolic': 0.0};
    final surgeDegree = analysis['surgeDegree'] ?? 'none';
    final surgeIndex = analysis['surgeIndex'] != null ? analysis['surgeIndex'].toStringAsFixed(1) : '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 晨峰血壓指數
        Text(context.tr('晨峰血壓指數'), style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.orange.withAlpha(26), borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTimeSummaryItem(
                      context,
                      context.tr('早晨'),
                      '${(morningData['systolic'] ?? 0.0).toStringAsFixed(1)}/${(morningData['diastolic'] ?? 0.0).toStringAsFixed(1)}',
                      (morningData['count'] ?? 0).toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildTimeSummaryItem(
                      context,
                      context.tr('晚間'),
                      '${(eveningData['systolic'] ?? 0.0).toStringAsFixed(1)}/${(eveningData['diastolic'] ?? 0.0).toStringAsFixed(1)}',
                      (eveningData['count'] ?? 0).toString(),
                    ),
                  ),
                  Expanded(
                    child: _buildDifferenceSummaryItem(
                      context,
                      context.tr('晨峰幅度'),
                      '${(difference['systolic'] ?? 0.0).abs().toStringAsFixed(1)}/${(difference['diastolic'] ?? 0.0).abs().toStringAsFixed(1)}',
                      (difference['systolic'] ?? 0.0) > 0 ? context.tr('有晨峰現象') : context.tr('無晨峰現象'),
                      (difference['systolic'] ?? 0.0) > 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(context.tr('晨峰指數'), style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        surgeIndex,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _getSurgeColor(surgeIndex is String ? double.parse(surgeIndex) : surgeIndex),
                        ),
                      ),
                      Text(
                        _getSurgeDegreeText(context, surgeDegree),
                        style: TextStyle(fontSize: 14, color: _getSurgeColor(surgeIndex is String ? double.parse(surgeIndex) : surgeIndex)),
                      ),
                    ],
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
                      title = rodIndex == 0 ? context.tr('早晨收縮壓') : context.tr('晚間收縮壓');
                    } else {
                      title = rodIndex == 0 ? context.tr('早晨舒張壓') : context.tr('晚間舒張壓');
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
                      toY: morningData['systolic'] ?? 0.0,
                      color: Colors.orange,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: eveningData['systolic'] ?? 0.0,
                      color: Colors.indigo,
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
                      toY: morningData['diastolic'] ?? 0.0,
                      color: Colors.orange,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: eveningData['diastolic'] ?? 0.0,
                      color: Colors.indigo,
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
            _buildLegendItem(context, context.tr('早晨'), Colors.orange),
            const SizedBox(width: 24),
            _buildLegendItem(context, context.tr('晚間'), Colors.indigo),
          ],
        ),

        // 晨峰血壓說明
        const SizedBox(height: 24),
        Text(context.tr('晨峰血壓說明'), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('什麼是晨峰血壓'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(context.tr('晨峰血壓是指早晨起床後的血壓相比前一天晚上的血壓明顯升高的現象。研究顯示，過大的晨峰血壓與心血管疾病風險增加有關。'), style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.assessment_outlined, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('晨峰指數計算方法'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(context.tr('晨峰指數 = (早晨收縮壓 - 晚間收縮壓) / 晚間收縮壓 × 100%'), style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(context.tr('• 小於0：無晨峰現象'), style: const TextStyle(fontSize: 14)),
                        Text(context.tr('• 0-10：輕度晨峰'), style: const TextStyle(fontSize: 14)),
                        Text(context.tr('• 10-20：中度晨峰'), style: const TextStyle(fontSize: 14)),
                        Text(context.tr('• 大於20：重度晨峰'), style: const TextStyle(fontSize: 14)),
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
                        Text(context.tr('健康建議'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          surgeDegree == 'none'
                              ? context.tr('您沒有晨峰血壓現象，請繼續保持良好的生活習慣。')
                              : surgeDegree == 'mild'
                              ? context.tr('您有輕度晨峰血壓現象，建議規律服藥並監測血壓變化。')
                              : surgeDegree == 'moderate'
                              ? context.tr('您有中度晨峰血壓現象，建議諮詢醫生調整藥物或服藥時間。')
                              : context.tr('您有重度晨峰血壓現象，請盡快諮詢醫生，可能需要24小時血壓監測和藥物調整。'),
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

  Widget _buildTimeSummaryItem(BuildContext context, String title, String value, String count) {
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

  Widget _buildDifferenceSummaryItem(BuildContext context, String title, String value, String note, Color noteColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.red)),
        Text(note, style: TextStyle(fontSize: 12, color: noteColor)),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [Container(width: 16, height: 16, color: color), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 12))],
    );
  }

  Color _getSurgeColor(double surgeIndex) {
    if (surgeIndex <= 0) return Colors.green;
    if (surgeIndex <= 10) return Colors.yellow.shade800;
    if (surgeIndex <= 20) return Colors.orange;
    return Colors.red;
  }

  String _getSurgeDegreeText(BuildContext context, String degree) {
    switch (degree) {
      case 'none':
        return context.tr('無晨峰');
      case 'mild':
        return context.tr('輕度晨峰');
      case 'moderate':
        return context.tr('中度晨峰');
      case 'severe':
        return context.tr('重度晨峰');
      default:
        return context.tr('未知');
    }
  }
}
