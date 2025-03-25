/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-26 14:25:30
 * @ Description: 血壓報告相關翻譯
 */

// 繁體中文報告翻譯
const Map<String, String> zhTWReport = {
  // 報告標題與頁眉頁腳
  '血壓健康報告': '血壓健康報告',
  '生成日期': '生成日期',
  '報告期間': '報告期間',
  '血壓管家 App': '血壓管家 App',
  '第': '第',
  '頁，共': '頁，共',
  '頁': '頁',

  // 統計摘要
  '血壓統計摘要': '血壓統計摘要',
  '平均收縮壓': '平均收縮壓',
  '平均舒張壓': '平均舒張壓',
  '平均心率': '平均心率',
  '最高收縮壓': '最高收縮壓',
  '最高舒張壓': '最高舒張壓',
  '最高心率': '最高心率',
  '最低收縮壓': '最低收縮壓',
  '最低舒張壓': '最低舒張壓',
  '最低心率': '最低心率',
  '記錄總數': '記錄總數',

  // 血壓分類
  '血壓分類統計': '血壓分類統計',

  // 健康建議
  '健康建議': '健康建議',
  '健康建議_低鹽飲食': '保持低鹽飲食，每日鹽攝取量控制在5-6克以下。',
  '健康建議_規律運動': '每週進行至少150分鐘的中等強度有氧運動。',
  '健康建議_充足睡眠': '保證每晚7-8小時的優質睡眠。',
  '健康建議_戒菸限酒': '避免吸菸，限制酒精攝入，男性每日不超過25克，女性不超過15克。',
  '健康建議_體重控制': '維持健康體重，BMI控制在18.5-24.9之間。',
  '健康建議_減少壓力': '學習壓力管理技巧，如冥想、深呼吸等。',
  '健康建議_定期檢查': '定期進行健康檢查，至少每年一次。',
  '健康建議_藥物遵從': '如有服用降壓藥，請嚴格按醫囑服用，不要自行停藥或調整劑量。',
  '健康建議_飲食均衡': '遵循均衡飲食，多攝取蔬果、全穀物和低脂蛋白質。',
  '健康建議_水分攝取': '保證充足水分攝取，每日約1.5-2升。',

  // 記錄詳情
  '血壓記錄詳情': '血壓記錄詳情',
  '測量時間': '測量時間',
  '收縮壓': '收縮壓',
  '舒張壓': '舒張壓',
  '心率': '心率',
  '備註': '備註',
  '測量姿勢': '測量姿勢',
  '測量部位': '測量部位',
  '是否服藥': '是否服藥',
  '血壓狀態': '血壓狀態',

  // 匯出報告
  '報告匯出成功': '報告匯出成功',
  '報告匯出失敗': '報告匯出失敗',
  '正在生成報告...': '正在生成報告...',
  '血壓記錄': '血壓記錄',
  '匯出為 PDF': '匯出為 PDF',
  '匯出為 CSV': '匯出為 CSV',
  '匯出為 Excel': '匯出為 Excel',
};

// 英文報告翻譯
const Map<String, String> enUSReport = {
  // 報告標題與頁眉頁腳
  '血壓健康報告': 'Blood Pressure Health Report',
  '生成日期': 'Generated Date',
  '報告期間': 'Report Period',
  '血壓管家 App': 'BP Manager App',
  '第': 'Page ',
  '頁，共': ' of ',
  '頁': '',

  // 統計摘要
  '血壓統計摘要': 'Blood Pressure Statistics Summary',
  '平均收縮壓': 'Avg. Systolic',
  '平均舒張壓': 'Avg. Diastolic',
  '平均心率': 'Avg. Pulse',
  '最高收縮壓': 'Max. Systolic',
  '最高舒張壓': 'Max. Diastolic',
  '最高心率': 'Max. Pulse',
  '最低收縮壓': 'Min. Systolic',
  '最低舒張壓': 'Min. Diastolic',
  '最低心率': 'Min. Pulse',
  '記錄總數': 'Total Records',

  // 血壓分類
  '血壓分類統計': 'Blood Pressure Category Statistics',

  // 健康建議
  '健康建議': 'Health Tips',
  '健康建議_低鹽飲食': 'Maintain a low-salt diet, limiting daily intake to less than 5-6g.',
  '健康建議_規律運動': 'Engage in at least 150 minutes of moderate aerobic exercise weekly.',
  '健康建議_充足睡眠': 'Ensure 7-8 hours of quality sleep each night.',
  '健康建議_戒菸限酒': 'Avoid smoking and limit alcohol consumption (men: <25g, women: <15g daily).',
  '健康建議_體重控制': 'Maintain a healthy weight with BMI between 18.5-24.9.',
  '健康建議_減少壓力': 'Learn stress management techniques like meditation and deep breathing.',
  '健康建議_定期檢查': 'Have regular health check-ups at least once a year.',
  '健康建議_藥物遵從': 'If taking antihypertensive medications, strictly follow your doctor\'s instructions.',
  '健康建議_飲食均衡': 'Follow a balanced diet rich in vegetables, fruits, whole grains, and low-fat proteins.',
  '健康建議_水分攝取': 'Ensure adequate water intake of approximately 1.5-2 liters daily.',

  // 記錄詳情
  '血壓記錄詳情': 'Blood Pressure Record Details',
  '測量時間': 'Measure Time',
  '收縮壓': 'Systolic',
  '舒張壓': 'Diastolic',
  '心率': 'Pulse',
  '備註': 'Note',
  '測量姿勢': 'Position',
  '測量部位': 'Arm',
  '是否服藥': 'Medicated',
  '血壓狀態': 'BP Status',

  // 匯出報告
  '報告匯出成功': 'Report Exported Successfully',
  '報告匯出失敗': 'Report Export Failed',
  '正在生成報告...': 'Generating Report...',
  '血壓記錄': 'BP Records',
  '匯出為 PDF': 'Export as PDF',
  '匯出為 CSV': 'Export as CSV',
  '匯出為 Excel': 'Export as Excel',
};
