/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 17:45:20
 * @ Description: 血壓預測小部件 - 顯示血壓趨勢預測結果
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BloodPressurePredictionWidget extends StatelessWidget {
  final Map<String, dynamic> predictionResult;

  const BloodPressurePredictionWidget({super.key, required this.predictionResult});

  @override
  Widget build(BuildContext context) {
    if (predictionResult['hasData'] != true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(predictionResult['message'] ?? '無法進行血壓趨勢預測，數據不足', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    // 安全地獲取數據，提供默認值
    final dailyData = predictionResult['dailyData'] as List<dynamic>? ?? [];
    final predictions = predictionResult['predictions'] as List<dynamic>? ?? [];
    final riskDays = predictionResult['riskDays'] as List<dynamic>? ?? [];
    final trend = predictionResult['trend'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 趨勢信息
        _buildTrendInfo(trend),
        const SizedBox(height: 24),

        // 預測圖表
        const Text('血壓趨勢預測', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child:
              dailyData.isNotEmpty || predictions.isNotEmpty
                  ? _buildPredictionChart(dailyData, predictions)
                  : Center(child: Text('無法生成預測圖表，數據不足', style: TextStyle(color: Colors.grey.shade600))),
        ),
        const SizedBox(height: 24),

        // 風險日提示
        if (riskDays.isNotEmpty) ...[
          const Text('潛在風險日', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...riskDays.map((day) => _buildRiskDayItem(day as Map<String, dynamic>)),
          const SizedBox(height: 24),
        ],

        // 預測數據表格
        const Text('未來7天血壓預測', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        predictions.isNotEmpty
            ? _buildPredictionTable(predictions)
            : Center(child: Text('無法生成預測數據，數據不足', style: TextStyle(color: Colors.grey.shade600))),
      ],
    );
  }

  // 構建趨勢信息
  Widget _buildTrendInfo(Map<String, dynamic> trend) {
    // 安全地獲取數據，提供默認值
    final systolicTrend = trend['systolicTrend'] as String? ?? 'stable';
    final diastolicTrend = trend['diastolicTrend'] as String? ?? 'stable';
    final message = trend['message'] as String? ?? '血壓趨勢穩定';

    IconData systolicIcon;
    Color systolicColor;

    if (systolicTrend == 'rising') {
      systolicIcon = Icons.trending_up;
      systolicColor = Colors.red;
    } else if (systolicTrend == 'falling') {
      systolicIcon = Icons.trending_down;
      systolicColor = Colors.green;
    } else {
      systolicIcon = Icons.trending_flat;
      systolicColor = Colors.blue;
    }

    IconData diastolicIcon;
    Color diastolicColor;

    if (diastolicTrend == 'rising') {
      diastolicIcon = Icons.trending_up;
      diastolicColor = Colors.red;
    } else if (diastolicTrend == 'falling') {
      diastolicIcon = Icons.trending_down;
      diastolicColor = Colors.green;
    } else {
      diastolicIcon = Icons.trending_flat;
      diastolicColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(systolicIcon, color: systolicColor),
              const SizedBox(width: 8),
              Text('收縮壓趨勢', style: TextStyle(fontWeight: FontWeight.bold, color: systolicColor)),
              const SizedBox(width: 16),
              Icon(diastolicIcon, color: diastolicColor),
              const SizedBox(width: 8),
              Text('舒張壓趨勢', style: TextStyle(fontWeight: FontWeight.bold, color: diastolicColor)),
            ],
          ),
          const SizedBox(height: 8),
          Text(message),
        ],
      ),
    );
  }

  // 構建預測圖表
  Widget _buildPredictionChart(List<dynamic> dailyData, List<dynamic> predictions) {
    // 如果沒有數據，顯示提示信息
    if (dailyData.isEmpty && predictions.isEmpty) {
      return Center(child: Text('無法生成預測圖表，數據不足', style: TextStyle(color: Colors.grey.shade600)));
    }

    // 合併歷史數據和預測數據
    final allData = [...dailyData, ...predictions];

    // 獲取所有數據的日期範圍
    final dates = allData.map((data) => data['date'] as DateTime? ?? DateTime.now()).toList();
    if (dates.isEmpty) {
      return Center(child: Text('無法生成預測圖表，日期數據不足', style: TextStyle(color: Colors.grey.shade600)));
    }

    final minDate = dates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = dates.reduce((a, b) => a.isAfter(b) ? a : b);

    // 計算日期範圍的總天數
    final totalDays = maxDate.difference(minDate).inDays + 1;

    // 創建收縮壓和舒張壓的數據點
    final List<FlSpot> systolicSpots = [];
    final List<FlSpot> diastolicSpots = [];
    final List<FlSpot> systolicPredictionSpots = [];
    final List<FlSpot> diastolicPredictionSpots = [];

    // 添加歷史數據點
    for (final data in dailyData) {
      final date = data['date'] as DateTime? ?? DateTime.now();
      final dayIndex = date.difference(minDate).inDays.toDouble();
      final systolic = (data['systolic'] as num?)?.toDouble() ?? 120.0;
      final diastolic = (data['diastolic'] as num?)?.toDouble() ?? 80.0;

      systolicSpots.add(FlSpot(dayIndex, systolic));
      diastolicSpots.add(FlSpot(dayIndex, diastolic));
    }

    // 添加預測數據點
    for (final prediction in predictions) {
      final date = prediction['date'] as DateTime? ?? DateTime.now();
      final dayIndex = date.difference(minDate).inDays.toDouble();
      final systolic = (prediction['systolic'] as num?)?.toDouble() ?? 120.0;
      final diastolic = (prediction['diastolic'] as num?)?.toDouble() ?? 80.0;

      systolicPredictionSpots.add(FlSpot(dayIndex, systolic));
      diastolicPredictionSpots.add(FlSpot(dayIndex, diastolic));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 20, verticalInterval: 1),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: totalDays > 14 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0 || value < 0 || value >= totalDays) return const Text('');
                final date = minDate.add(Duration(days: value.toInt()));
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(DateFormat('MM/dd').format(date), style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20, reservedSize: 40)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
        minX: 0,
        maxX: totalDays.toDouble() - 1,
        minY: 60,
        maxY: 180,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withAlpha(204),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                if (spot.x < 0 || spot.x >= totalDays) return null;

                final date = minDate.add(Duration(days: spot.x.toInt()));
                final dateStr = DateFormat('MM/dd').format(date);
                final isHistory = spot.x < dailyData.length;

                String title;
                Color color;

                if (spot.barIndex == 0) {
                  title = '收縮壓';
                  color = isHistory ? Colors.blue : Colors.blue.shade300;
                } else {
                  title = '舒張壓';
                  color = isHistory ? Colors.green : Colors.green.shade300;
                }

                return LineTooltipItem('$title: ${spot.y.toInt()} mmHg\n$dateStr', TextStyle(color: color, fontWeight: FontWeight.bold));
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // 歷史收縮壓
          LineChartBarData(
            spots: systolicSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          // 歷史舒張壓
          LineChartBarData(
            spots: diastolicSpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          // 預測收縮壓
          LineChartBarData(
            spots: systolicPredictionSpots,
            isCurved: true,
            color: Colors.blue.shade300,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            dashArray: [5, 5],
          ),
          // 預測舒張壓
          LineChartBarData(
            spots: diastolicPredictionSpots,
            isCurved: true,
            color: Colors.green.shade300,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            dashArray: [5, 5],
          ),
        ],
      ),
    );
  }

  // 構建風險日項目
  Widget _buildRiskDayItem(Map<String, dynamic> riskDay) {
    // 安全地獲取數據，提供默認值
    final date = riskDay['date'] as DateTime? ?? DateTime.now();
    final systolic = riskDay['systolic'] as int? ?? 0;
    final diastolic = riskDay['diastolic'] as int? ?? 0;
    final riskLevel = riskDay['riskLevel'] as String? ?? 'medium';

    Color riskColor;
    String riskText;

    if (riskLevel == 'high') {
      riskColor = Colors.red;
      riskText = '高風險';
    } else {
      riskColor = Colors.orange;
      riskText = '風險升高';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: riskColor.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: riskColor.withAlpha(77)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: riskColor, size: 20),
            const SizedBox(width: 8),
            Text(DateFormat('yyyy年MM月dd日').format(date), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text('$riskText: $systolic/$diastolic mmHg', style: TextStyle(color: riskColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // 構建預測數據表格
  Widget _buildPredictionTable(List<dynamic> predictions) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // 表頭
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('日期', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('收縮壓', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('舒張壓', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          // 表格內容
          ...predictions.map((prediction) {
            // 安全地獲取數據，提供默認值
            final date = prediction['date'] as DateTime? ?? DateTime.now();
            final systolic = prediction['systolic'] as int? ?? 0;
            final diastolic = prediction['diastolic'] as int? ?? 0;

            // 判斷是否為風險日
            bool isRiskDay = systolic >= 130 || diastolic >= 85;
            Color textColor = isRiskDay ? Colors.red : Colors.black;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(DateFormat('yyyy年MM月dd日').format(date))),
                  Expanded(flex: 1, child: Text('$systolic', style: TextStyle(fontWeight: FontWeight.bold, color: textColor))),
                  Expanded(flex: 1, child: Text('$diastolic', style: TextStyle(fontWeight: FontWeight.bold, color: textColor))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
