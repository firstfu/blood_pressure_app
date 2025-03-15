/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 17:00:45
 * @ Description: 血壓預測服務 - 提供血壓趨勢預測功能
 */

import 'dart:math';
import '../models/blood_pressure_record.dart';
import 'package:intl/intl.dart';

class PredictionService {
  // 預測血壓趨勢
  Future<Map<String, dynamic>> predictBloodPressureTrend(List<BloodPressureRecord> records) async {
    // 如果記錄不足，無法進行預測
    if (records.length < 7) {
      return {'hasData': false, 'message': '需要至少7天的血壓記錄才能進行預測分析'};
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
          'count': 0,
        };
      }

      dailyAverages[dateKey]!['systolicSum'] += record.systolic;
      dailyAverages[dateKey]!['diastolicSum'] += record.diastolic;
      dailyAverages[dateKey]!['count'] += 1;
    }

    // 轉換為列表並計算平均值
    final List<Map<String, dynamic>> dailyData =
        dailyAverages.values.map((data) {
          return {
            'date': data['date'],
            'systolic': (data['systolicSum'] / data['count']).round(),
            'diastolic': (data['diastolicSum'] / data['count']).round(),
          };
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

    for (int i = 0; i < dailyData.length; i++) {
      xValues.add(i.toDouble());
      ySystolic.add((dailyData[i]['systolic'] as int).toDouble());
      yDiastolic.add((dailyData[i]['diastolic'] as int).toDouble());
    }

    // 計算收縮壓的線性回歸係數
    final systolicCoefficients = _calculateLinearRegression(xValues, ySystolic);
    final systolicSlope = systolicCoefficients[0];
    final systolicIntercept = systolicCoefficients[1];

    // 計算舒張壓的線性回歸係數
    final diastolicCoefficients = _calculateLinearRegression(xValues, yDiastolic);
    final diastolicSlope = diastolicCoefficients[0];
    final diastolicIntercept = diastolicCoefficients[1];

    // 生成未來7天的預測
    final List<Map<String, dynamic>> predictions = [];

    for (int i = 1; i <= 7; i++) {
      final predictDate = lastDate.add(Duration(days: i));
      final xValue = dailyData.length - 1 + i.toDouble();

      // 預測值
      final predictedSystolic = (systolicSlope * xValue + systolicIntercept).round();
      final predictedDiastolic = (diastolicSlope * xValue + diastolicIntercept).round();

      // 添加一些隨機變化，使預測更自然
      final random = Random();
      final systolicVariation = random.nextInt(5) - 2;
      final diastolicVariation = random.nextInt(3) - 1;

      predictions.add({
        'date': predictDate,
        'systolic': max(90, min(200, predictedSystolic + systolicVariation)),
        'diastolic': max(60, min(120, predictedDiastolic + diastolicVariation)),
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

  // 識別高風險日
  List<Map<String, dynamic>> _identifyRiskDays(List<Map<String, dynamic>> predictions) {
    final List<Map<String, dynamic>> riskDays = [];

    for (final prediction in predictions) {
      final systolic = prediction['systolic'] as int;
      final diastolic = prediction['diastolic'] as int;

      // 判斷風險等級
      String riskLevel = 'normal';
      if (systolic >= 140 || diastolic >= 90) {
        riskLevel = 'high';
      } else if (systolic >= 130 || diastolic >= 85) {
        riskLevel = 'elevated';
      }

      // 如果是高風險或風險升高，添加到風險日列表
      if (riskLevel != 'normal') {
        riskDays.add({'date': prediction['date'], 'systolic': systolic, 'diastolic': diastolic, 'riskLevel': riskLevel});
      }
    }

    return riskDays;
  }

  // 分析趨勢
  Map<String, dynamic> _analyzeTrend(List<Map<String, dynamic>> dailyData, List<Map<String, dynamic>> predictions) {
    // 如果數據不足，無法分析趨勢
    if (dailyData.length < 5 || predictions.isEmpty) {
      return {'systolicTrend': 'stable', 'diastolicTrend': 'stable', 'message': '數據不足，無法確定趨勢'};
    }

    // 計算過去數據的平均值
    double pastSystolicSum = 0;
    double pastDiastolicSum = 0;

    for (final data in dailyData) {
      pastSystolicSum += data['systolic'] as int;
      pastDiastolicSum += data['diastolic'] as int;
    }

    final pastSystolicAvg = pastSystolicSum / dailyData.length;
    final pastDiastolicAvg = pastDiastolicSum / dailyData.length;

    // 計算預測數據的平均值
    double futureSystolicSum = 0;
    double futureDiastolicSum = 0;

    for (final prediction in predictions) {
      futureSystolicSum += prediction['systolic'] as int;
      futureDiastolicSum += prediction['diastolic'] as int;
    }

    final futureSystolicAvg = futureSystolicSum / predictions.length;
    final futureDiastolicAvg = futureDiastolicSum / predictions.length;

    // 計算變化百分比
    final systolicChangePercent = ((futureSystolicAvg - pastSystolicAvg) / pastSystolicAvg * 100).round();
    final diastolicChangePercent = ((futureDiastolicAvg - pastDiastolicAvg) / pastDiastolicAvg * 100).round();

    // 確定趨勢
    String systolicTrend = 'stable';
    String diastolicTrend = 'stable';
    String message = '';

    if (systolicChangePercent > 5) {
      systolicTrend = 'rising';
      message = '收縮壓呈上升趨勢，預計增加約 $systolicChangePercent%';
    } else if (systolicChangePercent < -5) {
      systolicTrend = 'falling';
      message = '收縮壓呈下降趨勢，預計減少約 ${-systolicChangePercent}%';
    } else {
      message = '收縮壓趨勢穩定';
    }

    if (diastolicChangePercent > 5) {
      diastolicTrend = 'rising';
      message += '，舒張壓呈上升趨勢，預計增加約 $diastolicChangePercent%';
    } else if (diastolicChangePercent < -5) {
      diastolicTrend = 'falling';
      message += '，舒張壓呈下降趨勢，預計減少約 ${-diastolicChangePercent}%';
    } else {
      message += '，舒張壓趨勢穩定';
    }

    return {
      'systolicTrend': systolicTrend,
      'diastolicTrend': diastolicTrend,
      'systolicChangePercent': systolicChangePercent,
      'diastolicChangePercent': diastolicChangePercent,
      'message': message,
    };
  }
}
