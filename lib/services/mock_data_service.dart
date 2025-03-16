// 血壓管家 App 模擬數據服務
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
      // 添加更多模擬數據用於2週和1個月的顯示
      BloodPressureRecord(
        id: '8',
        systolic: 126,
        diastolic: 81,
        pulse: 75,
        measureTime: now.subtract(const Duration(days: 8, hours: 5)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '9',
        systolic: 132,
        diastolic: 86,
        pulse: 79,
        measureTime: now.subtract(const Duration(days: 10, hours: 4)),
        position: '坐姿',
        arm: '右臂',
        note: '壓力大',
      ),
      BloodPressureRecord(
        id: '10',
        systolic: 124,
        diastolic: 80,
        pulse: 73,
        measureTime: now.subtract(const Duration(days: 12, hours: 7)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '11',
        systolic: 129,
        diastolic: 84,
        pulse: 76,
        measureTime: now.subtract(const Duration(days: 14, hours: 3)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '12',
        systolic: 133,
        diastolic: 87,
        pulse: 80,
        measureTime: now.subtract(const Duration(days: 16, hours: 6)),
        position: '坐姿',
        arm: '右臂',
        isMedicated: true,
      ),
      BloodPressureRecord(
        id: '13',
        systolic: 127,
        diastolic: 82,
        pulse: 74,
        measureTime: now.subtract(const Duration(days: 18, hours: 5)),
        position: '臥姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '14',
        systolic: 131,
        diastolic: 85,
        pulse: 77,
        measureTime: now.subtract(const Duration(days: 20, hours: 4)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '15',
        systolic: 123,
        diastolic: 79,
        pulse: 72,
        measureTime: now.subtract(const Duration(days: 22, hours: 8)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '16',
        systolic: 136,
        diastolic: 88,
        pulse: 81,
        measureTime: now.subtract(const Duration(days: 24, hours: 3)),
        position: '坐姿',
        arm: '右臂',
        note: '感冒中',
      ),
      BloodPressureRecord(
        id: '17',
        systolic: 125,
        diastolic: 80,
        pulse: 75,
        measureTime: now.subtract(const Duration(days: 26, hours: 6)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '18',
        systolic: 130,
        diastolic: 84,
        pulse: 78,
        measureTime: now.subtract(const Duration(days: 28, hours: 5)),
        position: '坐姿',
        arm: '左臂',
      ),
      BloodPressureRecord(
        id: '19',
        systolic: 128,
        diastolic: 83,
        pulse: 76,
        measureTime: now.subtract(const Duration(days: 29, hours: 7)),
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

  // 獲取最近 14 天的血壓記錄
  static List<BloodPressureRecord> getLast14DaysRecords() {
    final records = getMockBloodPressureRecords();
    final now = DateTime.now();
    final fourteenDaysAgo = now.subtract(const Duration(days: 14));

    return records.where((record) => record.measureTime.isAfter(fourteenDaysAgo)).toList();
  }

  // 獲取最近 30 天的血壓記錄
  static List<BloodPressureRecord> getLast30DaysRecords() {
    final records = getMockBloodPressureRecords();
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    return records.where((record) => record.measureTime.isAfter(thirtyDaysAgo)).toList();
  }

  // 根據時間範圍獲取血壓記錄
  static List<BloodPressureRecord> getRecordsByTimeRange(TimeRange timeRange) {
    switch (timeRange) {
      case TimeRange.week:
        return getLast7DaysRecords();
      case TimeRange.twoWeeks:
        return getLast14DaysRecords();
      case TimeRange.month:
        return getLast30DaysRecords();
      case TimeRange.custom:
        // 自定義日期範圍使用 getRecordsByDateRange 方法
        return getMockBloodPressureRecords(); // 預設返回所有記錄
    }
  }

  // 根據自定義日期範圍獲取血壓記錄
  static List<BloodPressureRecord> getRecordsByDateRange(DateTime startDate, DateTime endDate) {
    final records = getMockBloodPressureRecords();

    // 確保日期範圍的開始和結束時間是當天的 00:00:00 和 23:59:59
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return records.where((record) {
      return record.measureTime.isAfter(start) && record.measureTime.isBefore(end) ||
          record.measureTime.isAtSameMomentAs(start) ||
          record.measureTime.isAtSameMomentAs(end);
    }).toList();
  }

  // 獲取所有血壓記錄
  static List<BloodPressureRecord> getAllRecords() {
    // 在實際應用中，這裡會從資料庫中獲取所有記錄
    // 這裡為了演示，我們返回所有模擬數據
    return getMockBloodPressureRecords();
  }
}

// 時間範圍枚舉
enum TimeRange {
  week, // 7天
  twoWeeks, // 14天
  month, // 30天
  custom, // 自定義日期範圍
}

// 添加以下方法到 MockDataService 類中
extension MockDataServiceExtension on MockDataService {
  // 添加新的血壓記錄
  static void addBloodPressureRecord(BloodPressureRecord record) {
    // 在實際應用中，這裡會將記錄保存到數據庫或雲端
    // 在模擬服務中，我們可以將其添加到靜態列表中
    // 但由於這是模擬數據，我們這裡不做實際的添加操作
    // print('添加新記錄: ${record.toJson()}');
  }

  // 更新現有的血壓記錄
  static void updateBloodPressureRecord(BloodPressureRecord record) {
    // 在實際應用中，這裡會更新數據庫或雲端中的記錄
    // 在模擬服務中，我們可以更新靜態列表中的記錄
    // 但由於這是模擬數據，我們這裡不做實際的更新操作
    // print('更新記錄: ${record.toJson()}');
  }
}
