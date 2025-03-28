/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 16:45:30
 * @ Description: 血壓記錄服務 - 提供獲取和管理血壓記錄的功能
 */

import 'package:flutter/material.dart';
import '../models/blood_pressure_record.dart';
import '../constants/auth_constants.dart';
import '../utils/permission_handler.dart';

class RecordService extends ChangeNotifier {
  List<BloodPressureRecord> _records = [];
  bool _isLoading = false;
  BuildContext? _context;

  bool get isLoading => _isLoading;
  List<BloodPressureRecord> get records => _records;

  // 設置上下文，用於顯示登入彈窗
  void setContext(BuildContext context) {
    _context = context;
  }

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

  // 添加血壓記錄 (需要權限檢查)
  Future<bool> addRecord(BloodPressureRecord record) async {
    if (_context == null) {
      debugPrint('無法進行權限檢查：缺少上下文');
      return false;
    }

    // 使用 PermissionHandler 檢查添加記錄的權限
    return PermissionHandler.performProtectedOperation(_context!, OperationType.addRecord, () async {
      _records.add(record);
      // 在實際應用中，這裡應該將記錄保存到數據庫
      notifyListeners();
      return true;
    }, customMessage: '登入後才能添加血壓記錄').then((result) => result ?? false);
  }

  // 更新血壓記錄 (需要權限檢查)
  Future<bool> updateRecord(BloodPressureRecord record) async {
    if (_context == null) {
      debugPrint('無法進行權限檢查：缺少上下文');
      return false;
    }

    // 使用 PermissionHandler 檢查編輯記錄的權限
    return PermissionHandler.performProtectedOperation(_context!, OperationType.editRecord, () async {
      final index = _records.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _records[index] = record;
        // 在實際應用中，這裡應該更新數據庫中的記錄
        notifyListeners();
        return true;
      }
      return false;
    }, customMessage: '登入後才能更新血壓記錄').then((result) => result ?? false);
  }

  // 刪除血壓記錄 (需要權限檢查)
  Future<bool> deleteRecord(String id) async {
    if (_context == null) {
      debugPrint('無法進行權限檢查：缺少上下文');
      return false;
    }

    // 使用 PermissionHandler 檢查刪除記錄的權限
    return PermissionHandler.performProtectedOperation(_context!, OperationType.deleteRecord, () async {
      _records.removeWhere((record) => record.id == id);
      // 在實際應用中，這裡應該從數據庫中刪除記錄
      notifyListeners();
      return true;
    }, customMessage: '登入後才能刪除血壓記錄').then((result) => result ?? false);
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

      // 生成生活習慣標籤
      String note = '';

      // 運動標籤 - 確保有足夠的運動相關記錄
      if (i % 3 == 0) {
        note = '早晨測量，運動後';
        // 運動後血壓略低
        baseSystolic -= 5;
        baseDiastolic -= 3;
      } else if (i % 7 == 0) {
        note = '早晨測量，睡眠充足';
      } else if (i % 7 == 1) {
        note = '早晨測量，睡眠不足';
        // 睡眠不足血壓略高
        baseSystolic += 4;
        baseDiastolic += 2;
      } else if (i % 7 == 2) {
        note = '早晨測量，低鹽飲食';
        // 低鹽飲食血壓略低
        baseSystolic -= 3;
        baseDiastolic -= 2;
      } else if (i % 7 == 3) {
        note = '早晨測量，高鹽飲食';
        // 高鹽飲食血壓略高
        baseSystolic += 5;
        baseDiastolic += 3;
      } else if (i % 7 == 4) {
        note = '早晨測量，壓力大';
        // 壓力大血壓略高
        baseSystolic += 6;
        baseDiastolic += 4;
      } else if (i % 7 == 5) {
        note = '早晨測量，放鬆';
        // 放鬆時血壓略低
        baseSystolic -= 2;
        baseDiastolic -= 1;
      } else if (i % 7 == 6) {
        note = '早晨測量，飲水充足';
        // 飲水充足血壓略低
        baseSystolic -= 1;
        baseDiastolic -= 1;
      }

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
          note: note,
          isMedicated: i % 7 == 0,
        ),
      );

      // 為部分日期添加第二次測量（晚上）
      if (i % 2 == 0) {
        final eveningMeasureTime = DateTime(date.year, date.month, date.day, 20, 0);
        final eveningSystolic = systolic + 5 + (date.second % 5);
        final eveningDiastolic = diastolic + 3 + (date.second % 3);
        final eveningPulse = pulse + 5 + (date.second % 5);

        // 生成晚上的生活習慣標籤
        String eveningNote = '';

        if (i % 4 == 0) {
          eveningNote = '晚上測量，運動後';
          // 運動後血壓略低
          baseSystolic -= 5;
          baseDiastolic -= 3;
        } else if (i % 4 == 1) {
          eveningNote = '晚上測量，飲酒';
          // 飲酒後血壓略高
          baseSystolic += 4;
          baseDiastolic += 2;
        } else if (i % 4 == 2) {
          eveningNote = '晚上測量，飲水不足';
          // 飲水不足血壓略高
          baseSystolic += 2;
          baseDiastolic += 1;
        } else {
          eveningNote = '晚上測量';
        }

        mockRecords.add(
          BloodPressureRecord(
            id: 'mock_${eveningMeasureTime.millisecondsSinceEpoch}',
            systolic: eveningSystolic,
            diastolic: eveningDiastolic,
            pulse: eveningPulse,
            measureTime: eveningMeasureTime,
            position: i % 2 == 0 ? '坐姿' : '臥姿',
            arm: i % 3 == 0 ? '左臂' : '右臂',
            note: eveningNote,
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
