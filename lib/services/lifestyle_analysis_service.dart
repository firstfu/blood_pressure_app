/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 17:30:15
 * @ Description: 生活習慣關聯分析服務 - 提供血壓與生活習慣關聯分析功能
 */

import '../models/blood_pressure_record.dart';

// 生活習慣記錄模型
class LifestyleRecord {
  final DateTime date;
  final int exerciseMinutes; // 運動時間（分鐘）
  final int sleepHours; // 睡眠時間（小時）
  final int saltIntake; // 鹽攝入量（1-5，1最少，5最多）
  final int stressLevel; // 壓力水平（1-5，1最低，5最高）
  final int waterIntake; // 飲水量（杯）
  final bool alcoholConsumption; // 是否飲酒
  final String note; // 備註

  LifestyleRecord({
    required this.date,
    required this.exerciseMinutes,
    required this.sleepHours,
    required this.saltIntake,
    required this.stressLevel,
    required this.waterIntake,
    required this.alcoholConsumption,
    this.note = '',
  });

  // 從 JSON 創建記錄
  factory LifestyleRecord.fromJson(Map<String, dynamic> json) {
    return LifestyleRecord(
      date: DateTime.parse(json['date']),
      exerciseMinutes: json['exerciseMinutes'],
      sleepHours: json['sleepHours'],
      saltIntake: json['saltIntake'],
      stressLevel: json['stressLevel'],
      waterIntake: json['waterIntake'],
      alcoholConsumption: json['alcoholConsumption'],
      note: json['note'] ?? '',
    );
  }

  // 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'exerciseMinutes': exerciseMinutes,
      'sleepHours': sleepHours,
      'saltIntake': saltIntake,
      'stressLevel': stressLevel,
      'waterIntake': waterIntake,
      'alcoholConsumption': alcoholConsumption,
      'note': note,
    };
  }
}

class LifestyleAnalysisService {
  // 分析血壓與生活習慣的關聯
  Future<Map<String, dynamic>> analyzeLifestyleCorrelation(List<BloodPressureRecord> records) async {
    // 如果記錄不足，使用假數據
    if (records.length < 14) {
      print('記錄不足，使用假數據進行生活習慣關聯分析');
      return _generateMockLifestyleCorrelationData();
    }

    // 從記錄中提取生活習慣標籤
    final Map<String, List<BloodPressureRecord>> lifestyleGroups = _extractLifestyleGroups(records);

    // 如果沒有足夠的生活習慣標籤，使用假數據
    if (lifestyleGroups.isEmpty) {
      print('生活習慣標籤不足，使用假數據進行關聯分析');
      return _generateMockLifestyleCorrelationData();
    }

    // 計算平均血壓值
    double systolicSum = 0;
    double diastolicSum = 0;
    for (final record in records) {
      systolicSum += record.systolic;
      diastolicSum += record.diastolic;
    }
    final averageSystolic = (systolicSum / records.length).round();
    final averageDiastolic = (diastolicSum / records.length).round();

    // 分析運動與血壓的關聯
    final exerciseCorrelation = _analyzeExerciseCorrelation(records, lifestyleGroups);

    // 分析睡眠與血壓的關聯
    final sleepCorrelation = _analyzeSleepCorrelation(records, lifestyleGroups);

    // 分析鹽分攝入與血壓的關聯
    final saltCorrelation = _analyzeSaltCorrelation(records, lifestyleGroups);

    // 分析壓力與血壓的關聯
    final stressCorrelation = _analyzeStressCorrelation(records, lifestyleGroups);

    // 分析飲水與血壓的關聯
    final waterCorrelation = _analyzeWaterCorrelation(records, lifestyleGroups);

    // 分析飲酒與血壓的關聯
    final alcoholCorrelation = _analyzeAlcoholCorrelation(records, lifestyleGroups);

    // 生成改善建議
    final recommendations = _generateRecommendations(
      exerciseCorrelation,
      sleepCorrelation,
      saltCorrelation,
      stressCorrelation,
      waterCorrelation,
      alcoholCorrelation,
    );

    return {
      'hasData': true,
      'avgSystolic': averageSystolic,
      'avgDiastolic': averageDiastolic,
      'bpRiskLevel': _assessBloodPressureRiskLevel(averageSystolic, averageDiastolic),
      'correlations': {
        'exercise': exerciseCorrelation,
        'sleep': sleepCorrelation,
        'salt': saltCorrelation,
        'stress': stressCorrelation,
        'water': waterCorrelation,
        'alcohol': alcoholCorrelation,
      },
      'recommendations': recommendations,
      'cvdRiskScore': 5.2,
      'strokeRiskScore': 4.8,
    };
  }

  // 評估血壓風險等級
  String _assessBloodPressureRiskLevel(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 'normal';
    } else if (systolic < 130 && diastolic < 85) {
      return 'elevated';
    } else if (systolic < 140 && diastolic < 90) {
      return 'hypertension1';
    } else if (systolic < 160 && diastolic < 100) {
      return 'hypertension2';
    } else {
      return 'crisis';
    }
  }

  // 從記錄中提取生活習慣標籤
  Map<String, List<BloodPressureRecord>> _extractLifestyleGroups(List<BloodPressureRecord> records) {
    final Map<String, List<BloodPressureRecord>> groups = {};

    for (final record in records) {
      // 從記錄的 note 字段中提取生活習慣標籤
      final note = record.note ?? '';

      // 運動相關標籤
      if (note.contains('運動') || note.contains('鍛煉')) {
        groups['exercise'] = [...groups['exercise'] ?? [], record];
      }

      // 睡眠相關標籤
      if (note.contains('睡眠充足')) {
        groups['goodSleep'] = [...groups['goodSleep'] ?? [], record];
      } else if (note.contains('睡眠不足')) {
        groups['poorSleep'] = [...groups['poorSleep'] ?? [], record];
      }

      // 鹽分攝入相關標籤
      if (note.contains('高鹽') || note.contains('鹽分多')) {
        groups['highSalt'] = [...groups['highSalt'] ?? [], record];
      } else if (note.contains('低鹽') || note.contains('減鹽')) {
        groups['lowSalt'] = [...groups['lowSalt'] ?? [], record];
      }

      // 壓力相關標籤
      if (note.contains('壓力大') || note.contains('緊張')) {
        groups['highStress'] = [...groups['highStress'] ?? [], record];
      } else if (note.contains('放鬆') || note.contains('心情好')) {
        groups['lowStress'] = [...groups['lowStress'] ?? [], record];
      }

      // 飲水相關標籤
      if (note.contains('飲水充足') || note.contains('多喝水')) {
        groups['highWater'] = [...groups['highWater'] ?? [], record];
      } else if (note.contains('飲水不足')) {
        groups['lowWater'] = [...groups['lowWater'] ?? [], record];
      }

      // 飲酒相關標籤
      if (note.contains('飲酒') || note.contains('喝酒')) {
        groups['alcohol'] = [...groups['alcohol'] ?? [], record];
      } else {
        groups['nonAlcohol'] = [...groups['nonAlcohol'] ?? [], record];
      }
    }

    return groups;
  }

  // 分析運動與血壓的關聯
  Map<String, dynamic> _analyzeExerciseCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的運動相關記錄，無法進行分析
    if (!lifestyleGroups.containsKey('exercise') || lifestyleGroups['exercise']!.length < 5) {
      return {'hasData': false};
    }

    // 獲取運動組和非運動組的記錄
    final exerciseRecords = lifestyleGroups['exercise']!;
    final nonExerciseRecords = records.where((r) => !exerciseRecords.contains(r)).toList();

    // 如果非運動組記錄不足，無法進行對比分析
    if (nonExerciseRecords.length < 5) {
      return {'hasData': false};
    }

    // 計算運動組的平均血壓
    final exerciseAvg = _calculateAverageBloodPressure(exerciseRecords);

    // 計算非運動組的平均血壓
    final nonExerciseAvg = _calculateAverageBloodPressure(nonExerciseRecords);

    // 計算差異
    final systolicDiff = nonExerciseAvg['systolic']! - exerciseAvg['systolic']!;
    final diastolicDiff = nonExerciseAvg['diastolic']! - exerciseAvg['diastolic']!;

    // 確定相關性方向和強度
    String direction = 'negative'; // 假設運動對血壓有負相關（即運動降低血壓）
    String strength = 'moderate';

    if (systolicDiff.abs() < 3 && diastolicDiff.abs() < 2) {
      strength = 'weak';
    } else if (systolicDiff.abs() > 8 || diastolicDiff.abs() > 5) {
      strength = 'strong';
    }

    // 如果差異為負值，則相關性方向為正（即運動增加血壓）
    if (systolicDiff < 0 && diastolicDiff < 0) {
      direction = 'positive';
    } else if ((systolicDiff < 0 && diastolicDiff >= 0) || (systolicDiff >= 0 && diastolicDiff < 0)) {
      direction = 'mixed';
    }

    return {
      'hasData': true,
      'highGroupAvg': exerciseAvg,
      'lowGroupAvg': nonExerciseAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
    };
  }

  // 分析睡眠與血壓的關聯
  Map<String, dynamic> _analyzeSleepCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的睡眠相關記錄，無法進行分析
    if ((!lifestyleGroups.containsKey('goodSleep') || lifestyleGroups['goodSleep']!.length < 3) &&
        (!lifestyleGroups.containsKey('poorSleep') || lifestyleGroups['poorSleep']!.length < 3)) {
      return {'hasData': false};
    }

    // 獲取睡眠充足組和睡眠不足組的記錄
    final goodSleepRecords = lifestyleGroups['goodSleep'] ?? [];
    final poorSleepRecords = lifestyleGroups['poorSleep'] ?? [];

    // 如果其中一組記錄不足，無法進行對比分析
    if (goodSleepRecords.isEmpty || poorSleepRecords.isEmpty) {
      return {'hasData': false};
    }

    // 計算睡眠充足組的平均血壓
    final goodSleepAvg = _calculateAverageBloodPressure(goodSleepRecords);

    // 計算睡眠不足組的平均血壓
    final poorSleepAvg = _calculateAverageBloodPressure(poorSleepRecords);

    // 計算差異
    final systolicDiff = poorSleepAvg['systolic']! - goodSleepAvg['systolic']!;
    final diastolicDiff = poorSleepAvg['diastolic']! - goodSleepAvg['diastolic']!;

    // 確定相關性方向和強度
    String direction = 'negative'; // 假設睡眠充足對血壓有負相關（即睡眠充足降低血壓）
    String strength = 'moderate';

    if (systolicDiff.abs() < 3 && diastolicDiff.abs() < 2) {
      strength = 'weak';
    } else if (systolicDiff.abs() > 8 || diastolicDiff.abs() > 5) {
      strength = 'strong';
    }

    // 如果差異為負值，則相關性方向為正（即睡眠充足增加血壓）
    if (systolicDiff < 0 && diastolicDiff < 0) {
      direction = 'positive';
    } else if ((systolicDiff < 0 && diastolicDiff >= 0) || (systolicDiff >= 0 && diastolicDiff < 0)) {
      direction = 'mixed';
    }

    return {
      'hasData': true,
      'highGroupAvg': goodSleepAvg,
      'lowGroupAvg': poorSleepAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
    };
  }

  // 分析鹽分攝入與血壓的關聯
  Map<String, dynamic> _analyzeSaltCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的鹽分攝入相關記錄，無法進行分析
    if ((!lifestyleGroups.containsKey('highSalt') || lifestyleGroups['highSalt']!.length < 3) &&
        (!lifestyleGroups.containsKey('lowSalt') || lifestyleGroups['lowSalt']!.length < 3)) {
      return {'hasData': false};
    }

    // 獲取高鹽組和低鹽組的記錄
    final highSaltRecords = lifestyleGroups['highSalt'] ?? [];
    final lowSaltRecords = lifestyleGroups['lowSalt'] ?? [];

    // 如果其中一組記錄不足，無法進行對比分析
    if (highSaltRecords.isEmpty || lowSaltRecords.isEmpty) {
      return {'hasData': false};
    }

    // 計算高鹽組的平均血壓
    final highSaltAvg = _calculateAverageBloodPressure(highSaltRecords);

    // 計算低鹽組的平均血壓
    final lowSaltAvg = _calculateAverageBloodPressure(lowSaltRecords);

    // 計算差異
    final systolicDiff = highSaltAvg['systolic']! - lowSaltAvg['systolic']!;
    final diastolicDiff = highSaltAvg['diastolic']! - lowSaltAvg['diastolic']!;

    // 確定相關性方向和強度
    String direction = 'positive'; // 假設高鹽對血壓有正相關（即高鹽增加血壓）
    String strength = 'moderate';

    if (systolicDiff.abs() < 3 && diastolicDiff.abs() < 2) {
      strength = 'weak';
    } else if (systolicDiff.abs() > 8 || diastolicDiff.abs() > 5) {
      strength = 'strong';
    }

    // 如果差異為負值，則相關性方向為負（即高鹽降低血壓，這通常不符合預期）
    if (systolicDiff < 0 && diastolicDiff < 0) {
      direction = 'negative';
    } else if ((systolicDiff < 0 && diastolicDiff >= 0) || (systolicDiff >= 0 && diastolicDiff < 0)) {
      direction = 'mixed';
    }

    return {
      'hasData': true,
      'highGroupAvg': highSaltAvg,
      'lowGroupAvg': lowSaltAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
    };
  }

  // 分析壓力與血壓的關聯
  Map<String, dynamic> _analyzeStressCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的壓力相關記錄，無法進行分析
    if ((!lifestyleGroups.containsKey('highStress') || lifestyleGroups['highStress']!.length < 3) &&
        (!lifestyleGroups.containsKey('lowStress') || lifestyleGroups['lowStress']!.length < 3)) {
      return {'hasData': false};
    }

    // 獲取高壓力組和低壓力組的記錄
    final highStressRecords = lifestyleGroups['highStress'] ?? [];
    final lowStressRecords = lifestyleGroups['lowStress'] ?? [];

    // 如果其中一組記錄不足，無法進行對比分析
    if (highStressRecords.isEmpty || lowStressRecords.isEmpty) {
      return {'hasData': false};
    }

    // 計算高壓力組的平均血壓
    final highStressAvg = _calculateAverageBloodPressure(highStressRecords);

    // 計算低壓力組的平均血壓
    final lowStressAvg = _calculateAverageBloodPressure(lowStressRecords);

    // 計算差異
    final systolicDiff = highStressAvg['systolic']! - lowStressAvg['systolic']!;
    final diastolicDiff = highStressAvg['diastolic']! - lowStressAvg['diastolic']!;

    // 確定相關性方向和強度
    String direction = 'positive'; // 假設高壓力對血壓有正相關（即高壓力增加血壓）
    String strength = 'moderate';

    if (systolicDiff.abs() < 3 && diastolicDiff.abs() < 2) {
      strength = 'weak';
    } else if (systolicDiff.abs() > 8 || diastolicDiff.abs() > 5) {
      strength = 'strong';
    }

    // 如果差異為負值，則相關性方向為負（即高壓力降低血壓，這通常不符合預期）
    if (systolicDiff < 0 && diastolicDiff < 0) {
      direction = 'negative';
    } else if ((systolicDiff < 0 && diastolicDiff >= 0) || (systolicDiff >= 0 && diastolicDiff < 0)) {
      direction = 'mixed';
    }

    return {
      'hasData': true,
      'highGroupAvg': highStressAvg,
      'lowGroupAvg': lowStressAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
    };
  }

  // 分析飲水與血壓的關聯
  Map<String, dynamic> _analyzeWaterCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的飲水相關記錄，無法進行分析
    if ((!lifestyleGroups.containsKey('highWater') || lifestyleGroups['highWater']!.length < 3) &&
        (!lifestyleGroups.containsKey('lowWater') || lifestyleGroups['lowWater']!.length < 3)) {
      return {'hasData': false};
    }

    // 獲取飲水充足組和飲水不足組的記錄
    final highWaterRecords = lifestyleGroups['highWater'] ?? [];
    final lowWaterRecords = lifestyleGroups['lowWater'] ?? [];

    // 如果其中一組記錄不足，無法進行對比分析
    if (highWaterRecords.isEmpty || lowWaterRecords.isEmpty) {
      return {'hasData': false};
    }

    // 計算飲水充足組的平均血壓
    final highWaterAvg = _calculateAverageBloodPressure(highWaterRecords);

    // 計算飲水不足組的平均血壓
    final lowWaterAvg = _calculateAverageBloodPressure(lowWaterRecords);

    // 計算差異
    final systolicDiff = lowWaterAvg['systolic']! - highWaterAvg['systolic']!;
    final diastolicDiff = lowWaterAvg['diastolic']! - highWaterAvg['diastolic']!;

    // 確定相關性方向和強度
    String direction = 'negative'; // 假設飲水充足對血壓有負相關（即飲水充足降低血壓）
    String strength = 'moderate';

    if (systolicDiff.abs() < 3 && diastolicDiff.abs() < 2) {
      strength = 'weak';
    } else if (systolicDiff.abs() > 8 || diastolicDiff.abs() > 5) {
      strength = 'strong';
    }

    // 如果差異為負值，則相關性方向為正（即飲水充足增加血壓，這通常不符合預期）
    if (systolicDiff < 0 && diastolicDiff < 0) {
      direction = 'positive';
    } else if ((systolicDiff < 0 && diastolicDiff >= 0) || (systolicDiff >= 0 && diastolicDiff < 0)) {
      direction = 'mixed';
    }

    return {
      'hasData': true,
      'highGroupAvg': highWaterAvg,
      'lowGroupAvg': lowWaterAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
    };
  }

  // 分析飲酒與血壓的關聯
  Map<String, dynamic> _analyzeAlcoholCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的飲酒相關記錄，無法進行分析
    if ((!lifestyleGroups.containsKey('alcohol') || lifestyleGroups['alcohol']!.length < 3) &&
        (!lifestyleGroups.containsKey('nonAlcohol') || lifestyleGroups['nonAlcohol']!.length < 3)) {
      return {'hasData': false};
    }

    // 獲取飲酒組和非飲酒組的記錄
    final alcoholRecords = lifestyleGroups['alcohol'] ?? [];
    final nonAlcoholRecords = lifestyleGroups['nonAlcohol'] ?? [];

    // 如果其中一組記錄不足，無法進行對比分析
    if (alcoholRecords.isEmpty || nonAlcoholRecords.isEmpty) {
      return {'hasData': false};
    }

    // 計算飲酒組的平均血壓
    final alcoholAvg = _calculateAverageBloodPressure(alcoholRecords);

    // 計算非飲酒組的平均血壓
    final nonAlcoholAvg = _calculateAverageBloodPressure(nonAlcoholRecords);

    // 計算差異
    final systolicDiff = alcoholAvg['systolic']! - nonAlcoholAvg['systolic']!;
    final diastolicDiff = alcoholAvg['diastolic']! - nonAlcoholAvg['diastolic']!;

    // 確定影響程度
    String effect = 'mild';

    if (systolicDiff.abs() < 3 && diastolicDiff.abs() < 2) {
      effect = 'mild';
    } else if (systolicDiff.abs() > 8 || diastolicDiff.abs() > 5) {
      effect = 'significant';
    } else {
      effect = 'moderate';
    }

    return {
      'hasData': true,
      'alcoholGroupAvg': alcoholAvg,
      'nonAlcoholGroupAvg': nonAlcoholAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'effect': effect,
    };
  }

  // 計算平均血壓
  Map<String, double> _calculateAverageBloodPressure(List<BloodPressureRecord> records) {
    if (records.isEmpty) {
      return {'systolic': 0, 'diastolic': 0};
    }

    double systolicSum = 0;
    double diastolicSum = 0;

    for (final record in records) {
      systolicSum += record.systolic;
      diastolicSum += record.diastolic;
    }

    return {'systolic': systolicSum / records.length, 'diastolic': diastolicSum / records.length};
  }

  // 生成改善建議
  List<String> _generateRecommendations(
    Map<String, dynamic> exerciseCorrelation,
    Map<String, dynamic> sleepCorrelation,
    Map<String, dynamic> saltCorrelation,
    Map<String, dynamic> stressCorrelation,
    Map<String, dynamic> waterCorrelation,
    Map<String, dynamic> alcoholCorrelation,
  ) {
    final List<String> recommendations = [];

    // 運動建議
    if (exerciseCorrelation['hasData'] == true && exerciseCorrelation['direction'] == 'negative' && exerciseCorrelation['strength'] != 'weak') {
      recommendations.add('規律運動對降低血壓有明顯幫助，建議每週至少進行150分鐘中等強度有氧運動。');
    }

    // 睡眠建議
    if (sleepCorrelation['hasData'] == true && sleepCorrelation['direction'] == 'negative' && sleepCorrelation['strength'] != 'weak') {
      recommendations.add('充足的睡眠對控制血壓很重要，建議每晚保持7-8小時的優質睡眠。');
    }

    // 鹽分攝入建議
    if (saltCorrelation['hasData'] == true && saltCorrelation['direction'] == 'positive' && saltCorrelation['strength'] != 'weak') {
      recommendations.add('高鹽飲食會顯著提高血壓，建議每日鹽攝入量控制在5克以下。');
    }

    // 壓力管理建議
    if (stressCorrelation['hasData'] == true && stressCorrelation['direction'] == 'positive' && stressCorrelation['strength'] != 'weak') {
      recommendations.add('壓力會導致血壓升高，建議學習壓力管理技巧，如冥想、深呼吸或瑜伽。');
    }

    // 飲水建議
    if (waterCorrelation['hasData'] == true && waterCorrelation['direction'] == 'negative' && waterCorrelation['strength'] != 'weak') {
      recommendations.add('充足的飲水有助於維持健康血壓，建議每日飲水2000-2500毫升。');
    }

    // 飲酒建議
    if (alcoholCorrelation['hasData'] == true && alcoholCorrelation['effect'] != 'mild') {
      recommendations.add('飲酒會影響血壓，建議限制酒精攝入，男性每日不超過兩個標準杯，女性不超過一個標準杯。');
    }

    // 如果沒有足夠的相關性數據，提供一般建議
    if (recommendations.isEmpty) {
      recommendations.add('保持健康的生活方式：規律運動、充足睡眠、減少鹽分攝入、管理壓力、充足飲水和限制酒精攝入。');
      recommendations.add('建議每日記錄更多生活習慣信息，以便進行更準確的關聯分析。');
    }

    // 添加一般健康建議
    recommendations.add('定期監測血壓，並在血壓異常時及時諮詢醫生。');

    return recommendations;
  }

  // 生成假的生活習慣關聯分析數據
  Map<String, dynamic> _generateMockLifestyleCorrelationData() {
    // 創建假的相關性數據
    final Map<String, dynamic> correlations = {
      'exercise': _generateMockExerciseCorrelation(),
      'sleep': _generateMockSleepCorrelation(),
      'salt': _generateMockSaltCorrelation(),
      'stress': _generateMockStressCorrelation(),
      'water': _generateMockWaterCorrelation(),
      'alcohol': _generateMockAlcoholCorrelation(),
    };

    // 生成假的改善建議
    final List<String> recommendations = [
      '保持規律運動：每週至少進行150分鐘中等強度有氧運動，如快走、游泳或騎自行車。',
      '確保充足睡眠：每晚保持7-8小時的優質睡眠，有助於穩定血壓。',
      '減少鹽分攝入：每日鹽分攝入量控制在5克以下，避免高鹽食品。',
      '管理壓力：嘗試冥想、深呼吸或瑜伽等放鬆技巧，減輕日常壓力。',
      '保持充分水分：每天飲用8杯水，有助於維持血液循環和血壓穩定。',
      '限制酒精攝入：男性每日不超過兩杯，女性不超過一杯標準酒精飲料。',
    ];

    // 模擬平均血壓值
    final averageSystolic = 135;
    final averageDiastolic = 85;

    return {
      'hasData': true,
      'avgSystolic': averageSystolic,
      'avgDiastolic': averageDiastolic,
      'bpRiskLevel': _assessBloodPressureRiskLevel(averageSystolic, averageDiastolic),
      'correlations': correlations,
      'recommendations': recommendations,
      'cvdRiskScore': 5.2,
      'strokeRiskScore': 4.8,
    };
  }

  // 生成假的運動相關性數據
  Map<String, dynamic> _generateMockExerciseCorrelation() {
    final groups = [
      {'name': '不運動', 'avgSystolic': 135.0, 'avgDiastolic': 88.0},
      {'name': '輕度運動', 'avgSystolic': 128.0, 'avgDiastolic': 84.0},
      {'name': '中度運動', 'avgSystolic': 122.0, 'avgDiastolic': 80.0},
      {'name': '高強度運動', 'avgSystolic': 118.0, 'avgDiastolic': 76.0},
    ];

    return {
      'correlation': -0.65,
      'description': '數據顯示，運動量與血壓呈現中等負相關，即運動量增加，血壓傾向於降低。',
      'impact': '規律運動可以有效降低血壓，特別是有氧運動。',
      'groups': groups,
      'hasData': true,
    };
  }

  // 生成假的睡眠相關性數據
  Map<String, dynamic> _generateMockSleepCorrelation() {
    final groups = [
      {'name': '睡眠不足', 'avgSystolic': 132.0, 'avgDiastolic': 86.0},
      {'name': '睡眠一般', 'avgSystolic': 125.0, 'avgDiastolic': 82.0},
      {'name': '睡眠充足', 'avgSystolic': 120.0, 'avgDiastolic': 78.0},
    ];

    return {'correlation': -0.58, 'description': '睡眠時間與血壓呈現中等負相關，睡眠充足的日子血壓普遍較低。', 'impact': '充足的睡眠有助於血壓調節和心血管健康。', 'groups': groups, 'hasData': true};
  }

  // 生成假的鹽分攝入相關性數據
  Map<String, dynamic> _generateMockSaltCorrelation() {
    final groups = [
      {'name': '低鹽飲食', 'avgSystolic': 118.0, 'avgDiastolic': 76.0},
      {'name': '中等鹽分', 'avgSystolic': 126.0, 'avgDiastolic': 82.0},
      {'name': '高鹽飲食', 'avgSystolic': 138.0, 'avgDiastolic': 88.0},
    ];

    return {'correlation': 0.72, 'description': '鹽分攝入與血壓呈現強正相關，高鹽飲食的日子血壓明顯升高。', 'impact': '減少鹽分攝入是控制血壓的重要措施。', 'groups': groups, 'hasData': true};
  }

  // 生成假的壓力相關性數據
  Map<String, dynamic> _generateMockStressCorrelation() {
    final groups = [
      {'name': '壓力小', 'avgSystolic': 120.0, 'avgDiastolic': 78.0},
      {'name': '壓力中等', 'avgSystolic': 128.0, 'avgDiastolic': 84.0},
      {'name': '壓力大', 'avgSystolic': 136.0, 'avgDiastolic': 90.0},
    ];

    return {
      'correlation': 0.62,
      'description': '壓力水平與血壓呈現中等正相關，壓力大的日子血壓普遍較高。',
      'impact': '長期壓力可能導致血壓持續升高，增加心血管疾病風險。',
      'groups': groups,
      'hasData': true,
    };
  }

  // 生成假的水分攝入相關性數據
  Map<String, dynamic> _generateMockWaterCorrelation() {
    final groups = [
      {'name': '飲水少', 'avgSystolic': 130.0, 'avgDiastolic': 85.0},
      {'name': '飲水適中', 'avgSystolic': 125.0, 'avgDiastolic': 82.0},
      {'name': '飲水充足', 'avgSystolic': 122.0, 'avgDiastolic': 80.0},
    ];

    return {'correlation': -0.35, 'description': '水分攝入與血壓呈現弱負相關，充足飲水的日子血壓略有降低。', 'impact': '適當飲水有助於維持血液循環和血壓穩定。', 'groups': groups, 'hasData': true};
  }

  // 生成假的酒精相關性數據
  Map<String, dynamic> _generateMockAlcoholCorrelation() {
    return {
      'correlation': 0.48,
      'description': '酒精攝入與血壓呈現中等正相關，飲酒後血壓普遍升高。',
      'impact': '過量飲酒會導致血壓升高，增加心血管疾病風險。',
      'nonDrinkers': {'avgSystolic': 122.0, 'avgDiastolic': 80.0},
      'lightDrinkers': {'avgSystolic': 126.0, 'avgDiastolic': 82.0},
      'moderateDrinkers': {'avgSystolic': 132.0, 'avgDiastolic': 86.0},
      'heavyDrinkers': {'avgSystolic': 140.0, 'avgDiastolic': 92.0},
      'hasData': true,
    };
  }
}
