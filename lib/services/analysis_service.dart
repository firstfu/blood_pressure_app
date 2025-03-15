/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 12:15:42
 * @ Description: 血壓記錄分析服務 - 提供血壓數據的深度分析功能
 */

import '../models/blood_pressure_record.dart';

class AnalysisService {
  // 服藥效果分析
  // 比較服藥前後的血壓變化
  static Map<String, dynamic> analyzeMedicationEffect(List<BloodPressureRecord> records) {
    if (records.isEmpty) {
      return {'hasData': false, 'message': '沒有足夠的數據進行分析'};
    }

    // 分離服藥和未服藥的記錄
    final medicatedRecords = records.where((record) => record.isMedicated).toList();
    final nonMedicatedRecords = records.where((record) => !record.isMedicated).toList();

    if (medicatedRecords.isEmpty || nonMedicatedRecords.isEmpty) {
      return {'hasData': false, 'message': '需要同時有服藥和未服藥的記錄才能進行比較'};
    }

    // 計算平均值
    final medicatedSystolicAvg = medicatedRecords.map((r) => r.systolic).reduce((a, b) => a + b) / medicatedRecords.length;
    final medicatedDiastolicAvg = medicatedRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / medicatedRecords.length;
    final medicatedPulseAvg = medicatedRecords.map((r) => r.pulse).reduce((a, b) => a + b) / medicatedRecords.length;

    final nonMedicatedSystolicAvg = nonMedicatedRecords.map((r) => r.systolic).reduce((a, b) => a + b) / nonMedicatedRecords.length;
    final nonMedicatedDiastolicAvg = nonMedicatedRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / nonMedicatedRecords.length;
    final nonMedicatedPulseAvg = nonMedicatedRecords.map((r) => r.pulse).reduce((a, b) => a + b) / nonMedicatedRecords.length;

    // 計算差異
    final systolicDiff = nonMedicatedSystolicAvg - medicatedSystolicAvg;
    final diastolicDiff = nonMedicatedDiastolicAvg - medicatedDiastolicAvg;
    final pulseDiff = nonMedicatedPulseAvg - medicatedPulseAvg;

    // 計算百分比變化
    final systolicPercentChange = (systolicDiff / nonMedicatedSystolicAvg) * 100;
    final diastolicPercentChange = (diastolicDiff / nonMedicatedDiastolicAvg) * 100;
    final pulsePercentChange = (pulseDiff / nonMedicatedPulseAvg) * 100;

    return {
      'hasData': true,
      'medicatedRecords': medicatedRecords,
      'nonMedicatedRecords': nonMedicatedRecords,
      'medicatedAvg': {'systolic': medicatedSystolicAvg, 'diastolic': medicatedDiastolicAvg, 'pulse': medicatedPulseAvg},
      'nonMedicatedAvg': {'systolic': nonMedicatedSystolicAvg, 'diastolic': nonMedicatedDiastolicAvg, 'pulse': nonMedicatedPulseAvg},
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff, 'pulse': pulseDiff},
      'percentChange': {'systolic': systolicPercentChange, 'diastolic': diastolicPercentChange, 'pulse': pulsePercentChange},
    };
  }

  // 測量條件分析
  // 分析不同測量條件下的血壓差異
  static Map<String, dynamic> analyzePositionArmEffect(List<BloodPressureRecord> records) {
    if (records.isEmpty) {
      return {'hasData': false, 'message': '沒有足夠的數據進行分析'};
    }

    // 按測量姿勢分組
    final sittingRecords = records.where((record) => record.position == '坐姿').toList();
    final lyingRecords = records.where((record) => record.position == '臥姿').toList();

    // 按測量部位分組
    final leftArmRecords = records.where((record) => record.arm == '左臂').toList();
    final rightArmRecords = records.where((record) => record.arm == '右臂').toList();

    // 檢查是否有足夠的數據進行比較
    final hasPositionData = sittingRecords.isNotEmpty && lyingRecords.isNotEmpty;
    final hasArmData = leftArmRecords.isNotEmpty && rightArmRecords.isNotEmpty;

    if (!hasPositionData && !hasArmData) {
      return {'hasData': false, 'message': '需要不同測量條件的記錄才能進行比較'};
    }

    // 計算姿勢差異
    Map<String, dynamic> positionAnalysis = {};
    if (hasPositionData) {
      final sittingSystolicAvg = sittingRecords.map((r) => r.systolic).reduce((a, b) => a + b) / sittingRecords.length;
      final sittingDiastolicAvg = sittingRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / sittingRecords.length;

      final lyingSystolicAvg = lyingRecords.map((r) => r.systolic).reduce((a, b) => a + b) / lyingRecords.length;
      final lyingDiastolicAvg = lyingRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / lyingRecords.length;

      positionAnalysis = {
        'hasData': true,
        'sitting': {'systolic': sittingSystolicAvg, 'diastolic': sittingDiastolicAvg, 'count': sittingRecords.length},
        'lying': {'systolic': lyingSystolicAvg, 'diastolic': lyingDiastolicAvg, 'count': lyingRecords.length},
        'difference': {'systolic': sittingSystolicAvg - lyingSystolicAvg, 'diastolic': sittingDiastolicAvg - lyingDiastolicAvg},
      };
    }

    // 計算測量部位差異
    Map<String, dynamic> armAnalysis = {};
    if (hasArmData) {
      final leftSystolicAvg = leftArmRecords.map((r) => r.systolic).reduce((a, b) => a + b) / leftArmRecords.length;
      final leftDiastolicAvg = leftArmRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / leftArmRecords.length;

      final rightSystolicAvg = rightArmRecords.map((r) => r.systolic).reduce((a, b) => a + b) / rightArmRecords.length;
      final rightDiastolicAvg = rightArmRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / rightArmRecords.length;

      armAnalysis = {
        'hasData': true,
        'leftArm': {'systolic': leftSystolicAvg, 'diastolic': leftDiastolicAvg, 'count': leftArmRecords.length},
        'rightArm': {'systolic': rightSystolicAvg, 'diastolic': rightDiastolicAvg, 'count': rightArmRecords.length},
        'difference': {'systolic': leftSystolicAvg - rightSystolicAvg, 'diastolic': leftDiastolicAvg - rightDiastolicAvg},
      };
    }

    return {'hasData': true, 'positionAnalysis': positionAnalysis, 'armAnalysis': armAnalysis};
  }

  // 晨峰血壓分析
  // 分析早晨和晚上的血壓差異
  static Map<String, dynamic> analyzeMorningEveningEffect(List<BloodPressureRecord> records) {
    if (records.isEmpty) {
      return {'hasData': false, 'message': '沒有足夠的數據進行分析'};
    }

    // 將記錄分為早晨和晚上
    final morningRecords =
        records.where((record) {
          final hour = record.measureTime.hour;
          return hour >= 4 && hour < 10; // 早上4點到10點
        }).toList();

    final eveningRecords =
        records.where((record) {
          final hour = record.measureTime.hour;
          return hour >= 18 && hour < 24; // 晚上6點到12點
        }).toList();

    if (morningRecords.isEmpty || eveningRecords.isEmpty) {
      return {'hasData': false, 'message': '需要同時有早晨和晚上的測量記錄才能進行比較'};
    }

    // 計算早晨平均值
    final morningSystolicAvg = morningRecords.map((r) => r.systolic).reduce((a, b) => a + b) / morningRecords.length;
    final morningDiastolicAvg = morningRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / morningRecords.length;
    final morningPulseAvg = morningRecords.map((r) => r.pulse).reduce((a, b) => a + b) / morningRecords.length;

    // 計算晚上平均值
    final eveningSystolicAvg = eveningRecords.map((r) => r.systolic).reduce((a, b) => a + b) / eveningRecords.length;
    final eveningDiastolicAvg = eveningRecords.map((r) => r.diastolic).reduce((a, b) => a + b) / eveningRecords.length;
    final eveningPulseAvg = eveningRecords.map((r) => r.pulse).reduce((a, b) => a + b) / eveningRecords.length;

    // 計算晨峰指數（早晨/晚上的比值）
    final morningEveningSystolicRatio = morningSystolicAvg / eveningSystolicAvg;
    final morningEveningDiastolicRatio = morningDiastolicAvg / eveningDiastolicAvg;

    // 計算差異
    final systolicDiff = morningSystolicAvg - eveningSystolicAvg;
    final diastolicDiff = morningDiastolicAvg - eveningDiastolicAvg;
    final pulseDiff = morningPulseAvg - eveningPulseAvg;

    return {
      'hasData': true,
      'morningRecords': morningRecords,
      'eveningRecords': eveningRecords,
      'morningAvg': {'systolic': morningSystolicAvg, 'diastolic': morningDiastolicAvg, 'pulse': morningPulseAvg},
      'eveningAvg': {'systolic': eveningSystolicAvg, 'diastolic': eveningDiastolicAvg, 'pulse': eveningPulseAvg},
      'difference': {'systolic': systolicDiff, 'diastolic': diastolicDiff, 'pulse': pulseDiff},
      'morningEveningRatio': {'systolic': morningEveningSystolicRatio, 'diastolic': morningEveningDiastolicRatio},
      'hasMorningHypertension': morningEveningSystolicRatio > 1.15 || morningEveningDiastolicRatio > 1.15,
    };
  }
}
