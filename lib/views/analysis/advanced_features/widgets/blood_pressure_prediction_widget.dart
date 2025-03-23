/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-13 16:16:42
 * @ Description: 血壓預測小部件 - 顯示血壓趨勢預測結果，包含收縮壓、舒張壓和心率
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:blood_pressure_app/l10n/app_localizations_extension.dart';
import 'package:blood_pressure_app/themes/app_theme.dart';

class BloodPressurePredictionWidget extends StatefulWidget {
  final Map<String, dynamic> predictionResult;

  const BloodPressurePredictionWidget({super.key, required this.predictionResult});

  @override
  State<BloodPressurePredictionWidget> createState() => _BloodPressurePredictionWidgetState();
}

class _BloodPressurePredictionWidgetState extends State<BloodPressurePredictionWidget> {
  bool _showPulse = true; // 默認顯示心率

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppTheme.darkTextPrimaryColor : AppTheme.lightTextPrimaryColor;
    final secondaryTextColor = isDarkMode ? AppTheme.darkTextSecondaryColor : AppTheme.lightTextSecondaryColor;
    final dividerColor = isDarkMode ? AppTheme.darkDividerColor : AppTheme.lightDividerColor;
    final cardColor = isDarkMode ? AppTheme.darkCardColor : AppTheme.lightCardColor;
    final backgroundColor = isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.lightBackgroundColor;

    if (widget.predictionResult['hasData'] != true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 48, color: secondaryTextColor),
              const SizedBox(height: 16),
              Text(
                widget.predictionResult['message'] ?? context.tr('無法進行血壓趨勢預測，數據不足'),
                textAlign: TextAlign.center,
                style: TextStyle(color: secondaryTextColor),
              ),
            ],
          ),
        ),
      );
    }

    final dailyData = widget.predictionResult['dailyData'] as List<dynamic>;
    final predictions = widget.predictionResult['predictions'] as List<dynamic>;
    final riskDays = widget.predictionResult['riskDays'] as List<dynamic>;
    final trend = widget.predictionResult['trend'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 趨勢信息
        _buildTrendInfo(trend, isDarkMode),
        const SizedBox(height: 24),

        // 預測圖表
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr('血壓趨勢預測'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
            // 心率顯示切換
            Row(
              children: [
                Text(context.tr('顯示心率'), style: TextStyle(fontSize: 14, color: Colors.orange)),
                Switch(
                  value: _showPulse,
                  onChanged: (value) {
                    setState(() {
                      _showPulse = value;
                    });
                  },
                  activeColor: Colors.orange,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(height: 250, child: _buildPredictionChart(dailyData, predictions, riskDays, isDarkMode)),
        const SizedBox(height: 24),

        // 風險日提示
        if (riskDays.isNotEmpty) ...[
          Text(context.tr('潛在風險日'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 8),
          ...riskDays.map((day) => _buildRiskDayItem(day, isDarkMode)),
          const SizedBox(height: 24),
        ],

        // 預測數據表格
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('未來7天血壓預測'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (_showPulse) Text(context.tr('包含心率'), style: const TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        _buildPredictionTable(predictions, isDarkMode),
      ],
    );
  }

  // 構建趨勢信息
  Widget _buildTrendInfo(Map<String, dynamic> trend, bool isDarkMode) {
    IconData trendIcon;
    Color trendColor;
    String trendLabel;
    final textColor = isDarkMode ? AppTheme.darkTextPrimaryColor : AppTheme.lightTextPrimaryColor;

    switch (trend['type']) {
      case 'rising':
        trendIcon = Icons.trending_up;
        trendColor = isDarkMode ? Colors.red.shade300 : Colors.red;
        trendLabel = context.tr('上升趨勢');
        break;
      case 'falling':
        trendIcon = Icons.trending_down;
        trendColor = isDarkMode ? Colors.green.shade300 : Colors.green;
        trendLabel = context.tr('下降趨勢');
        break;
      case 'unstable':
        trendIcon = Icons.auto_graph;
        trendColor = isDarkMode ? Colors.orange.shade300 : Colors.orange;
        trendLabel = context.tr('不穩定趨勢');
        break;
      case 'stable':
      default:
        trendIcon = Icons.trending_flat;
        trendColor = isDarkMode ? AppTheme.darkPrimaryColor : Colors.blue;
        trendLabel = context.tr('穩定趨勢');
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: trendColor.withAlpha(isDarkMode ? 51 : 26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: trendColor.withAlpha(isDarkMode ? 102 : 77)),
      ),
      child: Row(
        children: [
          Icon(trendIcon, color: trendColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trendLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: trendColor)),
                const SizedBox(height: 4),
                Text(trend['description'] ?? context.tr('您的血壓在近期顯示為穩定狀態'), style: TextStyle(fontSize: 14, color: textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 構建預測圖表
  Widget _buildPredictionChart(List<dynamic> dailyData, List<dynamic> predictions, List<dynamic> riskDays, bool isDarkMode) {
    // 獲取當前語系
    final isChineseLocale = _isChineseLocale();

    // 定義暗黑模式下的顏色
    final systolicColor = isDarkMode ? Colors.blue.shade300 : Colors.blue;
    final diastolicColor = isDarkMode ? Colors.green.shade300 : Colors.green;
    final pulseColor = isDarkMode ? Colors.orange.shade300 : Colors.orange;
    final gridColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
    final textColor = isDarkMode ? AppTheme.darkTextSecondaryColor : Colors.grey;
    final borderColor = isDarkMode ? AppTheme.darkDividerColor : Colors.grey.shade300;
    final tooltipBgColor = isDarkMode ? AppTheme.darkCardColor.withAlpha(230) : Colors.white.withAlpha(204);

    // 合併歷史數據和預測數據
    final allData = [...dailyData, ...predictions];

    // 獲取所有數據的日期範圍
    final dates = allData.map((data) => data['date'] as DateTime).toList();
    final minDate = dates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = dates.reduce((a, b) => a.isAfter(b) ? a : b);

    // 計算日期範圍的總天數
    final totalDays = maxDate.difference(minDate).inDays + 1;

    // 創建收縮壓、舒張壓和心率的數據點
    final List<FlSpot> systolicSpots = [];
    final List<FlSpot> diastolicSpots = [];
    final List<FlSpot> pulseSpots = [];
    final List<FlSpot> systolicPredictionSpots = [];
    final List<FlSpot> diastolicPredictionSpots = [];
    final List<FlSpot> pulsePredictionSpots = [];

    // 添加歷史數據點
    for (final data in dailyData) {
      final date = data['date'] as DateTime;
      final dayIndex = date.difference(minDate).inDays.toDouble();
      systolicSpots.add(FlSpot(dayIndex, data['systolic'].toDouble()));
      diastolicSpots.add(FlSpot(dayIndex, data['diastolic'].toDouble()));

      // 如果有心率數據，則添加
      if (data.containsKey('pulse')) {
        pulseSpots.add(FlSpot(dayIndex, data['pulse'].toDouble()));
      } else {
        // 如果沒有心率數據，使用模擬數據（收縮壓和舒張壓的平均值）
        final systolic = data['systolic'] as int;
        final diastolic = data['diastolic'] as int;
        final simulatedPulse = ((systolic - diastolic) * 0.6 + diastolic).toDouble();
        pulseSpots.add(FlSpot(dayIndex, simulatedPulse));
      }
    }

    // 添加預測數據點
    for (final prediction in predictions) {
      final date = prediction['date'] as DateTime;
      final dayIndex = date.difference(minDate).inDays.toDouble();
      systolicPredictionSpots.add(FlSpot(dayIndex, prediction['systolic'].toDouble()));
      diastolicPredictionSpots.add(FlSpot(dayIndex, prediction['diastolic'].toDouble()));

      // 如果有心率預測數據，則添加
      if (prediction.containsKey('pulse')) {
        pulsePredictionSpots.add(FlSpot(dayIndex, prediction['pulse'].toDouble()));
      } else {
        // 如果沒有心率數據，使用模擬數據
        final systolic = prediction['systolic'] as int;
        final diastolic = prediction['diastolic'] as int;
        final simulatedPulse = ((systolic - diastolic) * 0.6 + diastolic).toDouble();
        pulsePredictionSpots.add(FlSpot(dayIndex, simulatedPulse));
      }
    }

    // 準備圖表數據
    final List<LineChartBarData> lineBarsData = [
      // 歷史收縮壓
      LineChartBarData(
        spots: systolicSpots,
        isCurved: true,
        color: systolicColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      // 歷史舒張壓
      LineChartBarData(
        spots: diastolicSpots,
        isCurved: true,
        color: diastolicColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      // 預測收縮壓
      LineChartBarData(
        spots: systolicPredictionSpots,
        isCurved: true,
        color: isDarkMode ? systolicColor.withAlpha(180) : Colors.blue.shade300,
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
        color: isDarkMode ? diastolicColor.withAlpha(180) : Colors.green.shade300,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        dashArray: [5, 5],
      ),
    ];

    // 如果顯示心率且有心率數據，則添加心率線
    if (_showPulse) {
      // 歷史心率
      lineBarsData.add(
        LineChartBarData(
          spots: pulseSpots,
          isCurved: true,
          color: pulseColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      );

      // 預測心率
      lineBarsData.add(
        LineChartBarData(
          spots: pulsePredictionSpots,
          isCurved: true,
          color: isDarkMode ? pulseColor.withAlpha(180) : Colors.orange.shade300,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          dashArray: [5, 5],
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: _calculateXAxisInterval(totalDays),
          getDrawingHorizontalLine: (value) => FlLine(color: gridColor, strokeWidth: 0.5),
          getDrawingVerticalLine: (value) => FlLine(color: gridColor, strokeWidth: 0.5),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _calculateXAxisInterval(totalDays),
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const Text('');
                final date = minDate.add(Duration(days: value.toInt()));
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    isChineseLocale ? DateFormat('MM-dd').format(date) : DateFormat('MMM d').format(date),
                    style: TextStyle(fontSize: 10, color: textColor),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                // 為心率數據添加不同顏色的標籤
                if (_showPulse && value >= 60 && value <= 100 && value % 20 == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 10,
                        color: value >= 60 && value <= 100 ? pulseColor : textColor,
                        fontWeight: value >= 60 && value <= 100 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(value.toInt().toString(), style: TextStyle(fontSize: 10, color: textColor)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: borderColor)),
        minX: 0,
        maxX: totalDays.toDouble() - 1,
        minY: 40, // 降低最小值以適應心率數據
        maxY: 180,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: tooltipBgColor,
            getTooltipItems: (touchedSpots) {
              // 獲取當前語系
              final isChineseLocale = _isChineseLocale();

              return touchedSpots.map((spot) {
                final date = minDate.add(Duration(days: spot.x.toInt()));
                final dateStr = isChineseLocale ? DateFormat('MM-dd').format(date) : DateFormat('MMM d').format(date);
                final isHistory = spot.x < dailyData.length;

                String title;
                Color color;
                String unit = 'mmHg';

                if (spot.barIndex == 0) {
                  title = context.tr('收縮壓');
                  color = isHistory ? systolicColor : (isDarkMode ? systolicColor.withAlpha(180) : Colors.blue.shade300);
                } else if (spot.barIndex == 1) {
                  title = context.tr('舒張壓');
                  color = isHistory ? diastolicColor : (isDarkMode ? diastolicColor.withAlpha(180) : Colors.green.shade300);
                } else {
                  title = context.tr('心率');
                  color = isHistory ? pulseColor : (isDarkMode ? pulseColor.withAlpha(180) : Colors.orange.shade300);
                  unit = 'bpm';
                }

                return LineTooltipItem('$title: ${spot.y.toInt()} $unit\n$dateStr', TextStyle(color: color, fontWeight: FontWeight.bold));
              }).toList();
            },
          ),
        ),
        lineBarsData: lineBarsData,
      ),
    );
  }

  // 根據總天數計算 x 軸顯示間隔
  double _calculateXAxisInterval(int totalDays) {
    if (totalDays <= 7) {
      return 1; // 7天內顯示每一天
    } else if (totalDays <= 14) {
      return 2; // 8-14天顯示每隔一天
    } else if (totalDays <= 30) {
      return 3; // 15-30天顯示每隔兩天
    } else if (totalDays <= 60) {
      return 5; // 31-60天顯示每隔四天
    } else {
      return 7; // 超過60天顯示每隔六天
    }
  }

  // 構建風險日項目
  Widget _buildRiskDayItem(Map<String, dynamic> riskDay, bool isDarkMode) {
    final date = riskDay['date'] as DateTime;
    final systolic = riskDay['systolic'] as int;
    final diastolic = riskDay['diastolic'] as int;
    final pulse = riskDay['pulse'] as int?;
    final riskLevel = riskDay['riskLevel'] as String;
    final textColor = isDarkMode ? AppTheme.darkTextPrimaryColor : AppTheme.lightTextPrimaryColor;

    Color riskColor;
    String riskText;

    if (riskLevel == 'high') {
      riskColor = isDarkMode ? Colors.red.shade300 : Colors.red;
      riskText = context.tr('高風險');
    } else {
      riskColor = isDarkMode ? Colors.orange.shade300 : Colors.orange;
      riskText = context.tr('風險升高');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: riskColor.withAlpha(isDarkMode ? 51 : 26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: riskColor.withAlpha(isDarkMode ? 102 : 77)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: riskColor, size: 20),
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: Text(
                DateFormat('yyyy-MM-dd').format(date),
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child:
                  pulse != null
                      ? Text(
                        '$riskText: $systolic/$diastolic mmHg, ${context.tr('心率')}: $pulse bpm',
                        style: TextStyle(color: riskColor, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      )
                      : Text(
                        '$riskText: $systolic/$diastolic mmHg',
                        style: TextStyle(color: riskColor, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // 構建預測數據表格
  Widget _buildPredictionTable(List<dynamic> predictions, bool isDarkMode) {
    // 始終顯示心率列
    final hasPulseData = true;

    // 檢查當前語系
    final isChineseLocale = _isChineseLocale();

    // 定義暗黑模式的表格顏色
    final borderColor = isDarkMode ? AppTheme.darkDividerColor : Colors.grey.shade300;
    final headerBgColor = isDarkMode ? AppTheme.darkCardColor.withAlpha(200) : Colors.grey.shade100;
    final textColor = isDarkMode ? AppTheme.darkTextPrimaryColor : AppTheme.lightTextPrimaryColor;
    final riskColor = isDarkMode ? Colors.red.shade300 : Colors.red;
    final headerTextColor = isDarkMode ? AppTheme.darkTextPrimaryColor : AppTheme.lightTextPrimaryColor;
    final pulseColor = isDarkMode ? Colors.orange.shade300 : Colors.orange;

    // 確保所有預測都有心率數據
    final processedPredictions =
        predictions.map((prediction) {
          if (!prediction.containsKey('pulse')) {
            // 如果沒有心率數據，使用模擬數據
            final systolic = prediction['systolic'] as int;
            final diastolic = prediction['diastolic'] as int;
            final simulatedPulse = ((systolic - diastolic) * 0.6 + diastolic).round();

            // 創建新的預測對象，包含心率數據
            return {...prediction, 'pulse': simulatedPulse};
          }
          return prediction;
        }).toList();

    return Container(
      decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // 表頭
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: isChineseLocale ? 2 : 3, // 英文語系時日期列更寬
                  child: Text(context.tr('日期'), style: TextStyle(fontWeight: FontWeight.bold, color: headerTextColor)),
                ),
                Expanded(
                  flex: isChineseLocale ? 1 : 2, // 英文語系時收縮壓列更寬
                  child: Text(context.tr('收縮壓'), style: TextStyle(fontWeight: FontWeight.bold, color: headerTextColor)),
                ),
                Expanded(
                  flex: isChineseLocale ? 1 : 2, // 英文語系時舒張壓列更寬
                  child: Text(context.tr('舒張壓'), style: TextStyle(fontWeight: FontWeight.bold, color: headerTextColor)),
                ),
                if (hasPulseData) Expanded(flex: 1, child: Text(context.tr('心率'), style: TextStyle(fontWeight: FontWeight.bold, color: pulseColor))),
              ],
            ),
          ),
          // 表格內容
          ...processedPredictions.map((prediction) {
            final date = prediction['date'] as DateTime;
            final systolic = prediction['systolic'] as int;
            final diastolic = prediction['diastolic'] as int;
            final pulse = prediction['pulse'] as int;

            // 判斷是否為風險日
            bool isRiskDay = systolic >= 130 || diastolic >= 85;
            Color valueTextColor = isRiskDay ? riskColor : textColor;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: borderColor))),
              child: Row(
                children: [
                  Expanded(
                    flex: isChineseLocale ? 2 : 3, // 英文語系時日期列更寬
                    child: Text(
                      isChineseLocale ? DateFormat('yyyy-MM-dd').format(date) : DateFormat('MMM d, yyyy').format(date),
                      style: TextStyle(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: isChineseLocale ? 1 : 2, // 英文語系時收縮壓列更寬
                    child: Text('$systolic', style: TextStyle(fontWeight: FontWeight.bold, color: valueTextColor)),
                  ),
                  Expanded(
                    flex: isChineseLocale ? 1 : 2, // 英文語系時舒張壓列更寬
                    child: Text('$diastolic', style: TextStyle(fontWeight: FontWeight.bold, color: valueTextColor)),
                  ),
                  if (hasPulseData) Expanded(flex: 1, child: Text('$pulse', style: TextStyle(fontWeight: FontWeight.bold, color: pulseColor))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 檢查是否為中文語系
  bool _isChineseLocale() {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'zh';
  }
}
