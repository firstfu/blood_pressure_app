/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 10:25:10
 * @ Description: 血壓記錄 App 統計工具類 - 提供統計計算相關功能
 */

import 'package:flutter/material.dart';
import '../models/blood_pressure_record.dart';
import '../widgets/filter_sort_panel.dart';

class StatsUtils {
  // 計算統計數據
  static Map<String, double> calculateStatistics(List<BloodPressureRecord> records) {
    if (records.isEmpty) {
      return {
        'avgSystolic': 0,
        'avgDiastolic': 0,
        'avgPulse': 0,
        'maxSystolic': 0,
        'minSystolic': 0,
        'maxDiastolic': 0,
        'minDiastolic': 0,
        'maxPulse': 0,
        'minPulse': 0,
      };
    }

    int totalSystolic = 0;
    int totalDiastolic = 0;
    int totalPulse = 0;
    int maxSystolic = records[0].systolic;
    int minSystolic = records[0].systolic;
    int maxDiastolic = records[0].diastolic;
    int minDiastolic = records[0].diastolic;
    int maxPulse = records[0].pulse;
    int minPulse = records[0].pulse;

    for (final record in records) {
      totalSystolic += record.systolic;
      totalDiastolic += record.diastolic;
      totalPulse += record.pulse;

      if (record.systolic > maxSystolic) maxSystolic = record.systolic;
      if (record.systolic < minSystolic) minSystolic = record.systolic;
      if (record.diastolic > maxDiastolic) maxDiastolic = record.diastolic;
      if (record.diastolic < minDiastolic) minDiastolic = record.diastolic;
      if (record.pulse > maxPulse) maxPulse = record.pulse;
      if (record.pulse < minPulse) minPulse = record.pulse;
    }

    return {
      'avgSystolic': totalSystolic / records.length,
      'avgDiastolic': totalDiastolic / records.length,
      'avgPulse': totalPulse / records.length,
      'maxSystolic': maxSystolic.toDouble(),
      'minSystolic': minSystolic.toDouble(),
      'maxDiastolic': maxDiastolic.toDouble(),
      'minDiastolic': minDiastolic.toDouble(),
      'maxPulse': maxPulse.toDouble(),
      'minPulse': minPulse.toDouble(),
    };
  }

  // 計算血壓分類統計
  static Map<String, int> calculateCategoryCounts(List<BloodPressureRecord> records) {
    final Map<String, int> categoryCounts = {};

    for (final record in records) {
      final status = record.getBloodPressureStatus();
      categoryCounts[status] = (categoryCounts[status] ?? 0) + 1;
    }

    return categoryCounts;
  }

  // 獲取心率狀態顏色代碼
  static String getPulseStatusCode(int pulse) {
    if (pulse < 60) {
      return 'low'; // 心率過低
    } else if (pulse > 100) {
      return 'high'; // 心率過高
    } else {
      return 'normal'; // 心率正常
    }
  }

  // 應用篩選和排序
  static List<BloodPressureRecord> applyFiltersAndSort({
    required List<BloodPressureRecord> records,
    required RangeValues systolicRange,
    required RangeValues diastolicRange,
    required RangeValues pulseRange,
    required SortField sortField,
    required SortOrder sortOrder,
  }) {
    // 應用篩選條件
    final filteredRecords =
        records.where((record) {
          return record.systolic >= systolicRange.start &&
              record.systolic <= systolicRange.end &&
              record.diastolic >= diastolicRange.start &&
              record.diastolic <= diastolicRange.end &&
              record.pulse >= pulseRange.start &&
              record.pulse <= pulseRange.end;
        }).toList();

    // 應用排序
    filteredRecords.sort((a, b) {
      int comparison;
      switch (sortField) {
        case SortField.time:
          comparison = a.measureTime.compareTo(b.measureTime);
          break;
        case SortField.systolic:
          comparison = a.systolic.compareTo(b.systolic);
          break;
        case SortField.diastolic:
          comparison = a.diastolic.compareTo(b.diastolic);
          break;
        case SortField.pulse:
          comparison = a.pulse.compareTo(b.pulse);
          break;
      }
      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return filteredRecords;
  }
}
