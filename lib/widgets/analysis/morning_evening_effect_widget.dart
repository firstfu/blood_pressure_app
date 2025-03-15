/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 12:35:42
 * @ Description: 血壓記錄 App 晨峰血壓分析組件 - 顯示早晨和晚上的血壓差異
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
              Text(analysis['message'] ?? '沒有足夠的數據進行分析', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              const Text('請確保您有記錄早晨和晚上的血壓數據', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    final morningAvg = analysis['morningAvg'];
    final eveningAvg = analysis['eveningAvg'];
    final difference = analysis['difference'];
    final morningEveningRatio = analysis['morningEveningRatio'];
    final hasMorningHypertension = analysis['hasMorningHypertension'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 晨峰血壓摘要
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  const Text('晨峰血壓指數', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: hasMorningHypertension ? Colors.red : Colors.green, borderRadius: BorderRadius.circular(12)),
                    child: Text(hasMorningHypertension ? '晨峰高血壓風險' : '正常', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildRatioItem('收縮壓比值', morningEveningRatio['systolic'].toStringAsFixed(2), morningEveningRatio['systolic'] > 1.15),
                  ),
                  Expanded(
                    child: _buildRatioItem('舒張壓比值', morningEveningRatio['diastolic'].toStringAsFixed(2), morningEveningRatio['diastolic'] > 1.15),
                  ),
                ],
              ),
              if (hasMorningHypertension) ...[
                const SizedBox(height: 8),
                const Text('注意：晨峰血壓指數大於1.15，表示存在晨峰高血壓風險，建議諮詢醫生。', style: TextStyle(color: Colors.red, fontSize: 12)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 早晚血壓對比圖
        const Text('早晚血壓對比', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      title = rodIndex == 0 ? '早晨收縮壓' : '晚上收縮壓';
                      value = rod.toY.toStringAsFixed(1);
                    } else if (groupIndex == 1) {
                      title = rodIndex == 0 ? '早晨舒張壓' : '晚上舒張壓';
                      value = rod.toY.toStringAsFixed(1);
                    } else {
                      title = rodIndex == 0 ? '早晨心率' : '晚上心率';
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
                  return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                // 收縮壓
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: morningAvg['systolic'],
                      color: Colors.orange,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: eveningAvg['systolic'],
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
                      toY: morningAvg['diastolic'],
                      color: Colors.orange,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: eveningAvg['diastolic'],
                      color: Colors.indigo,
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
                      toY: morningAvg['pulse'],
                      color: Colors.orange,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: eveningAvg['pulse'],
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
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildLegendItem('早晨 (4-10點)', Colors.orange), const SizedBox(width: 24), _buildLegendItem('晚上 (18-24點)', Colors.indigo)],
        ),
        const SizedBox(height: 24),

        // 早晚血壓趨勢圖
        const Text('早晚血壓趨勢', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(height: 200, child: _buildTrendChart(analysis)),
        const SizedBox(height: 24),

        // 詳細數據
        const Text('詳細數據', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
          columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3), 2: FlexColumnWidth(3), 3: FlexColumnWidth(3)},
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Colors.grey),
              children: [
                Padding(padding: EdgeInsets.all(8.0), child: Text('指標', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                Padding(padding: EdgeInsets.all(8.0), child: Text('早晨', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                Padding(padding: EdgeInsets.all(8.0), child: Text('晚上', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                Padding(padding: EdgeInsets.all(8.0), child: Text('差異', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              ],
            ),
            TableRow(
              children: [
                const Padding(padding: EdgeInsets.all(8.0), child: Text('收縮壓')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${morningAvg['systolic'].toStringAsFixed(1)} mmHg')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${eveningAvg['systolic'].toStringAsFixed(1)} mmHg')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${difference['systolic'].abs().toStringAsFixed(1)} mmHg',
                    style: TextStyle(
                      color: difference['systolic'].abs() > 10 ? Colors.red : Colors.black,
                      fontWeight: difference['systolic'].abs() > 10 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(padding: EdgeInsets.all(8.0), child: Text('舒張壓')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${morningAvg['diastolic'].toStringAsFixed(1)} mmHg')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${eveningAvg['diastolic'].toStringAsFixed(1)} mmHg')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${difference['diastolic'].abs().toStringAsFixed(1)} mmHg',
                    style: TextStyle(
                      color: difference['diastolic'].abs() > 10 ? Colors.red : Colors.black,
                      fontWeight: difference['diastolic'].abs() > 10 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(padding: EdgeInsets.all(8.0), child: Text('心率')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${morningAvg['pulse'].toStringAsFixed(1)} bpm')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${eveningAvg['pulse'].toStringAsFixed(1)} bpm')),
                Padding(padding: const EdgeInsets.all(8.0), child: Text('${difference['pulse'].abs().toStringAsFixed(1)} bpm')),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 健康建議
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.health_and_safety, color: Colors.green),
                  SizedBox(width: 8),
                  Text('健康建議', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              if (hasMorningHypertension) ...[
                const Text('您的晨峰血壓指數大於1.15，存在晨峰高血壓風險。晨峰高血壓與心血管事件風險增加相關，建議：', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                _buildAdviceItem('諮詢醫生，可能需要調整藥物服用時間或劑量'),
                _buildAdviceItem('考慮在睡前服用部分降壓藥，以控制早晨血壓升高'),
                _buildAdviceItem('減少鹽分攝入，特別是晚餐'),
                _buildAdviceItem('保持規律作息，避免熬夜'),
                _buildAdviceItem('增加早晨血壓監測頻率'),
              ] else ...[
                const Text('您的早晚血壓變化在正常範圍內，建議：', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                _buildAdviceItem('繼續保持良好的生活習慣'),
                _buildAdviceItem('定期監測血壓，包括早晨和晚上'),
                _buildAdviceItem('保持規律作息，避免熬夜'),
                _buildAdviceItem('適量運動，但避免早晨劇烈運動'),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatioItem(String title, String value, bool isRisky) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isRisky ? Colors.red : Colors.green)),
        Text(isRisky ? '偏高' : '正常', style: TextStyle(fontSize: 12, color: isRisky ? Colors.red : Colors.green)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [Container(width: 16, height: 16, color: color), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 12))],
    );
  }

  Widget _buildAdviceItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildTrendChart(Map<String, dynamic> analysis) {
    final morningRecords = analysis['morningRecords'] as List<dynamic>;
    final eveningRecords = analysis['eveningRecords'] as List<dynamic>;

    // 按日期排序
    morningRecords.sort((a, b) => a.measureTime.compareTo(b.measureTime));
    eveningRecords.sort((a, b) => a.measureTime.compareTo(b.measureTime));

    // 準備數據點
    final morningSystolicSpots =
        morningRecords.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
        }).toList();

    final eveningSystolicSpots =
        eveningRecords.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
        }).toList();

    final morningDiastolicSpots =
        morningRecords.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
        }).toList();

    final eveningDiastolicSpots =
        eveningRecords.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
        }).toList();

    // 找出最大和最小日期，用於X軸標籤
    final allRecords = [...morningRecords, ...eveningRecords];
    allRecords.sort((a, b) => a.measureTime.compareTo(b.measureTime));
    final minDate = allRecords.first.measureTime;
    final maxDate = allRecords.last.measureTime;

    // 計算日期範圍
    final daysDifference = maxDate.difference(minDate).inDays;
    final dateFormat = daysDifference > 7 ? DateFormat('MM/dd') : DateFormat('MM/dd HH:mm');

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String title;
                if (spot.barIndex == 0) {
                  title = '早晨收縮壓';
                } else if (spot.barIndex == 1) {
                  title = '晚上收縮壓';
                } else if (spot.barIndex == 2) {
                  title = '早晨舒張壓';
                } else {
                  title = '晚上舒張壓';
                }
                return LineTooltipItem('$title: ${spot.y.toInt()}', const TextStyle(color: Colors.white));
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                // 只顯示部分日期標籤，避免擁擠
                if (value.toInt() % 2 == 0 && value.toInt() < morningRecords.length) {
                  final index = value.toInt();
                  if (index < morningRecords.length) {
                    final date = morningRecords[index].measureTime;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(dateFormat.format(date), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    );
                  }
                }
                return const Text('');
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
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.2))),
        minX: 0,
        maxX: (morningRecords.length > eveningRecords.length ? morningRecords.length : eveningRecords.length) - 1.0,
        minY: 40,
        maxY: 200,
        lineBarsData: [
          // 早晨收縮壓
          LineChartBarData(
            spots: morningSystolicSpots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          // 晚上收縮壓
          LineChartBarData(
            spots: eveningSystolicSpots,
            isCurved: true,
            color: Colors.indigo,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          // 早晨舒張壓
          LineChartBarData(
            spots: morningDiastolicSpots,
            isCurved: true,
            color: Colors.orange.withOpacity(0.5),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            dashArray: [5, 5],
            belowBarData: BarAreaData(show: false),
          ),
          // 晚上舒張壓
          LineChartBarData(
            spots: eveningDiastolicSpots,
            isCurved: true,
            color: Colors.indigo.withOpacity(0.5),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            dashArray: [5, 5],
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
