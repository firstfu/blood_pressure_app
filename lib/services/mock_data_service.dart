// 血壓記錄 App 模擬數據服務
// 提供測試數據

import '../models/blood_pressure_record.dart';

class MockDataService {
  // 獲取模擬的血壓記錄列表
  static List<BloodPressureRecord> getMockBloodPressureRecords() {
    final now = DateTime.now();

    return [
      BloodPressureRecord(
        id: '1',
        systolic: 120,
        diastolic: 80,
        pulse: 75,
        measureTime: now.subtract(const Duration(hours: 2)),
        position: '坐姿',
        arm: '左臂',
        note: '飯後測量',
      ),
      BloodPressureRecord(
        id: '2',
        systolic: 118,
        diastolic: 78,
        pulse: 72,
        measureTime: now.subtract(const Duration(days: 1, hours: 8)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '3',
        systolic: 135,
        diastolic: 85,
        pulse: 80,
        measureTime: now.subtract(const Duration(days: 2, hours: 4)),
        position: '坐姿',
        arm: '右臂',
        note: '運動後測量',
      ),
      BloodPressureRecord(
        id: '4',
        systolic: 125,
        diastolic: 82,
        pulse: 76,
        measureTime: now.subtract(const Duration(days: 3, hours: 6)),
        position: '臥姿',
        arm: '左臂',
        isMedicated: true,
      ),
      BloodPressureRecord(
        id: '5',
        systolic: 130,
        diastolic: 85,
        pulse: 78,
        measureTime: now.subtract(const Duration(days: 4, hours: 2)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '6',
        systolic: 122,
        diastolic: 79,
        pulse: 74,
        measureTime: now.subtract(const Duration(days: 5, hours: 5)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '7',
        systolic: 128,
        diastolic: 83,
        pulse: 77,
        measureTime: now.subtract(const Duration(days: 6, hours: 3)),
        position: '坐姿',
        arm: '右臂',
      ),
    ];
  }

  // 獲取最近一次血壓記錄
  static BloodPressureRecord? getLastBloodPressureRecord() {
    final records = getMockBloodPressureRecords();
    if (records.isNotEmpty) {
      return records.first;
    }
    return null;
  }

  // 獲取今日是否已測量
  static bool isMeasuredToday() {
    final records = getMockBloodPressureRecords();
    if (records.isEmpty) {
      return false;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastMeasureDate = DateTime(records.first.measureTime.year, records.first.measureTime.month, records.first.measureTime.day);

    return today.isAtSameMomentAs(lastMeasureDate);
  }

  // 獲取最近 7 天的血壓記錄
  static List<BloodPressureRecord> getLast7DaysRecords() {
    final records = getMockBloodPressureRecords();
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return records.where((record) => record.measureTime.isAfter(sevenDaysAgo)).toList();
  }
}
