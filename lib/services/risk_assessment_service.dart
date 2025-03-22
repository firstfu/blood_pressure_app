/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 17:15:30
 * @ Description: 健康風險評估服務 - 提供基於血壓數據的健康風險評估功能
 */

import '../models/blood_pressure_record.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations_extension.dart';

class RiskAssessmentService {
  final BuildContext context;

  RiskAssessmentService(this.context);

  // 評估健康風險
  Future<Map<String, dynamic>> assessHealthRisk(List<BloodPressureRecord> records, {Map<String, dynamic>? userInfo}) async {
    // 如果記錄不足，無法進行評估
    if (records.isEmpty) {
      return {'hasData': false, 'message': context.tr('需要血壓記錄才能進行健康風險評估')};
    }

    // 計算平均血壓
    double systolicSum = 0;
    double diastolicSum = 0;

    for (final record in records) {
      systolicSum += record.systolic;
      diastolicSum += record.diastolic;
    }

    final avgSystolic = (systolicSum / records.length).round();
    final avgDiastolic = (diastolicSum / records.length).round();

    // 計算總體風險評分 (使用重新設計的模型)
    final overallScore = _calculateOverallRiskScore(avgSystolic, avgDiastolic);

    // 生成風險類別
    final riskCategories = _generateRiskCategories(avgSystolic, avgDiastolic);

    // 生成健康生活方式建議
    final healthSuggestions = _generateHealthSuggestions(avgSystolic, avgDiastolic);

    return {'hasData': true, 'overallScore': overallScore, 'riskCategories': riskCategories, 'healthSuggestions': healthSuggestions};
  }

  // 計算總體風險評分
  double _calculateOverallRiskScore(int systolic, int diastolic) {
    double score = 0.0;

    // 基於收縮壓的評分
    if (systolic < 120) {
      score += 1.0;
    } else if (systolic < 130) {
      score += 2.0;
    } else if (systolic < 140) {
      score += 3.0;
    } else if (systolic < 160) {
      score += 4.0;
    } else {
      score += 5.0;
    }

    // 基於舒張壓的評分
    if (diastolic < 80) {
      score += 1.0;
    } else if (diastolic < 85) {
      score += 2.0;
    } else if (diastolic < 90) {
      score += 3.0;
    } else if (diastolic < 100) {
      score += 4.0;
    } else {
      score += 5.0;
    }

    // 返回平均分數
    return score / 2;
  }

  // 生成風險類別
  List<Map<String, dynamic>> _generateRiskCategories(int systolic, int diastolic) {
    final categories = <Map<String, dynamic>>[];

    // 收縮壓風險
    double systolicScore = 0.0;
    String systolicDescription = '';

    if (systolic < 120) {
      systolicScore = 1.0;
      systolicDescription = context.tr('您的收縮壓處於理想範圍內。');
    } else if (systolic < 130) {
      systolicScore = 2.0;
      systolicDescription = context.tr('您的收縮壓處於正常範圍，但接近高血壓前期。');
    } else if (systolic < 140) {
      systolicScore = 3.0;
      systolicDescription = context.tr('您的收縮壓處於高血壓前期，有發展為高血壓的風險。');
    } else if (systolic < 160) {
      systolicScore = 4.0;
      systolicDescription = context.tr('您的收縮壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。');
    } else {
      systolicScore = 5.0;
      systolicDescription = context.tr('您的收縮壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。');
    }

    categories.add({'title': context.tr('收縮壓風險'), 'score': systolicScore, 'description': systolicDescription});

    // 舒張壓風險
    double diastolicScore = 0.0;
    String diastolicDescription = '';

    if (diastolic < 80) {
      diastolicScore = 1.0;
      diastolicDescription = context.tr('您的舒張壓處於理想範圍內。');
    } else if (diastolic < 85) {
      diastolicScore = 2.0;
      diastolicDescription = context.tr('您的舒張壓處於正常範圍，但接近高血壓前期。');
    } else if (diastolic < 90) {
      diastolicScore = 3.0;
      diastolicDescription = context.tr('您的舒張壓處於高血壓前期，有發展為高血壓的風險。');
    } else if (diastolic < 100) {
      diastolicScore = 4.0;
      diastolicDescription = context.tr('您的舒張壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。');
    } else {
      diastolicScore = 5.0;
      diastolicDescription = context.tr('您的舒張壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。');
    }

    categories.add({'title': context.tr('舒張壓風險'), 'score': diastolicScore, 'description': diastolicDescription});

    // 脈壓差風險
    final pulsePressure = systolic - diastolic;
    double pulsePressureScore = 0.0;
    String pulsePressureDescription = '';

    if (pulsePressure < 40) {
      pulsePressureScore = 2.0;
      pulsePressureDescription = context.tr('您的脈壓差偏低，可能表示心臟輸出量減少。');
    } else if (pulsePressure <= 60) {
      pulsePressureScore = 1.0;
      pulsePressureDescription = context.tr('您的脈壓差處於正常範圍。');
    } else if (pulsePressure < 80) {
      pulsePressureScore = 3.0;
      pulsePressureDescription = context.tr('您的脈壓差略高，可能表示動脈彈性降低，是心血管疾病的風險因素。');
    } else {
      pulsePressureScore = 4.0;
      pulsePressureDescription = context.tr('您的脈壓差明顯偏高，這通常與動脈硬化相關，是心血管疾病的重要風險因素。');
    }

    categories.add({'title': context.tr('脈壓差分析'), 'score': pulsePressureScore, 'description': pulsePressureDescription});

    return categories;
  }

  // 生成健康生活方式建議
  List<Map<String, dynamic>> _generateHealthSuggestions(int systolic, int diastolic) {
    final suggestions = <Map<String, dynamic>>[];

    // 基本建議（適用於所有人）
    suggestions.add({'title': context.tr('保持健康飲食'), 'description': context.tr('減少鹽分攝入，增加蔬果攝入，選擇全穀物和低脂蛋白質，避免加工食品和高糖飲料。')});

    suggestions.add({'title': context.tr('規律運動'), 'description': context.tr('每週至少進行150分鐘中等強度有氧運動，如快走、游泳或騎自行車。')});

    // 根據血壓水平添加特定建議
    if (systolic >= 130 || diastolic >= 85) {
      suggestions.add({'title': context.tr('減少鈉鹽攝入'), 'description': context.tr('每日鈉鹽攝入量控制在5克以下，減少使用加工食品和外賣食品。')});

      suggestions.add({'title': context.tr('定期監測血壓'), 'description': context.tr('每日固定時間測量血壓，並記錄變化趨勢，定期與醫生分享這些記錄。')});
    }

    if (systolic >= 140 || diastolic >= 90) {
      suggestions.add({'title': context.tr('控制體重'), 'description': context.tr('將體重維持在健康範圍內可以幫助降低血壓，每減少1kg體重可降低血壓約1mmHg。')});

      suggestions.add({'title': context.tr('減少壓力'), 'description': context.tr('嘗試冥想、深呼吸或瑜伽等放鬆技巧，有助於降低壓力和血壓。')});

      suggestions.add({'title': context.tr('限制酒精攝入'), 'description': context.tr('男性每日酒精攝入量不超過25g，女性不超過15g。過量飲酒會顯著提高血壓。')});
    }

    if (systolic >= 160 || diastolic >= 100) {
      suggestions.add({'title': context.tr('諮詢醫療建議'), 'description': context.tr('您的血壓處於較高水平，建議儘快諮詢醫生獲取個人化的治療方案。')});
    }

    return suggestions;
  }
}
