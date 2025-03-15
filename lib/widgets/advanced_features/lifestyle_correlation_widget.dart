/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 19:15:30
 * @ Description: 生活方式相關性分析小部件 - 顯示生活方式與血壓的相關性分析結果
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LifestyleCorrelationWidget extends StatefulWidget {
  final Map<String, dynamic> correlationResults;

  const LifestyleCorrelationWidget({super.key, required this.correlationResults});

  @override
  State<LifestyleCorrelationWidget> createState() => _LifestyleCorrelationWidgetState();
}

class _LifestyleCorrelationWidgetState extends State<LifestyleCorrelationWidget> {
  String _selectedFactor = 'exercise';
  final Map<String, String> _factorNames = {'exercise': '運動', 'sleep': '睡眠', 'salt': '鹽分攝取', 'stress': '壓力', 'water': '水分攝取', 'alcohol': '酒精'};

  @override
  Widget build(BuildContext context) {
    if (widget.correlationResults['hasData'] != true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                widget.correlationResults['message'] ?? '無法進行生活方式相關性分析，數據不足',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final correlations = widget.correlationResults['correlations'] as Map<String, dynamic>;
    final recommendations = widget.correlationResults['recommendations'] as List<dynamic>;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 因素選擇器
            _buildFactorSelector(),
            const SizedBox(height: 24),

            // 相關性圖表
            const Text('相關性分析', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(height: 250, child: _buildCorrelationChart(correlations[_selectedFactor])),
            const SizedBox(height: 24),

            // 相關性結果
            _buildCorrelationResults(correlations[_selectedFactor]),
            const SizedBox(height: 24),

            // 改善建議
            const Text('改善建議', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...recommendations.map((recommendation) => _buildRecommendationItem(recommendation)),
          ],
        ),
      ),
    );
  }

  // 構建因素選擇器
  Widget _buildFactorSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('選擇生活方式因素', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _factorNames.entries.map((entry) {
                  final isSelected = _selectedFactor == entry.key;
                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFactor = entry.key;
                        });
                      }
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue.shade800 : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // 構建相關性圖表
  Widget _buildCorrelationChart(Map<String, dynamic> factorData) {
    if (_selectedFactor == 'alcohol') {
      return _buildAlcoholComparisonChart(factorData);
    } else {
      return _buildGroupComparisonChart(factorData);
    }
  }

  // 構建組比較圖表
  Widget _buildGroupComparisonChart(Map<String, dynamic> factorData) {
    final groups = factorData['groups'] as List<dynamic>;
    final factorName = _factorNames[_selectedFactor] ?? _selectedFactor;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 180,
        minY: 60,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final groupData = groups[groupIndex];
              final groupName = groupData['name'] as String;
              final systolic = groupData['avgSystolic'] as double;
              final diastolic = groupData['avgDiastolic'] as double;

              return BarTooltipItem(
                '$groupName\n收縮壓: ${systolic.toStringAsFixed(1)} mmHg\n舒張壓: ${diastolic.toStringAsFixed(1)} mmHg',
                const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= groups.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(groups[value.toInt()]['name'] as String, style: const TextStyle(fontSize: 12)),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20, reservedSize: 40)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
          },
        ),
        barGroups: List.generate(groups.length, (index) {
          final groupData = groups[index];
          final systolic = groupData['avgSystolic'] as double;
          final diastolic = groupData['avgDiastolic'] as double;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: systolic,
                color: Colors.blue,
                width: 16,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
              BarChartRodData(
                toY: diastolic,
                color: Colors.green,
                width: 16,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 構建酒精比較圖表
  Widget _buildAlcoholComparisonChart(Map<String, dynamic> factorData) {
    final nonDrinkers = factorData['nonDrinkers'] as Map<String, dynamic>;
    final lightDrinkers = factorData['lightDrinkers'] as Map<String, dynamic>;
    final moderateDrinkers = factorData['moderateDrinkers'] as Map<String, dynamic>;
    final heavyDrinkers = factorData['heavyDrinkers'] as Map<String, dynamic>;

    final groups = [
      {'name': '不飲酒', 'systolic': nonDrinkers['avgSystolic'], 'diastolic': nonDrinkers['avgDiastolic']},
      {'name': '輕度飲酒', 'systolic': lightDrinkers['avgSystolic'], 'diastolic': lightDrinkers['avgDiastolic']},
      {'name': '中度飲酒', 'systolic': moderateDrinkers['avgSystolic'], 'diastolic': moderateDrinkers['avgDiastolic']},
      {'name': '重度飲酒', 'systolic': heavyDrinkers['avgSystolic'], 'diastolic': heavyDrinkers['avgDiastolic']},
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 180,
        minY: 60,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final groupData = groups[groupIndex];
              final groupName = groupData['name'] as String;
              final systolic = groupData['systolic'] as double;
              final diastolic = groupData['diastolic'] as double;

              return BarTooltipItem(
                '$groupName\n收縮壓: ${systolic.toStringAsFixed(1)} mmHg\n舒張壓: ${diastolic.toStringAsFixed(1)} mmHg',
                const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= groups.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(groups[value.toInt()]['name'] as String, style: const TextStyle(fontSize: 12)),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20, reservedSize: 40)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
          },
        ),
        barGroups: List.generate(groups.length, (index) {
          final groupData = groups[index];
          final systolic = groupData['systolic'] as double;
          final diastolic = groupData['diastolic'] as double;

          // 顏色根據飲酒程度變化
          Color barColor;
          if (index == 0) {
            barColor = Colors.green;
          } else if (index == 1) {
            barColor = Colors.yellow.shade700;
          } else if (index == 2) {
            barColor = Colors.orange;
          } else {
            barColor = Colors.red;
          }

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: systolic,
                color: barColor.withOpacity(0.8),
                width: 16,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
              BarChartRodData(
                toY: diastolic,
                color: barColor.withOpacity(0.5),
                width: 16,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 構建相關性結果
  Widget _buildCorrelationResults(Map<String, dynamic> factorData) {
    final correlation = factorData['correlation'] as double;
    final description = factorData['description'] as String;
    final impact = factorData['impact'] as String;

    IconData icon;
    Color color;
    String correlationText;

    if (correlation > 0.7) {
      icon = Icons.arrow_upward;
      color = Colors.red;
      correlationText = '強正相關';
    } else if (correlation > 0.3) {
      icon = Icons.arrow_upward;
      color = Colors.orange;
      correlationText = '中等正相關';
    } else if (correlation > 0) {
      icon = Icons.arrow_upward;
      color = Colors.yellow.shade800;
      correlationText = '弱正相關';
    } else if (correlation > -0.3) {
      icon = Icons.arrow_downward;
      color = Colors.green.shade300;
      correlationText = '弱負相關';
    } else if (correlation > -0.7) {
      icon = Icons.arrow_downward;
      color = Colors.green.shade600;
      correlationText = '中等負相關';
    } else {
      icon = Icons.arrow_downward;
      color = Colors.green.shade900;
      correlationText = '強負相關';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text('${_factorNames[_selectedFactor]} 與血壓: $correlationText', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              const SizedBox(width: 8),
              Text('(${correlation.toStringAsFixed(2)})', style: TextStyle(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 8),
          Text('影響: $impact', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 構建建議項目
  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(recommendation)),
          ],
        ),
      ),
    );
  }
}
