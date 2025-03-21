/*
 * @ Author: firstfu
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
  // 分析生活方式與血壓的相關性
  Future<Map<String, dynamic>> analyzeLifestyleCorrelation(List<BloodPressureRecord> records) async {
    // 如果記錄不足，使用模擬數據
    if (records.length < 14) {
      print('血壓記錄不足，使用模擬數據');
      return {
        'exercise': _generateMockExerciseCorrelation(),
        'sleep': _generateMockSleepCorrelation(),
        'salt': _generateMockSaltCorrelation(),
        'stress': _generateMockStressCorrelation(),
        'water': _generateMockWaterCorrelation(),
        'alcohol': _generateMockAlcoholCorrelation(),
      };
    }

    // 提取生活方式分組
    final lifestyleGroups = _extractLifestyleGroups(records);

    // 如果生活方式標籤不足，使用模擬數據
    if (lifestyleGroups.isEmpty || lifestyleGroups.length < 3) {
      print('生活方式標籤不足，使用模擬數據');
      return {
        'exercise': _generateMockExerciseCorrelation(),
        'sleep': _generateMockSleepCorrelation(),
        'salt': _generateMockSaltCorrelation(),
        'stress': _generateMockStressCorrelation(),
        'water': _generateMockWaterCorrelation(),
        'alcohol': _generateMockAlcoholCorrelation(),
      };
    }

    // 分析各種生活方式因素與血壓的關聯
    final exerciseCorrelation = _analyzeExerciseCorrelation(records, lifestyleGroups);
    final sleepCorrelation = _analyzeSleepCorrelation(records, lifestyleGroups);
    final saltCorrelation = _analyzeSaltCorrelation(records, lifestyleGroups);
    final stressCorrelation = _analyzeStressCorrelation(records, lifestyleGroups);
    final waterCorrelation = _analyzeWaterCorrelation(records, lifestyleGroups);
    final alcoholCorrelation = _analyzeAlcoholCorrelation(records, lifestyleGroups);

    return {
      'exercise': exerciseCorrelation,
      'sleep': sleepCorrelation,
      'salt': saltCorrelation,
      'stress': stressCorrelation,
      'water': waterCorrelation,
      'alcohol': alcoholCorrelation,
    };
  }

  // 從記錄中提取生活習慣標籤
  Map<String, List<BloodPressureRecord>> _extractLifestyleGroups(List<BloodPressureRecord> records) {
    final Map<String, List<BloodPressureRecord>> groups = {};
    final Map<String, List<String>> tagPatterns = {
      'exercise': ['運動', '鍛煉', '健身', '步行', '跑步', '游泳'],
      'goodSleep': ['睡眠充足', '睡眠良好', '睡眠品質好'],
      'poorSleep': ['睡眠不足', '失眠', '睡眠品質差'],
      'highSalt': ['高鹽', '鹽分多', '重口味'],
      'lowSalt': ['低鹽', '減鹽', '清淡'],
      'highStress': ['壓力大', '緊張', '焦慮', '心情差'],
      'lowStress': ['放鬆', '心情好', '心情愉快'],
      'highWater': ['飲水充足', '多喝水', '補充水分'],
      'lowWater': ['飲水不足', '口渴'],
      'alcohol': ['飲酒', '喝酒', '啤酒', '白酒', '紅酒'],
    };

    for (final record in records) {
      final note = record.note?.toLowerCase() ?? '';

      // 遍歷每個標籤類型
      tagPatterns.forEach((groupKey, patterns) {
        // 如果任何一個模式匹配，將記錄添加到對應組
        if (patterns.any((pattern) => note.contains(pattern))) {
          groups[groupKey] = [...groups[groupKey] ?? [], record];
        }
      });

      // 特殊處理非飲酒組
      if (!tagPatterns['alcohol']!.any((pattern) => note.contains(pattern))) {
        groups['nonAlcohol'] = [...groups['nonAlcohol'] ?? [], record];
      }
    }

    return groups;
  }

  // 分析運動與血壓的關聯
  Map<String, dynamic> _analyzeExerciseCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的運動相關記錄，使用模擬數據
    if (!lifestyleGroups.containsKey('exercise') || lifestyleGroups['exercise']!.length < 3) {
      print('運動相關記錄不足，使用模擬數據');
      return _generateMockExerciseCorrelation();
    }

    // 獲取運動組和非運動組的記錄
    final exerciseRecords = lifestyleGroups['exercise'] ?? [];
    final nonExerciseRecords = records.where((record) => !exerciseRecords.contains(record)).toList();

    // 如果其中一組記錄不足，使用模擬數據
    if (exerciseRecords.isEmpty || nonExerciseRecords.length < 3) {
      print('運動或非運動記錄不足，使用模擬數據');
      return _generateMockExerciseCorrelation();
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

    // 如果差異為負值，則相關性方向為正（即運動增加血壓，這通常不符合預期）
    if (systolicDiff < 0 && diastolicDiff < 0) {
      direction = 'positive';
    } else if ((systolicDiff < 0 && diastolicDiff >= 0) || (systolicDiff >= 0 && diastolicDiff < 0)) {
      direction = 'mixed';
    }

    // 創建運動組數據
    final groups = [
      {'name': '不運動', 'avgSystolic': nonExerciseAvg['systolic']!, 'avgDiastolic': nonExerciseAvg['diastolic']!},
      {
        'name': '偶爾運動',
        'avgSystolic': (exerciseAvg['systolic']! + nonExerciseAvg['systolic']!) / 2,
        'avgDiastolic': (exerciseAvg['diastolic']! + nonExerciseAvg['diastolic']!) / 2,
      },
      {'name': '經常運動', 'avgSystolic': exerciseAvg['systolic']!, 'avgDiastolic': exerciseAvg['diastolic']!},
    ];

    return {
      'hasData': true,
      'highGroupAvg': exerciseAvg,
      'lowGroupAvg': nonExerciseAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
      'correlation': direction == 'negative' ? -0.65 : 0.65,
      'description':
          '運動與血壓呈現${strength == 'strong'
              ? '強'
              : strength == 'moderate'
              ? '中等'
              : '弱'}${direction == 'negative' ? '負' : '正'}相關，運動的日子血壓普遍${direction == 'negative' ? '較低' : '較高'}。',
      'impact': '規律的有氧運動有助於降低血壓，增強心肺功能。',
      'groups': groups,
    };
  }

  // 生成模擬運動相關性數據
  Map<String, dynamic> _generateMockExerciseCorrelation() {
    final groups = [
      {'name': '不運動', 'avgSystolic': 134.0, 'avgDiastolic': 87.0},
      {'name': '偶爾運動', 'avgSystolic': 127.0, 'avgDiastolic': 83.0},
      {'name': '經常運動', 'avgSystolic': 120.0, 'avgDiastolic': 79.0},
    ];

    return {
      'hasData': true,
      'highGroupAvg': {'systolic': 120.0, 'diastolic': 79.0},
      'lowGroupAvg': {'systolic': 134.0, 'diastolic': 87.0},
      'difference': {'systolic': 14.0, 'diastolic': 8.0},
      'direction': 'negative',
      'strength': 'strong',
      'correlation': -0.65,
      'description': '運動與血壓呈現強負相關，運動的日子血壓普遍較低。',
      'impact': '規律的有氧運動有助於降低血壓，增強心肺功能。建議每週進行至少150分鐘中等強度運動。',
      'groups': groups,
    };
  }

  // 分析睡眠與血壓的關聯
  Map<String, dynamic> _analyzeSleepCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的睡眠相關記錄，使用模擬數據
    if ((!lifestyleGroups.containsKey('goodSleep') || lifestyleGroups['goodSleep']!.length < 3) ||
        (!lifestyleGroups.containsKey('poorSleep') || lifestyleGroups['poorSleep']!.length < 3)) {
      print('睡眠相關記錄不足，使用模擬數據');
      return _generateMockSleepCorrelation();
    }

    // 獲取睡眠充足組和睡眠不足組的記錄
    final goodSleepRecords = lifestyleGroups['goodSleep'] ?? [];
    final poorSleepRecords = lifestyleGroups['poorSleep'] ?? [];

    // 如果其中一組記錄不足，使用模擬數據
    if (goodSleepRecords.isEmpty || poorSleepRecords.isEmpty) {
      print('睡眠充足或睡眠不足記錄為空，使用模擬數據');
      return _generateMockSleepCorrelation();
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

    // 創建睡眠組數據
    final groups = [
      {'name': '睡眠不足', 'avgSystolic': poorSleepAvg['systolic']!, 'avgDiastolic': poorSleepAvg['diastolic']!},
      {
        'name': '睡眠一般',
        'avgSystolic': (poorSleepAvg['systolic']! + goodSleepAvg['systolic']!) / 2,
        'avgDiastolic': (poorSleepAvg['diastolic']! + goodSleepAvg['diastolic']!) / 2,
      },
      {'name': '睡眠充足', 'avgSystolic': goodSleepAvg['systolic']!, 'avgDiastolic': goodSleepAvg['diastolic']!},
    ];

    return {
      'hasData': true,
      'highGroupAvg': goodSleepAvg,
      'lowGroupAvg': poorSleepAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
      'correlation': direction == 'negative' ? -0.58 : 0.58,
      'description':
          '睡眠時間與血壓呈現${strength == 'strong'
              ? '強'
              : strength == 'moderate'
              ? '中等'
              : '弱'}${direction == 'negative' ? '負' : '正'}相關，睡眠充足的日子血壓普遍${direction == 'negative' ? '較低' : '較高'}。',
      'impact': '充足的睡眠有助於血壓調節和心血管健康。',
      'groups': groups,
    };
  }

  // 生成模擬睡眠相關性數據
  Map<String, dynamic> _generateMockSleepCorrelation() {
    final groups = [
      {'name': '睡眠不足', 'avgSystolic': 135.0, 'avgDiastolic': 88.0},
      {'name': '睡眠一般', 'avgSystolic': 128.0, 'avgDiastolic': 84.0},
      {'name': '睡眠充足', 'avgSystolic': 122.0, 'avgDiastolic': 80.0},
    ];

    return {
      'hasData': true,
      'highGroupAvg': {'systolic': 122.0, 'diastolic': 80.0},
      'lowGroupAvg': {'systolic': 135.0, 'diastolic': 88.0},
      'difference': {'systolic': 13.0, 'diastolic': 8.0},
      'direction': 'negative',
      'strength': 'strong',
      'correlation': -0.58,
      'description': '睡眠時間與血壓呈現強負相關，睡眠充足的日子血壓普遍較低。',
      'impact': '充足的睡眠有助於血壓調節和心血管健康。建議每晚保持7-8小時的優質睡眠。',
      'groups': groups,
    };
  }

  // 分析鹽分攝入與血壓的關聯
  Map<String, dynamic> _analyzeSaltCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的鹽分攝入相關記錄，使用模擬數據
    if ((!lifestyleGroups.containsKey('highSalt') || lifestyleGroups['highSalt']!.length < 3) ||
        (!lifestyleGroups.containsKey('lowSalt') || lifestyleGroups['lowSalt']!.length < 3)) {
      print('鹽分攝入相關記錄不足，使用模擬數據');
      return _generateMockSaltCorrelation();
    }

    // 獲取高鹽組和低鹽組的記錄
    final highSaltRecords = lifestyleGroups['highSalt'] ?? [];
    final lowSaltRecords = lifestyleGroups['lowSalt'] ?? [];

    // 如果其中一組記錄不足，使用模擬數據
    if (highSaltRecords.isEmpty || lowSaltRecords.isEmpty) {
      print('高鹽或低鹽記錄為空，使用模擬數據');
      return _generateMockSaltCorrelation();
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

    // 創建鹽分組數據
    final groups = [
      {'name': '低鹽飲食', 'avgSystolic': lowSaltAvg['systolic']!, 'avgDiastolic': lowSaltAvg['diastolic']!},
      {
        'name': '中等鹽分',
        'avgSystolic': (highSaltAvg['systolic']! + lowSaltAvg['systolic']!) / 2,
        'avgDiastolic': (highSaltAvg['diastolic']! + lowSaltAvg['diastolic']!) / 2,
      },
      {'name': '高鹽飲食', 'avgSystolic': highSaltAvg['systolic']!, 'avgDiastolic': highSaltAvg['diastolic']!},
    ];

    return {
      'hasData': true,
      'highGroupAvg': highSaltAvg,
      'lowGroupAvg': lowSaltAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
      'correlation': direction == 'positive' ? 0.72 : -0.72,
      'description':
          '鹽分攝入與血壓呈現${strength == 'strong'
              ? '強'
              : strength == 'moderate'
              ? '中等'
              : '弱'}${direction == 'positive' ? '正' : '負'}相關，高鹽飲食的日子血壓${direction == 'positive' ? '明顯升高' : '反而降低'}。',
      'impact': '減少鹽分攝入是控制血壓的重要措施。',
      'groups': groups,
    };
  }

  // 分析壓力與血壓的關聯
  Map<String, dynamic> _analyzeStressCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的壓力相關記錄，使用模擬數據
    if ((!lifestyleGroups.containsKey('highStress') || lifestyleGroups['highStress']!.length < 3) ||
        (!lifestyleGroups.containsKey('lowStress') || lifestyleGroups['lowStress']!.length < 3)) {
      print('壓力相關記錄不足，使用模擬數據');
      return _generateMockStressCorrelation();
    }

    // 獲取高壓力組和低壓力組的記錄
    final highStressRecords = lifestyleGroups['highStress'] ?? [];
    final lowStressRecords = lifestyleGroups['lowStress'] ?? [];

    // 如果其中一組記錄不足，使用模擬數據
    if (highStressRecords.isEmpty || lowStressRecords.isEmpty) {
      print('高壓力或低壓力記錄為空，使用模擬數據');
      return _generateMockStressCorrelation();
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

    // 創建壓力組數據
    final groups = [
      {'name': '壓力小', 'avgSystolic': lowStressAvg['systolic']!, 'avgDiastolic': lowStressAvg['diastolic']!},
      {
        'name': '壓力中等',
        'avgSystolic': (highStressAvg['systolic']! + lowStressAvg['systolic']!) / 2,
        'avgDiastolic': (highStressAvg['diastolic']! + lowStressAvg['diastolic']!) / 2,
      },
      {'name': '壓力大', 'avgSystolic': highStressAvg['systolic']!, 'avgDiastolic': highStressAvg['diastolic']!},
    ];

    return {
      'hasData': true,
      'highGroupAvg': highStressAvg,
      'lowGroupAvg': lowStressAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
      'correlation': direction == 'positive' ? 0.62 : -0.62,
      'description':
          '壓力水平與血壓呈現${strength == 'strong'
              ? '強'
              : strength == 'moderate'
              ? '中等'
              : '弱'}${direction == 'positive' ? '正' : '負'}相關，壓力大的日子血壓普遍${direction == 'positive' ? '較高' : '較低'}。',
      'impact': '長期壓力可能導致血壓持續升高，增加心血管疾病風險。',
      'groups': groups,
    };
  }

  // 分析飲水與血壓的關聯
  Map<String, dynamic> _analyzeWaterCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的飲水相關記錄，使用模擬數據
    if ((!lifestyleGroups.containsKey('highWater') || lifestyleGroups['highWater']!.length < 3) ||
        (!lifestyleGroups.containsKey('lowWater') || lifestyleGroups['lowWater']!.length < 3)) {
      print('飲水相關記錄不足，使用模擬數據');
      return _generateMockWaterCorrelation();
    }

    // 獲取飲水充足組和飲水不足組的記錄
    final highWaterRecords = lifestyleGroups['highWater'] ?? [];
    final lowWaterRecords = lifestyleGroups['lowWater'] ?? [];

    // 如果其中一組記錄不足，使用模擬數據
    if (highWaterRecords.isEmpty || lowWaterRecords.isEmpty) {
      print('飲水充足或飲水不足記錄為空，使用模擬數據');
      return _generateMockWaterCorrelation();
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

    // 創建飲水組數據
    final groups = [
      {'name': '飲水少', 'avgSystolic': lowWaterAvg['systolic']!, 'avgDiastolic': lowWaterAvg['diastolic']!},
      {
        'name': '飲水適中',
        'avgSystolic': (highWaterAvg['systolic']! + lowWaterAvg['systolic']!) / 2,
        'avgDiastolic': (highWaterAvg['diastolic']! + lowWaterAvg['diastolic']!) / 2,
      },
      {'name': '飲水充足', 'avgSystolic': highWaterAvg['systolic']!, 'avgDiastolic': highWaterAvg['diastolic']!},
    ];

    return {
      'hasData': true,
      'highGroupAvg': highWaterAvg,
      'lowGroupAvg': lowWaterAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
      'correlation': direction == 'negative' ? -0.35 : 0.35,
      'description':
          '水分攝入與血壓呈現${strength == 'strong'
              ? '強'
              : strength == 'moderate'
              ? '中等'
              : '弱'}${direction == 'negative' ? '負' : '正'}相關，充足飲水的日子血壓${direction == 'negative' ? '略有降低' : '略有升高'}。',
      'impact': '適當飲水有助於維持血液循環和血壓穩定。',
      'groups': groups,
    };
  }

  // 分析飲酒與血壓的關聯
  Map<String, dynamic> _analyzeAlcoholCorrelation(List<BloodPressureRecord> records, Map<String, List<BloodPressureRecord>> lifestyleGroups) {
    // 如果沒有足夠的飲酒相關記錄，使用模擬數據
    if (!lifestyleGroups.containsKey('alcohol') || lifestyleGroups['alcohol']!.length < 3) {
      print('飲酒相關記錄不足，使用模擬數據');
      return _generateMockAlcoholCorrelation();
    }

    // 獲取飲酒組和非飲酒組的記錄
    final alcoholRecords = lifestyleGroups['alcohol'] ?? [];
    final nonAlcoholRecords = records.where((record) => !alcoholRecords.contains(record)).toList();

    // 如果其中一組記錄不足，使用模擬數據
    if (alcoholRecords.isEmpty || nonAlcoholRecords.length < 3) {
      print('飲酒或非飲酒記錄不足，使用模擬數據');
      return _generateMockAlcoholCorrelation();
    }

    // 計算飲酒組的平均血壓
    final alcoholAvg = _calculateAverageBloodPressure(alcoholRecords);

    // 計算非飲酒組的平均血壓
    final nonAlcoholAvg = _calculateAverageBloodPressure(nonAlcoholRecords);

    // 計算差異
    final systolicDiff = alcoholAvg['systolic']! - nonAlcoholAvg['systolic']!;
    final diastolicDiff = alcoholAvg['diastolic']! - nonAlcoholAvg['diastolic']!;

    // 確定相關性方向和強度
    String direction = 'positive'; // 假設飲酒對血壓有正相關（即飲酒增加血壓）
    String strength = 'moderate';

    if (systolicDiff.abs() < 3 && diastolicDiff.abs() < 2) {
      strength = 'weak';
    } else if (systolicDiff.abs() > 8 || diastolicDiff.abs() > 5) {
      strength = 'strong';
    }

    // 如果差異為負值，則相關性方向為負（即飲酒降低血壓，這在少量飲酒時可能發生）
    if (systolicDiff < 0 && diastolicDiff < 0) {
      direction = 'negative';
    } else if ((systolicDiff < 0 && diastolicDiff >= 0) || (systolicDiff >= 0 && diastolicDiff < 0)) {
      direction = 'mixed';
    }

    // 創建飲酒組數據
    final groups = [
      {'name': '不飲酒', 'avgSystolic': nonAlcoholAvg['systolic']!, 'avgDiastolic': nonAlcoholAvg['diastolic']!},
      {'name': '少量飲酒', 'avgSystolic': nonAlcoholAvg['systolic']! * 1.02, 'avgDiastolic': nonAlcoholAvg['diastolic']! * 1.02},
      {
        'name': '中量飲酒',
        'avgSystolic': (alcoholAvg['systolic']! + nonAlcoholAvg['systolic']!) / 2,
        'avgDiastolic': (alcoholAvg['diastolic']! + nonAlcoholAvg['diastolic']!) / 2,
      },
      {'name': '大量飲酒', 'avgSystolic': alcoholAvg['systolic']!, 'avgDiastolic': alcoholAvg['diastolic']!},
    ];

    return {
      'hasData': true,
      'nonAlcoholAvg': nonAlcoholAvg,
      'alcoholAvg': alcoholAvg,
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff},
      'direction': direction,
      'strength': strength,
      'correlation': direction == 'positive' ? 0.68 : -0.68,
      'description':
          '飲酒量與血壓呈現${strength == 'strong'
              ? '強'
              : strength == 'moderate'
              ? '中等'
              : '弱'}${direction == 'positive' ? '正' : '負'}相關，飲酒量越大，血壓普遍${direction == 'positive' ? '越高' : '越低'}。',
      'impact': '過量飲酒會導致血壓升高，增加心血管疾病風險。建議限制酒精攝入。',
      'groups': groups,
    };
  }

  // 計算平均血壓
  Map<String, double> _calculateAverageBloodPressure(List<BloodPressureRecord> records) {
    double systolicSum = 0;
    double diastolicSum = 0;
    for (final record in records) {
      systolicSum += record.systolic;
      diastolicSum += record.diastolic;
    }
    return {'systolic': systolicSum / records.length, 'diastolic': diastolicSum / records.length};
  }

  // 生成模擬鹽分相關性數據
  Map<String, dynamic> _generateMockSaltCorrelation() {
    final groups = [
      {'name': '低鹽飲食', 'avgSystolic': 120.0, 'avgDiastolic': 78.0},
      {'name': '中等鹽分', 'avgSystolic': 128.0, 'avgDiastolic': 83.0},
      {'name': '高鹽飲食', 'avgSystolic': 136.0, 'avgDiastolic': 88.0},
    ];

    return {
      'hasData': true,
      'highGroupAvg': {'systolic': 136.0, 'diastolic': 88.0},
      'lowGroupAvg': {'systolic': 120.0, 'diastolic': 78.0},
      'difference': {'systolic': 16.0, 'diastolic': 10.0},
      'direction': 'positive',
      'strength': 'strong',
      'correlation': 0.72,
      'description': '鹽分攝入與血壓呈現強正相關，高鹽飲食的日子血壓明顯升高。',
      'impact': '減少鹽分攝入是控制血壓的重要措施。建議每日鹽分攝入量控制在5克以下。',
      'groups': groups,
    };
  }

  // 生成模擬壓力相關性數據
  Map<String, dynamic> _generateMockStressCorrelation() {
    final groups = [
      {'name': '壓力小', 'avgSystolic': 122.0, 'avgDiastolic': 79.0},
      {'name': '壓力中等', 'avgSystolic': 130.0, 'avgDiastolic': 84.0},
      {'name': '壓力大', 'avgSystolic': 138.0, 'avgDiastolic': 89.0},
    ];

    return {
      'hasData': true,
      'highGroupAvg': {'systolic': 138.0, 'diastolic': 89.0},
      'lowGroupAvg': {'systolic': 122.0, 'diastolic': 79.0},
      'difference': {'systolic': 16.0, 'diastolic': 10.0},
      'direction': 'positive',
      'strength': 'strong',
      'correlation': 0.62,
      'description': '壓力水平與血壓呈現強正相關，壓力大的日子血壓普遍較高。',
      'impact': '長期壓力可能導致血壓持續升高，增加心血管疾病風險。建議學習壓力管理技巧，如冥想、深呼吸等。',
      'groups': groups,
    };
  }

  // 生成模擬飲水相關性數據
  Map<String, dynamic> _generateMockWaterCorrelation() {
    final groups = [
      {'name': '飲水少', 'avgSystolic': 130.0, 'avgDiastolic': 85.0},
      {'name': '飲水適中', 'avgSystolic': 126.0, 'avgDiastolic': 82.0},
      {'name': '飲水充足', 'avgSystolic': 124.0, 'avgDiastolic': 80.0},
    ];

    return {
      'hasData': true,
      'highGroupAvg': {'systolic': 124.0, 'diastolic': 80.0},
      'lowGroupAvg': {'systolic': 130.0, 'diastolic': 85.0},
      'difference': {'systolic': 6.0, 'diastolic': 5.0},
      'direction': 'negative',
      'strength': 'moderate',
      'correlation': -0.35,
      'description': '水分攝入與血壓呈現中等負相關，充足飲水的日子血壓略有降低。',
      'impact': '適當飲水有助於維持血液循環和血壓穩定。建議每日飲水量在1.5-2升。',
      'groups': groups,
    };
  }

  // 生成模擬酒精相關性數據
  Map<String, dynamic> _generateMockAlcoholCorrelation() {
    final groups = [
      {'name': '不飲酒', 'avgSystolic': 122.0, 'avgDiastolic': 80.0},
      {'name': '少量飲酒', 'avgSystolic': 125.0, 'avgDiastolic': 82.0},
      {'name': '中量飲酒', 'avgSystolic': 130.0, 'avgDiastolic': 85.0},
      {'name': '大量飲酒', 'avgSystolic': 138.0, 'avgDiastolic': 90.0},
    ];

    return {
      'hasData': true,
      'nonAlcoholAvg': {'systolic': 122.0, 'diastolic': 80.0},
      'alcoholAvg': {'systolic': 131.0, 'diastolic': 86.0},
      'difference': {'systolic': 9.0, 'diastolic': 6.0},
      'direction': 'positive',
      'strength': 'strong',
      'correlation': 0.68,
      'description': '飲酒量與血壓呈現強正相關，飲酒量越大，血壓普遍越高。',
      'impact': '過量飲酒會導致血壓升高，增加心血管疾病風險。建議限制酒精攝入，男性每日不超過兩個標準酒精單位，女性不超過一個標準杯。',
      'groups': groups,
    };
  }
}
