// @ Author: firstfu
// @ Create Time: 2024-05-24 22:17:56
// @ Description: 記錄頁面詞彙多語系翻譯

// 繁體中文記錄頁面詞彙
const Map<String, String> zhTWRecord = {
  // 血壓記錄
  '血壓記錄': '血壓記錄',
  '收縮壓': '收縮壓',
  '舒張壓': '舒張壓',
  '心率': '心率',
  '新增記錄': '新增記錄',
  '編輯記錄': '編輯記錄',
  '刪除記錄': '刪除記錄',
  '確定要刪除此記錄嗎？': '確定要刪除此記錄嗎？',
  '記錄時間': '記錄時間',
  '備註': '備註',

  // 測量條件
  '坐姿': '坐姿',
  '臥姿': '臥姿',
  '站姿': '站姿',
  '左臂': '左臂',
  '右臂': '右臂',
  '測量姿勢': '測量姿勢',
  '測量部位': '測量部位',
  '測量條件': '測量條件',
  '是否服藥': '是否服藥',
  '測量前是否服用降壓藥物': '測量前是否服用降壓藥物',

  // 血壓記錄表單
  '血壓狀態預覽': '血壓狀態預覽',
  '血壓數值': '血壓數值',
  '測量時間': '測量時間',
  '請輸入收縮壓': '請輸入收縮壓',
  '請輸入舒張壓': '請輸入舒張壓',
  '請輸入心率': '請輸入心率',
  '收縮壓應在60-250之間': '收縮壓應在60-250之間',
  '舒張壓應在40-150之間': '舒張壓應在40-150之間',
  '心率應在40-200之間': '心率應在40-200之間',
  '備註（選填）': '備註（選填）',
  '例如：飯後測量、運動後測量等': '例如：飯後測量、運動後測量等',
  '記錄已保存': '記錄已保存',
  '記錄已更新': '記錄已更新',
  '保存記錄': '保存記錄',

  // 血壓狀態評估
  '您的血壓處於正常範圍，繼續保持健康的生活方式。': '您的血壓處於正常範圍，繼續保持健康的生活方式。',
  '您的血壓略高於正常範圍，建議增加運動並減少鹽分攝入。': '您的血壓略高於正常範圍，建議增加運動並減少鹽分攝入。',
  '您的血壓處於高血壓一級，建議諮詢醫生並調整生活方式。': '您的血壓處於高血壓一級，建議諮詢醫生並調整生活方式。',
  '您的血壓處於高血壓二級，請盡快諮詢醫生並遵循治療方案。': '您的血壓處於高血壓二級，請盡快諮詢醫生並遵循治療方案。',
  '您的血壓處於危險水平，請立即就醫！': '您的血壓處於危險水平，請立即就醫！',
  '高血壓一級': '高血壓一級',
  '高血壓二級': '高血壓二級',
  '高血壓危象': '高血壓危象',
};

// 英文記錄頁面詞彙
const Map<String, String> enUSRecord = {
  // 血壓記錄
  '血壓記錄': 'BP Records',
  '收縮壓': 'Systolic',
  '舒張壓': 'Diastolic',
  '心率': 'Pulse',
  '新增記錄': 'Add Record',
  '編輯記錄': 'Edit Record',
  '刪除記錄': 'Delete Record',
  '確定要刪除此記錄嗎？': 'Are you sure you want to delete this record?',
  '記錄時間': 'Record Time',
  '備註': 'Notes',

  // 測量條件
  '坐姿': 'Sitting',
  '臥姿': 'Lying Down',
  '站姿': 'Standing',
  '左臂': 'Left Arm',
  '右臂': 'Right Arm',
  '測量姿勢': 'Position',
  '測量部位': 'Measurement Site',
  '測量條件': 'Measurement Conditions',
  '是否服藥': 'Medication Taken',
  '測量前是否服用降壓藥物': 'BP medication taken before measurement',

  // 血壓記錄表單
  '血壓狀態預覽': 'BP Status Preview',
  '血壓數值': 'BP Values',
  '測量時間': 'Measurement Time',
  '請輸入收縮壓': 'Enter Systolic Pressure',
  '請輸入舒張壓': 'Enter Diastolic Pressure',
  '請輸入心率': 'Enter Pulse Rate',
  '收縮壓應在60-250之間': 'Systolic should be between 60-250',
  '舒張壓應在40-150之間': 'Diastolic should be between 40-150',
  '心率應在40-200之間': 'Pulse should be between 40-200',
  '備註（選填）': 'Notes (Optional)',
  '例如：飯後測量、運動後測量等': 'E.g., after meal, after exercise, etc.',
  '記錄已保存': 'Record Saved',
  '記錄已更新': 'Record Updated',
  '保存記錄': 'Save Record',

  // 血壓狀態評估
  '您的血壓處於正常範圍，繼續保持健康的生活方式。': 'Your blood pressure is within normal range. Continue to maintain a healthy lifestyle.',
  '您的血壓略高於正常範圍，建議增加運動並減少鹽分攝入。': 'Your blood pressure is slightly above normal. Consider increasing exercise and reducing salt intake.',
  '您的血壓處於高血壓一級，建議諮詢醫生並調整生活方式。': 'Your blood pressure is at Stage 1 Hypertension. Please consult a doctor and adjust your lifestyle.',
  '您的血壓處於高血壓二級，請盡快諮詢醫生並遵循治療方案。': 'Your blood pressure is at Stage 2 Hypertension. Please consult a doctor soon and follow treatment plan.',
  '您的血壓處於危險水平，請立即就醫！': 'Your blood pressure is at DANGEROUS levels. Seek medical attention IMMEDIATELY!',
  '高血壓一級': 'Stage 1 Hypertension',
  '高血壓二級': 'Stage 2 Hypertension',
  '高血壓危象': 'Hypertensive Crisis',
};
