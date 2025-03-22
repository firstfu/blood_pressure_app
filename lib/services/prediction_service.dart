/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-13 16:16:42
 * @ Description: 血壓預測服務 - 提供血壓趨勢預測功能，包含收縮壓、舒張壓和心率
 */

import 'dart:math';
import '../models/blood_pressure_record.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations_extension.dart';

class PredictionService {
  final BuildContext context;

  PredictionService(this.context);

  // 預測血壓趨勢
  Future<Map<String, dynamic>> predictBloodPressureTrend(List<BloodPressureRecord> records) async {
    // 如果記錄不足，無法進行預測
    if (records.length < 7) {
      return {'hasData': false, 'message': context.tr('需要至少7天的血壓記錄才能進行預測分析')};
    }

    // 按日期排序
    records.sort((a, b) => b.measureTime.compareTo(a.measureTime));

    // 獲取最近30天的記錄（如果有的話）
    final recentRecords = records.length > 30 ? records.sublist(0, 30) : records;

    // 計算每日平均血壓
    final Map<String, Map<String, dynamic>> dailyAverages = {};

    for (final record in recentRecords) {
      final dateKey = DateFormat('yyyy-MM-dd').format(record.measureTime);

      if (!dailyAverages.containsKey(dateKey)) {
        dailyAverages[dateKey] = {
          'date': DateTime(record.measureTime.year, record.measureTime.month, record.measureTime.day),
          'systolicSum': 0,
          'diastolicSum': 0,
          'pulseSum': 0,
          'count': 0,
          'hasPulse': false,
        };
      }

      dailyAverages[dateKey]!['systolicSum'] += record.systolic;
      dailyAverages[dateKey]!['diastolicSum'] += record.diastolic;

      // 檢查是否有心率數據
      if (record.pulse > 0) {
        dailyAverages[dateKey]!['pulseSum'] += record.pulse;
        dailyAverages[dateKey]!['hasPulse'] = true;
      } else {
        // 如果沒有心率數據，使用模擬數據（收縮壓和舒張壓的差值的60%加上舒張壓）
        final simulatedPulse = ((record.systolic - record.diastolic) * 0.6 + record.diastolic).round();
        dailyAverages[dateKey]!['pulseSum'] += simulatedPulse;
      }

      dailyAverages[dateKey]!['count'] += 1;
    }

    // 轉換為列表並計算平均值
    final List<Map<String, dynamic>> dailyData =
        dailyAverages.values.map((data) {
          final systolicAvg = (data['systolicSum'] / data['count']).round();
          final diastolicAvg = (data['diastolicSum'] / data['count']).round();
          final pulseAvg = (data['pulseSum'] / data['count']).round();

          return {'date': data['date'], 'systolic': systolicAvg, 'diastolic': diastolicAvg, 'pulse': pulseAvg};
        }).toList();

    // 按日期排序（從舊到新）
    dailyData.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // 使用線性回歸進行預測
    final predictions = _linearRegressionPredict(dailyData);

    // 識別高風險日
    final riskDays = _identifyRiskDays(predictions);

    return {
      'hasData': true,
      'dailyData': dailyData,
      'predictions': predictions,
      'riskDays': riskDays,
      'trend': _analyzeTrend(dailyData, predictions),
    };
  }

  // 使用線性回歸進行預測
  List<Map<String, dynamic>> _linearRegressionPredict(List<Map<String, dynamic>> dailyData) {
    // 如果數據不足，返回空列表
    if (dailyData.length < 5) {
      return [];
    }

    // 獲取最後一天的日期
    final lastDate = dailyData.last['date'] as DateTime;

    // 準備用於回歸的數據
    final List<double> xValues = [];
    final List<double> ySystolic = [];
    final List<double> yDiastolic = [];
    final List<double> yPulse = [];

    for (int i = 0; i < dailyData.length; i++) {
      xValues.add(i.toDouble());
      ySystolic.add((dailyData[i]['systolic'] as int).toDouble());
      yDiastolic.add((dailyData[i]['diastolic'] as int).toDouble());
      yPulse.add((dailyData[i]['pulse'] as int).toDouble());
    }

    // 計算收縮壓的線性回歸係數
    final systolicCoefficients = _calculateLinearRegression(xValues, ySystolic);
    final systolicSlope = systolicCoefficients[0];
    final systolicIntercept = systolicCoefficients[1];

    // 計算舒張壓的線性回歸係數
    final diastolicCoefficients = _calculateLinearRegression(xValues, yDiastolic);
    final diastolicSlope = diastolicCoefficients[0];
    final diastolicIntercept = diastolicCoefficients[1];

    // 計算心率的線性回歸係數
    final pulseCoefficients = _calculateLinearRegression(xValues, yPulse);
    final pulseSlope = pulseCoefficients[0];
    final pulseIntercept = pulseCoefficients[1];

    // 生成未來7天的預測
    final List<Map<String, dynamic>> predictions = [];

    for (int i = 1; i <= 7; i++) {
      final predictDate = lastDate.add(Duration(days: i));
      final xValue = dailyData.length - 1 + i.toDouble();

      // 預測值
      final predictedSystolic = (systolicSlope * xValue + systolicIntercept).round();
      final predictedDiastolic = (diastolicSlope * xValue + diastolicIntercept).round();
      final predictedPulse = (pulseSlope * xValue + pulseIntercept).round();

      // 添加一些隨機變化，使預測更自然
      final random = Random();
      final systolicVariation = random.nextInt(5) - 2;
      final diastolicVariation = random.nextInt(3) - 1;
      final pulseVariation = random.nextInt(5) - 2;

      predictions.add({
        'date': predictDate,
        'systolic': max(90, min(200, predictedSystolic + systolicVariation)),
        'diastolic': max(60, min(120, predictedDiastolic + diastolicVariation)),
        'pulse': max(50, min(120, predictedPulse + pulseVariation)),
      });
    }

    return predictions;
  }

  // 計算線性回歸係數 [slope, intercept]
  List<double> _calculateLinearRegression(List<double> x, List<double> y) {
    final n = x.length;
    double sumX = 0;
    double sumY = 0;

    for (int i = 0; i < n; i++) {
      sumX += x[i];
      sumY += y[i];
    }

    final xMean = sumX / n;
    final yMean = sumY / n;

    double numerator = 0;
    double denominator = 0;

    for (int i = 0; i < n; i++) {
      numerator += (x[i] - xMean) * (y[i] - yMean);
      denominator += (x[i] - xMean) * (x[i] - xMean);
    }

    // 避免除以零
    final double slope = denominator != 0 ? numerator / denominator : 0;
    final double intercept = yMean - slope * xMean;

    return <double>[slope, intercept];
  }

  // 分析趨勢
  Map<String, dynamic> _analyzeTrend(List<Map<String, dynamic>> dailyData, List<Map<String, dynamic>> predictions) {
    // 獲取最近7天的數據（如果有的話）
    final recentData = dailyData.length >= 7 ? dailyData.sublist(dailyData.length - 7) : dailyData;

    // 計算收縮壓和舒張壓的平均變化
    double systolicChange = 0;
    double diastolicChange = 0;

    if (recentData.length >= 3) {
      // 計算最近幾天的平均值和第一天的值的差異
      final recentSystolicAvg = recentData.sublist(recentData.length - 3).map((data) => data['systolic'] as int).reduce((a, b) => a + b) / 3;
      final recentDiastolicAvg = recentData.sublist(recentData.length - 3).map((data) => data['diastolic'] as int).reduce((a, b) => a + b) / 3;

      final firstSystolic = recentData.first['systolic'] as int;
      final firstDiastolic = recentData.first['diastolic'] as int;

      systolicChange = recentSystolicAvg - firstSystolic;
      diastolicChange = recentDiastolicAvg - firstDiastolic;
    }

    // 確定趨勢類型
    String trendType;
    String description;

    if (systolicChange.abs() < 3 && diastolicChange.abs() < 3) {
      trendType = 'stable';
      description = context.tr('您的血壓在近期顯示為穩定狀態，變化範圍在正常波動範圍內。');
    } else if (systolicChange > 5 || diastolicChange > 5) {
      trendType = 'rising';
      description = context.tr('您的血壓呈上升趨勢，可能需要更密切關注並考慮咨詢醫生。');
    } else if (systolicChange < -5 || diastolicChange < -5) {
      trendType = 'falling';
      description = context.tr('您的血壓呈下降趨勢，如果這是治療的效果，這是個好消息。');
    } else {
      trendType = 'unstable';
      description = context.tr('您的血壓顯示出一些波動，建議定期監測並保持良好的生活習慣。');
    }

    return {'type': trendType, 'description': description};
  }

  // 識別高風險日
  List<Map<String, dynamic>> _identifyRiskDays(List<Map<String, dynamic>> predictions) {
    final riskDays = <Map<String, dynamic>>[];

    for (final prediction in predictions) {
      final systolic = prediction['systolic'] as int;
      final diastolic = prediction['diastolic'] as int;

      // 如果收縮壓 >= 140 或舒張壓 >= 90，認為是高風險日
      if (systolic >= 140 || diastolic >= 90) {
        riskDays.add({'date': (prediction['date'] as DateTime).toIso8601String(), 'systolic': systolic, 'diastolic': diastolic});
      }
    }

    return riskDays;
  }
}
