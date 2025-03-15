/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 16:45:30
 * @ Description: 血壓記錄服務 - 提供獲取和管理血壓記錄的功能
 */

import 'package:flutter/material.dart';
import '../models/blood_pressure_record.dart';

class RecordService extends ChangeNotifier {
  List<BloodPressureRecord> _records = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<BloodPressureRecord> get records => _records;

  // 獲取所有血壓記錄
  Future<List<BloodPressureRecord>> getRecords() async {
    if (_records.isEmpty) {
      await _loadRecords();
    }
    return _records;
  }

  // 加載血壓記錄
  Future<void> _loadRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 在實際應用中，這裡應該從數據庫或API獲取數據
      // 這裡使用模擬數據進行演示
      await Future.delayed(const Duration(milliseconds: 500));
      _records = _getMockBloodPressureRecords();
    } catch (e) {
      // 處理錯誤
      debugPrint('加載血壓記錄時發生錯誤: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 添加血壓記錄
  Future<void> addRecord(BloodPressureRecord record) async {
    _records.add(record);
    // 在實際應用中，這裡應該將記錄保存到數據庫
    notifyListeners();
  }

  // 更新血壓記錄
  Future<void> updateRecord(BloodPressureRecord record) async {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _records[index] = record;
      // 在實際應用中，這裡應該更新數據庫中的記錄
      notifyListeners();
    }
  }

  // 刪除血壓記錄
  Future<void> deleteRecord(String id) async {
    _records.removeWhere((record) => record.id == id);
    // 在實際應用中，這裡應該從數據庫中刪除記錄
    notifyListeners();
  }

  // 生成模擬血壓記錄數據
  List<BloodPressureRecord> _getMockBloodPressureRecords() {
    final List<BloodPressureRecord> mockRecords = [];
    final now = DateTime.now();

    // 生成過去30天的記錄
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));

      // 基礎血壓值
      int baseSystolic = 120;
      int baseDiastolic = 80;

      // 添加一些變化
      final dayVariation = (date.day % 5) * 2;
      final randomVariation = (date.millisecond % 10) - 5;

      // 計算最終血壓值
      final systolic = baseSystolic + dayVariation + randomVariation;
      final diastolic = baseDiastolic + (dayVariation / 2).round() + randomVariation;

      // 脈搏
      final pulse = 70 + (date.day % 10);

      // 測量時間
      final measureTime = DateTime(date.year, date.month, date.day, 8, 0);

      // 生成記錄
      mockRecords.add(
        BloodPressureRecord(
          id: 'mock_${measureTime.millisecondsSinceEpoch}',
          systolic: systolic,
          diastolic: diastolic,
          pulse: pulse,
          measureTime: measureTime,
          position: i % 2 == 0 ? '坐姿' : '臥姿',
          arm: i % 3 == 0 ? '左臂' : '右臂',
          note: i % 5 == 0 ? '早晨測量' : '',
          isMedicated: i % 7 == 0,
        ),
      );

      // 為部分日期添加第二次測量（晚上）
      if (i % 2 == 0) {
        final eveningMeasureTime = DateTime(date.year, date.month, date.day, 20, 0);
        final eveningSystolic = systolic + 5 + (date.second % 5);
        final eveningDiastolic = diastolic + 3 + (date.second % 3);
        final eveningPulse = pulse + 5 + (date.second % 5);

        mockRecords.add(
          BloodPressureRecord(
            id: 'mock_${eveningMeasureTime.millisecondsSinceEpoch}',
            systolic: eveningSystolic,
            diastolic: eveningDiastolic,
            pulse: eveningPulse,
            measureTime: eveningMeasureTime,
            position: i % 2 == 0 ? '坐姿' : '臥姿',
            arm: i % 3 == 0 ? '左臂' : '右臂',
            note: '晚上測量',
            isMedicated: i % 5 == 0,
          ),
        );
      }
    }

    // 按測量時間排序
    mockRecords.sort((a, b) => b.measureTime.compareTo(a.measureTime));

    return mockRecords;
  }
}
