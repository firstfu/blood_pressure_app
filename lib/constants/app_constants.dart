// 血壓管家 App 常數檔案
// 定義應用程式中使用的常數

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

  // 健康建議文字
  static const List<String> healthTipsList = [
    '保持規律測量，每天固定時間測量血壓',
    '適量運動有助於控制血壓，每天30分鐘中等強度運動',
    '減少鹽分攝入，每日鹽分攝入量控制在5克以下',
    '保持健康體重，減輕體重有助於降低血壓',
    '戒煙限酒，吸煙和過量飲酒會升高血壓',
    '保持心情愉快，壓力是血壓升高的重要因素',
    '規律作息，保證充足睡眠有助於血壓穩定',
    '按時服藥，遵醫囑定期複診',
  ];
}
