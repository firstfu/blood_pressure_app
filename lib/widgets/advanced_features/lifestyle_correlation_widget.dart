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
    // 檢查是否有相關性結果
    if (widget.correlationResults.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('沒有足夠的數據進行生活方式相關性分析。請記錄更多帶有生活方式標籤的血壓數據。')));
    }

    // 獲取選定因素的數據
    final factorData = widget.correlationResults[_selectedFactor];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFactorSelector(),
        const SizedBox(height: 16),
        _buildCorrelationResults(factorData),
        const SizedBox(height: 16),
        _buildCorrelationChart(factorData),
        const SizedBox(height: 16),
        _buildHealthRecommendations(factorData),
      ],
    );
  }

  // =============================================
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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5,
            children:
                _factorNames.entries.map((entry) {
                  final isSelected = _selectedFactor == entry.key;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFactor = entry.key;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300, width: isSelected ? 2 : 1),
                        boxShadow:
                            isSelected ? [BoxShadow(color: Colors.blue.shade200.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 2))] : null,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSelected) Icon(Icons.check_circle, color: Colors.blue.shade800, size: 16),
                            if (isSelected) const SizedBox(width: 4),
                            Text(
                              entry.value,
                              style: TextStyle(
                                color: isSelected ? Colors.blue.shade800 : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
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
    print('構建相關性圖表，factorData: $factorData');

    // 檢查是否有數據
    final hasData = factorData['hasData'] == true;

    // 如果沒有數據，顯示提示訊息
    if (!hasData) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('${_factorNames[_selectedFactor]} 數據不足，無法顯示圖表', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('請記錄更多數據或選擇其他因素', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    // 檢查是否有分組數據
    final groups = factorData['groups'];
    if (groups == null || (groups is List && groups.isEmpty)) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('無法顯示 ${_factorNames[_selectedFactor]} 的圖表數據', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // 確保 groups 是一個列表
    final List<dynamic> groupsList = groups is List ? groups : [groups];

    // 構建柱狀圖
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 12.0), child: Text('血壓平均值比較', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 200,
              minY: 0,
              groupsSpace: 12,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String title = '';
                    if (rodIndex == 0) {
                      title = '收縮壓';
                    } else if (rodIndex == 1) {
                      title = '舒張壓';
                    }
                    return BarTooltipItem('$title: ${rod.toY.toStringAsFixed(1)}', const TextStyle(color: Colors.white));
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
                      if (value < groupsList.length) {
                        text = groupsList[value.toInt()]['name'] ?? '';
                      }
                      return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(text, style: const TextStyle(fontSize: 12)));
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value % 50 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.2))),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
                },
                drawVerticalLine: false,
              ),
              barGroups: List.generate(groupsList.length, (index) {
                final group = groupsList[index];
                final systolic = group['avgSystolic'] ?? 0.0;
                final diastolic = group['avgDiastolic'] ?? 0.0;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: systolic.toDouble(),
                      color: Colors.red.withOpacity(0.7),
                      width: 16,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: diastolic.toDouble(),
                      color: Colors.blue.withOpacity(0.7),
                      width: 16,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12, height: 12, color: Colors.red.withOpacity(0.7)),
            const SizedBox(width: 4),
            const Text('收縮壓', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            Container(width: 12, height: 12, color: Colors.blue.withOpacity(0.7)),
            const SizedBox(width: 4),
            const Text('舒張壓', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  // 構建相關性結果
  Widget _buildCorrelationResults(Map<String, dynamic> factorData) {
    print('構建相關性結果，factorData: $factorData');

    // 添加空值檢查
    final correlation = factorData['correlation'];
    final description = factorData['description'];
    final impact = factorData['impact'];
    final hasData = factorData['hasData'] == true;

    print('correlation: $correlation, hasData: $hasData');

    // 如果關鍵數據缺失，顯示錯誤訊息
    if (correlation == null || description == null || impact == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                const SizedBox(width: 8),
                Text('${_factorNames[_selectedFactor]} 相關性數據不完整', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('無法顯示完整的相關性分析結果，請稍後再試或選擇其他因素。'),
          ],
        ),
      );
    }

    // 即使 hasData 為 false，只要有必要的字段，也顯示相關信息
    final double correlationValue = correlation as double;
    final String descriptionText = description as String;
    final String impactText = impact as String;

    // 根據 hasData 決定顯示樣式
    Color color;
    IconData icon;
    String correlationText;

    if (!hasData) {
      // 數據不足但有基本信息時的樣式
      icon = Icons.info_outline;
      color = Colors.blue;
      correlationText = '數據不足';
    } else if (correlationValue > 0.7) {
      icon = Icons.arrow_upward;
      color = Colors.red;
      correlationText = '強正相關';
    } else if (correlationValue > 0.3) {
      icon = Icons.arrow_upward;
      color = Colors.orange;
      correlationText = '中等正相關';
    } else if (correlationValue > 0) {
      icon = Icons.arrow_upward;
      color = Colors.yellow.shade800;
      correlationText = '弱正相關';
    } else if (correlationValue > -0.3) {
      icon = Icons.arrow_downward;
      color = Colors.green.shade300;
      correlationText = '弱負相關';
    } else if (correlationValue > -0.7) {
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
              if (hasData) ...[const SizedBox(width: 8), Text('(${correlationValue.toStringAsFixed(2)})', style: TextStyle(color: color))],
            ],
          ),
          const SizedBox(height: 8),
          Text(descriptionText),
          const SizedBox(height: 8),
          Text('影響: $impactText', style: const TextStyle(fontWeight: FontWeight.bold)),
          if (!hasData && factorData['message'] != null) ...[
            const SizedBox(height: 8),
            Text(factorData['message'], style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic)),
          ],
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

  // 構建健康建議部分
  Widget _buildHealthRecommendations(Map<String, dynamic> factorData) {
    // 檢查是否有建議
    final recommendations = factorData['recommendations'];
    if (recommendations == null || (recommendations is List && recommendations.isEmpty)) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 12.0), child: Text('健康建議', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        if (recommendations is List)
          ...recommendations.map((recommendation) => _buildRecommendationItem(recommendation)).toList()
        else if (recommendations is String)
          _buildRecommendationItem(recommendations),
      ],
    );
  }
}
