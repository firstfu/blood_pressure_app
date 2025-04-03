// 血壓管家 App 常數檔案
// 定義應用程式中使用的常數

import 'package:flutter/material.dart';

class AppConstants {
  // 應用程式名稱
  static const String appName = '血壓管家';

  // 底部導航項目
  static const String homeTab = '首頁';
  static const String recordTab = '記錄';
  static const String statsTab = '統計';
  static const String profileTab = '個人';

  // 血壓分類標準 (mmHg)
  static const int normalSystolicMax = 120;
  static const int normalDiastolicMax = 80;
  static const int elevatedSystolicMax = 129;
  static const int elevatedDiastolicMax = 80;
  static const int hypertension1SystolicMax = 139;
  static const int hypertension1DiastolicMax = 89;
  static const int hypertension2SystolicMin = 140;
  static const int hypertension2DiastolicMin = 90;

  // 首頁文字
  static const String morningGreeting = '早安';
  static const String afternoonGreeting = '午安';
  static const String eveningGreeting = '晚安';
  static const String lastMeasurement = '最近一次測量';
  static const String todayNotMeasured = '今日尚未測量';
  static const String todayMeasured = '已完成今日測量';
  static const String weeklyTrend = '近 7 天趨勢';
  static const String twoWeeksTrend = '近 2 週趨勢';
  static const String monthlyTrend = '近 1 個月趨勢';
  static const String viewDetails = '查看詳情';
  static const String healthTips = '健康建議';
  static const String addRecord = '新增記錄';
  static const String viewReport = '查看報告';
  static const String setReminder = '設置提醒';

  // 血壓狀態文字
  static const String normalStatus = '正常';
  static const String elevatedStatus = '偏高';
  static const String hypertension1Status = '高血壓一級';
  static const String hypertension2Status = '高血壓二級';
  static const String hypertensionCrisisStatus = '高血壓危象';

  // 健康建議列表 - 使用鍵值而非完整文本，以便於翻譯
  static const List<String> healthTipsList = [
    '健康建議_低鹽飲食',
    '健康建議_規律運動',
    '健康建議_充足睡眠',
    '健康建議_戒菸限酒',
    '健康建議_體重控制',
    '健康建議_減少壓力',
    '健康建議_定期檢查',
    '健康建議_藥物遵從',
    '健康建議_飲食均衡',
    '健康建議_水分攝取',
  ];

  // OnBoarding 頁面文字
  static const String onBoardingSkip = '跳過';
  static const String onBoardingNext = '下一步';
  static const String onBoardingStart = '開始使用';

  // OnBoarding 頁面內容
  static const List<String> onBoardingTitles = ['歡迎使用血壓管家', '輕鬆記錄血壓數據', '專業分析健康趨勢', '貼心提醒不遺漏'];

  static const List<String> onBoardingDescriptions = [
    '您的個人血壓管理助手，幫助您更好地了解和管理血壓健康',
    '簡單快速地記錄您的血壓數據，支持手動輸入和智能設備同步',
    '智能分析您的血壓趨勢，提供專業的健康建議和風險評估',
    '設置測量提醒，確保您按時測量血壓，不錯過任何重要數據',
  ];

  static const List<String> onBoardingImages = [
    'assets/images/onboarding_welcome.png',
    'assets/images/onboarding_record.png',
    'assets/images/onboarding_analysis.png',
    'assets/images/onboarding_reminder.png',
  ];

  // 血壓狀態顏色
  static const Color highBloodPressureColor = Color(0xFFE57373);
  static const Color normalBloodPressureColor = Color(0xFF81C784);
  static const Color borderlineBloodPressureColor = Color(0xFFFFD54F);
  static const Color lowBloodPressureColor = Color(0xFF64B5F6);

  // 心率狀態顏色
  static const Color highPulseColor = Color(0xFFE57373);
  static const Color normalPulseColor = Color(0xFF81C784);
  static const Color lowPulseColor = Color(0xFF64B5F6);

  // 血壓分類閾值
  static const int highSystolicThreshold = 140;
  static const int highDiastolicThreshold = 90;
  static const int lowSystolicThreshold = 90;
  static const int lowDiastolicThreshold = 60;
  static const int borderlineSystolicThreshold = 130;
  static const int borderlineDiastolicThreshold = 85;

  // 心率分類閾值
  static const int highPulseThreshold = 100;
  static const int lowPulseThreshold = 60;

  // 應用商店連結
  static const String appStoreUrl = 'https://apps.apple.com/app/id123456789'; // 替換為實際的 App Store ID
  static const String googlePlayUrl = 'https://play.google.com/store/apps/details?id=com.example.bloodpressuremanager'; // 替換為實際的 Google Play 包名
  static const String appDescription = '一款幫助您監測和管理血壓的應用';

  // TODO: 未完成
  // 應用商店 ID，用於深層連結和分享
  static const String appStoreId = '123456789'; // 替換為實際的 App Store ID

  // 應用包名，用於 Google Play 連結
  static const String packageName = 'com.example.blood_pressure_app'; // 替換為實際的應用包名
}
