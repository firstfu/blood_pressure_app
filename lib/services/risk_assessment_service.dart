/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 17:15:30
 * @ Description: 健康風險評估服務 - 提供基於血壓數據的健康風險評估功能
 */

import '../models/blood_pressure_record.dart';

class RiskAssessmentService {
  // 評估健康風險
  Future<Map<String, dynamic>> assessHealthRisk(List<BloodPressureRecord> records, {Map<String, dynamic>? userInfo}) async {
    // 如果記錄不足，無法進行評估
    if (records.isEmpty) {
      return {'hasData': false, 'message': '需要血壓記錄才能進行健康風險評估'};
    }

    // 獲取用戶信息（如果提供）
    final age = userInfo?['age'] as int? ?? 45;
    final gender = userInfo?['gender'] as String? ?? 'male';
    final hasDiabetes = userInfo?['hasDiabetes'] as bool? ?? false;
    final isSmoker = userInfo?['isSmoker'] as bool? ?? false;
    final cholesterolLevel = userInfo?['cholesterolLevel'] as double? ?? 5.0;

    // 計算平均血壓
    double systolicSum = 0;
    double diastolicSum = 0;

    for (final record in records) {
      systolicSum += record.systolic;
      diastolicSum += record.diastolic;
    }

    final avgSystolic = (systolicSum / records.length).round();
    final avgDiastolic = (diastolicSum / records.length).round();

    // 評估血壓風險等級
    final bpRiskLevel = _assessBloodPressureRiskLevel(avgSystolic, avgDiastolic);

    // 評估心血管疾病風險
    final cvdRiskScore = _calculateCVDRiskScore(avgSystolic, age, gender, hasDiabetes, isSmoker, cholesterolLevel);

    // 評估中風風險
    final strokeRiskScore = _calculateStrokeRiskScore(avgSystolic, avgDiastolic, age, gender, hasDiabetes, isSmoker);

    // 生成健康建議
    final recommendations = _generateHealthRecommendations(
      bpRiskLevel,
      cvdRiskScore,
      strokeRiskScore,
      avgSystolic,
      avgDiastolic,
      age,
      hasDiabetes,
      isSmoker,
      cholesterolLevel,
    );

    return {
      'hasData': true,
      'avgSystolic': avgSystolic,
      'avgDiastolic': avgDiastolic,
      'bpRiskLevel': bpRiskLevel,
      'cvdRiskScore': cvdRiskScore,
      'strokeRiskScore': strokeRiskScore,
      'recommendations': recommendations,
      'userInfo': {'age': age, 'gender': gender, 'hasDiabetes': hasDiabetes, 'isSmoker': isSmoker, 'cholesterolLevel': cholesterolLevel},
    };
  }

  // 評估血壓風險等級
  String _assessBloodPressureRiskLevel(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 'normal';
    } else if (systolic < 130 && diastolic < 85) {
      return 'elevated';
    } else if (systolic < 140 && diastolic < 90) {
      return 'high_normal';
    } else if (systolic < 160 && diastolic < 100) {
      return 'grade1';
    } else if (systolic < 180 && diastolic < 110) {
      return 'grade2';
    } else {
      return 'grade3';
    }
  }

  // 計算心血管疾病風險分數
  double _calculateCVDRiskScore(int systolic, int age, String gender, bool hasDiabetes, bool isSmoker, double cholesterolLevel) {
    // 基礎風險分數
    double score = 0;

    // 年齡因素
    if (age < 40) {
      score += 0;
    } else if (age < 50) {
      score += 1;
    } else if (age < 60) {
      score += 2;
    } else if (age < 70) {
      score += 3;
    } else {
      score += 4;
    }

    // 性別因素
    if (gender == 'male') {
      score += 1;
    }

    // 血壓因素
    if (systolic < 120) {
      score += 0;
    } else if (systolic < 130) {
      score += 1;
    } else if (systolic < 140) {
      score += 2;
    } else if (systolic < 160) {
      score += 3;
    } else if (systolic < 180) {
      score += 4;
    } else {
      score += 5;
    }

    // 糖尿病因素
    if (hasDiabetes) {
      score += 2;
    }

    // 吸煙因素
    if (isSmoker) {
      score += 2;
    }

    // 膽固醇因素
    if (cholesterolLevel < 4.0) {
      score += 0;
    } else if (cholesterolLevel < 5.0) {
      score += 1;
    } else if (cholesterolLevel < 6.0) {
      score += 2;
    } else if (cholesterolLevel < 7.0) {
      score += 3;
    } else {
      score += 4;
    }

    // 標準化分數（0-10）
    return score / 18 * 10;
  }

  // 計算中風風險分數
  double _calculateStrokeRiskScore(int systolic, int diastolic, int age, String gender, bool hasDiabetes, bool isSmoker) {
    // 基礎風險分數
    double score = 0;

    // 年齡因素
    if (age < 40) {
      score += 0;
    } else if (age < 50) {
      score += 1;
    } else if (age < 60) {
      score += 2;
    } else if (age < 70) {
      score += 3;
    } else {
      score += 4;
    }

    // 性別因素
    if (gender == 'male') {
      score += 0.5;
    }

    // 收縮壓因素
    if (systolic < 120) {
      score += 0;
    } else if (systolic < 140) {
      score += 1;
    } else if (systolic < 160) {
      score += 2;
    } else if (systolic < 180) {
      score += 3;
    } else {
      score += 4;
    }

    // 舒張壓因素
    if (diastolic < 80) {
      score += 0;
    } else if (diastolic < 90) {
      score += 0.5;
    } else if (diastolic < 100) {
      score += 1;
    } else if (diastolic < 110) {
      score += 1.5;
    } else {
      score += 2;
    }

    // 糖尿病因素
    if (hasDiabetes) {
      score += 2;
    }

    // 吸煙因素
    if (isSmoker) {
      score += 2;
    }

    // 標準化分數（0-10）
    return score / 14.5 * 10;
  }

  // 生成健康建議
  List<String> _generateHealthRecommendations(
    String bpRiskLevel,
    double cvdRiskScore,
    double strokeRiskScore,
    int systolic,
    int diastolic,
    int age,
    bool hasDiabetes,
    bool isSmoker,
    double cholesterolLevel,
  ) {
    final List<String> recommendations = [];

    // 基於血壓風險等級的建議
    if (bpRiskLevel == 'normal') {
      recommendations.add('您的血壓處於正常範圍，繼續保持健康的生活方式。');
    } else if (bpRiskLevel == 'elevated') {
      recommendations.add('您的血壓略高於理想水平，建議增加運動並減少鹽分攝入。');
    } else if (bpRiskLevel == 'high_normal') {
      recommendations.add('您的血壓處於高正常範圍，建議定期監測血壓，並考慮調整生活方式。');
    } else if (bpRiskLevel == 'grade1') {
      recommendations.add('您的血壓處於輕度高血壓範圍，建議諮詢醫生並調整生活方式。');
    } else if (bpRiskLevel == 'grade2') {
      recommendations.add('您的血壓處於中度高血壓範圍，建議盡快諮詢醫生並可能需要藥物治療。');
    } else {
      recommendations.add('您的血壓處於重度高血壓範圍，請立即就醫並遵循醫生的治療建議。');
    }

    // 基於心血管疾病風險的建議
    if (cvdRiskScore < 3) {
      recommendations.add('您的心血管疾病風險較低，繼續保持健康的生活方式。');
    } else if (cvdRiskScore < 6) {
      recommendations.add('您的心血管疾病風險中等，建議增加運動並改善飲食習慣。');
    } else {
      recommendations.add('您的心血管疾病風險較高，建議諮詢醫生並考慮進一步檢查。');
    }

    // 基於中風風險的建議
    if (strokeRiskScore < 3) {
      recommendations.add('您的中風風險較低，繼續保持健康的生活方式。');
    } else if (strokeRiskScore < 6) {
      recommendations.add('您的中風風險中等，建議增加運動並減少鹽分攝入。');
    } else {
      recommendations.add('您的中風風險較高，建議諮詢醫生並考慮進一步檢查。');
    }

    // 基於年齡的建議
    if (age >= 60) {
      recommendations.add('考慮到您的年齡，建議每天監測血壓並定期進行健康檢查。');
    }

    // 基於糖尿病狀態的建議
    if (hasDiabetes) {
      recommendations.add('由於您有糖尿病，建議嚴格控制血糖並定期監測血壓。');
    }

    // 基於吸煙狀態的建議
    if (isSmoker) {
      recommendations.add('吸煙會顯著增加心血管疾病風險，強烈建議戒煙。');
    }

    // 基於膽固醇水平的建議
    if (cholesterolLevel >= 5.2) {
      recommendations.add('您的膽固醇水平較高，建議減少飽和脂肪攝入並增加運動。');
    }

    // 一般健康建議
    recommendations.add('保持健康的生活方式：每天至少30分鐘中等強度運動，減少鹽分攝入，保持健康體重。');
    recommendations.add('遵循DASH飲食：增加蔬果、全穀物和低脂乳製品的攝入，減少紅肉和甜食。');

    return recommendations;
  }
}
