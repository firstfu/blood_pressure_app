// 血壓記錄 App 血壓記錄模型類
// 定義血壓記錄的數據結構

import '../constants/app_constants.dart';

class BloodPressureRecord {
  final String id;
  final int systolic; // 收縮壓
  final int diastolic; // 舒張壓
  final int pulse; // 心率
  final DateTime measureTime; // 測量時間
  final String position; // 測量姿勢：坐姿/臥姿
  final String arm; // 測量部位：左臂/右臂
  final String? note; // 備註
  final bool isMedicated; // 是否服藥

  BloodPressureRecord({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.measureTime,
    required this.position,
    required this.arm,
    this.note,
    this.isMedicated = false,
  });

  // 從 JSON 創建記錄
  factory BloodPressureRecord.fromJson(Map<String, dynamic> json) {
    return BloodPressureRecord(
      id: json['id'],
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      pulse: json['pulse'],
      measureTime: DateTime.parse(json['measureTime']),
      position: json['position'],
      arm: json['arm'],
      note: json['note'],
      isMedicated: json['isMedicated'] ?? false,
    );
  }

  // 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'measureTime': measureTime.toIso8601String(),
      'position': position,
      'arm': arm,
      'note': note,
      'isMedicated': isMedicated,
    };
  }

  // 獲取血壓狀態
  String getBloodPressureStatus() {
    if (systolic < AppConstants.normalSystolicMax && diastolic < AppConstants.normalDiastolicMax) {
      return AppConstants.normalStatus;
    } else if (systolic <= AppConstants.elevatedSystolicMax && diastolic <= AppConstants.elevatedDiastolicMax) {
      return AppConstants.elevatedStatus;
    } else if (systolic <= AppConstants.hypertension1SystolicMax || diastolic <= AppConstants.hypertension1DiastolicMax) {
      return AppConstants.hypertension1Status;
    } else if (systolic >= AppConstants.hypertension2SystolicMin || diastolic >= AppConstants.hypertension2DiastolicMin) {
      return AppConstants.hypertension2Status;
    } else if (systolic >= 180 || diastolic >= 120) {
      return AppConstants.hypertensionCrisisStatus;
    } else {
      return AppConstants.normalStatus;
    }
  }

  // 獲取血壓狀態對應的顏色代碼
  int getStatusColorCode() {
    final status = getBloodPressureStatus();

    if (status == AppConstants.normalStatus) {
      return 0xFF43A047; // 綠色
    } else if (status == AppConstants.elevatedStatus) {
      return 0xFFFB8C00; // 橙色
    } else if (status == AppConstants.hypertension1Status) {
      return 0xFFE53935; // 紅色
    } else if (status == AppConstants.hypertension2Status) {
      return 0xFFD32F2F; // 深紅色
    } else {
      return 0xFFB71C1C; // 更深的紅色
    }
  }
}
