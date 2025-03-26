// @ Author: firstfu
// @ Create Time: 2024-05-24 22:48:08
// @ Description: 統計和分析相關詞彙多語系翻譯

// 繁體中文統計詞彙
const Map<String, String> zhTWStats = {
  // 統計頁面詞彙
  '統計': '統計',
  '統計分析': '統計分析',
  '趨勢分析': '趨勢分析',
  '健康風險評估': '健康風險評估',
  '收縮壓': '收縮壓',
  '舒張壓': '舒張壓',
  '心率': '心率',
  '血壓分類': '血壓分類',
  '最高值': '最高值',
  '最低值': '最低值',
  '平均值': '平均值',
  '生成報告': '生成報告',
  '導出數據': '導出數據',
  '7天': '7天',
  '2週': '2週',
  '1月': '1月',
  '自訂': '自訂',
  '日期範圍': '日期範圍',
  '開始日期': '開始日期',
  '結束日期': '結束日期',
  '確定': '確定',
  '取消': '取消',
  '暫無數據': '暫無數據',
  '筆': '筆',

  // 匯出功能相關
  '匯出': '匯出',
  '匯出為 CSV 檔案': '匯出為 CSV 檔案',
  '匯出為 Excel 檔案': '匯出為 Excel 檔案',
  '適用於 Excel、Google 試算表等': '適用於 Excel、Google 試算表等',
  '包含格式化和顏色標記': '包含格式化和顏色標記',
  '選擇匯出格式': '選擇匯出格式',
  '血壓記錄數據': '血壓記錄數據',
  'CSV 檔案已生成': 'CSV 檔案已生成',
  'Excel 檔案已生成': 'Excel 檔案已生成',
  '匯出失敗：': '匯出失敗：',
  '暫無數據，無法匯出': '暫無數據，無法匯出',
  '處理中...': '處理中...',

  // 圖表相關
  '正常上限': '正常上限',
  '高血壓': '高血壓',

  // 健康小貼士相關
  '健康小貼士': '健康小貼士',
  '定期監測血壓有助於及早發現潛在問題': '定期監測血壓有助於及早發現潛在問題',
  '每天的血壓可能因為時間不同而有所變化，嘗試在相同時間測量': '每天的血壓可能因為時間不同而有所變化，嘗試在相同時間測量',
  '減少鹽分攝取和保持適當運動可以幫助控制血壓': '減少鹽分攝取和保持適當運動可以幫助控制血壓',
  '測量血壓前，請保持安靜並休息至少5分鐘': '測量血壓前，請保持安靜並休息至少5分鐘',
  '保持健康體重對控制血壓非常重要': '保持健康體重對控制血壓非常重要',

  // 健康風險評估相關
  '需要血壓記錄才能進行健康風險評估': '需要血壓記錄才能進行健康風險評估',
  '需要至少7天的血壓記錄才能進行預測分析': '需要至少7天的血壓記錄才能進行預測分析',
  '您的收縮壓處於理想範圍內。': '您的收縮壓處於理想範圍內。',
  '您的收縮壓處於正常範圍，但接近高血壓前期。': '您的收縮壓處於正常範圍，但接近高血壓前期。',
  '您的收縮壓處於高血壓前期，有發展為高血壓的風險。': '您的收縮壓處於高血壓前期，有發展為高血壓的風險。',
  '您的收縮壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。': '您的收縮壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。',
  '您的收縮壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。': '您的收縮壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。',
  '收縮壓風險': '收縮壓風險',
  '您的舒張壓處於理想範圍內。': '您的舒張壓處於理想範圍內。',
  '您的舒張壓處於正常範圍，但接近高血壓前期。': '您的舒張壓處於正常範圍，但接近高血壓前期。',
  '您的舒張壓處於高血壓前期，有發展為高血壓的風險。': '您的舒張壓處於高血壓前期，有發展為高血壓的風險。',
  '您的舒張壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。': '您的舒張壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。',
  '您的舒張壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。': '您的舒張壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。',
  '舒張壓風險': '舒張壓風險',
  '您的脈壓差偏低，可能表示心臟輸出量減少。': '您的脈壓差偏低，可能表示心臟輸出量減少。',
  '您的脈壓差處於正常範圍。': '您的脈壓差處於正常範圍。',
  '您的脈壓差略高，可能表示動脈彈性降低，是心血管疾病的風險因素。': '您的脈壓差略高，可能表示動脈彈性降低，是心血管疾病的風險因素。',
  '您的脈壓差明顯偏高，這通常與動脈硬化相關，是心血管疾病的重要風險因素。': '您的脈壓差明顯偏高，這通常與動脈硬化相關，是心血管疾病的重要風險因素。',
  '脈壓差分析': '脈壓差分析',

  // 建議相關
  '保持健康飲食': '保持健康飲食',
  '減少鹽分攝入，增加蔬果攝入，選擇全穀物和低脂蛋白質，避免加工食品和高糖飲料。': '減少鹽分攝入，增加蔬果攝入，選擇全穀物和低脂蛋白質，避免加工食品和高糖飲料。',
  '規律運動': '規律運動',
  '每週至少進行150分鐘中等強度有氧運動，如快走、游泳或騎自行車。': '每週至少進行150分鐘中等強度有氧運動，如快走、游泳或騎自行車。',
  '減少鈉鹽攝入': '減少鈉鹽攝入',
  '每日鈉鹽攝入量控制在5克以下，減少使用加工食品和外賣食品。': '每日鈉鹽攝入量控制在5克以下，減少使用加工食品和外賣食品。',
  '定期監測血壓': '定期監測血壓',
  '每日固定時間測量血壓，並記錄變化趨勢，定期與醫生分享這些記錄。': '每日固定時間測量血壓，並記錄變化趨勢，定期與醫生分享這些記錄。',
  '控制體重': '控制體重',
  '將體重維持在健康範圍內可以幫助降低血壓，每減少1kg體重可降低血壓約1mmHg。': '將體重維持在健康範圍內可以幫助降低血壓，每減少1kg體重可降低血壓約1mmHg。',
  '減少壓力': '減少壓力',
  '嘗試冥想、深呼吸或瑜伽等放鬆技巧，有助於降低壓力和血壓。': '嘗試冥想、深呼吸或瑜伽等放鬆技巧，有助於降低壓力和血壓。',
  '限制酒精攝入': '限制酒精攝入',
  '男性每日酒精攝入量不超過25g，女性不超過15g。過量飲酒會顯著提高血壓。': '男性每日酒精攝入量不超過25g，女性不超過15g。過量飲酒會顯著提高血壓。',
  '諮詢醫療建議': '諮詢醫療建議',
  '您的血壓處於較高水平，建議儘快諮詢醫生獲取個人化的治療方案。': '您的血壓處於較高水平，建議儘快諮詢醫生獲取個人化的治療方案。',

  // 血壓趨勢預測相關
  '您的血壓在近期顯示為穩定狀態，變化範圍在正常波動範圍內。': '您的血壓在近期顯示為穩定狀態，變化範圍在正常波動範圍內。',
  '您的血壓呈上升趨勢，可能需要更密切關注並考慮咨詢醫生。': '您的血壓呈上升趨勢，可能需要更密切關注並考慮咨詢醫生。',
  '您的血壓呈下降趨勢，如果這是治療的效果，這是個好消息。': '您的血壓呈下降趨勢，如果這是治療的效果，這是個好消息。',
  '您的血壓顯示出一些波動，建議定期監測並保持良好的生活習慣。': '您的血壓顯示出一些波動，建議定期監測並保持良好的生活習慣。',
};

// 英文統計詞彙
const Map<String, String> enUSStats = {
  // 統計頁面詞彙
  '統計': 'Statistics',
  '統計分析': 'Statistical Analysis',
  '趨勢分析': 'Trend Analysis',
  '健康風險評估': 'Health Risk Assessment',
  '收縮壓': 'Systolic',
  '舒張壓': 'Diastolic',
  '心率': 'Pulse',
  '血壓分類': 'BP Classification',
  '最高值': 'Max',
  '最低值': 'Min',
  '平均值': 'Avg',
  '生成報告': 'Generate Report',
  '導出數據': 'Export Data',
  '7天': '7 Days',
  '2週': '2 Weeks',
  '1月': '1 Month',
  '自訂': 'Custom',
  '日期範圍': 'Date Range',
  '開始日期': 'Start Date',
  '結束日期': 'End Date',
  '確定': 'Confirm',
  '取消': 'Cancel',
  '暫無數據': 'No Data Available',
  '筆': 'records',

  // 匯出功能相關
  '匯出': 'Export',
  '匯出為 CSV 檔案': 'Export as CSV',
  '匯出為 Excel 檔案': 'Export as Excel',
  '適用於 Excel、Google 試算表等': 'Compatible with Excel, Google Sheets, etc.',
  '包含格式化和顏色標記': 'Includes formatting and color coding',
  '選擇匯出格式': 'Select Export Format',
  '血壓記錄數據': 'Blood Pressure Record Data',
  'CSV 檔案已生成': 'CSV file generated',
  'Excel 檔案已生成': 'Excel file generated',
  '匯出失敗：': 'Export failed: ',
  '暫無數據，無法匯出': 'No data available, cannot export',
  '處理中...': 'Processing...',

  // 圖表相關
  '正常上限': 'Normal Limit',
  '高血壓': 'Hypertension',

  // 健康小貼士相關
  '健康小貼士': 'Health Tips',
  '定期監測血壓有助於及早發現潛在問題': 'Regular blood pressure monitoring helps identify potential issues early',
  '每天的血壓可能因為時間不同而有所變化，嘗試在相同時間測量': 'Blood pressure may vary throughout the day, try to measure at the same time',
  '減少鹽分攝取和保持適當運動可以幫助控制血壓': 'Reducing salt intake and regular exercise can help control blood pressure',
  '測量血壓前，請保持安靜並休息至少5分鐘': 'Before measuring blood pressure, stay quiet and rest for at least 5 minutes',
  '保持健康體重對控制血壓非常重要': 'Maintaining a healthy weight is crucial for blood pressure control',

  // 健康風險評估相關
  '需要血壓記錄才能進行健康風險評估': 'Blood pressure records are needed for health risk assessment',
  '需要至少7天的血壓記錄才能進行預測分析': 'At least 7 days of blood pressure records are needed for prediction analysis',
  '您的收縮壓處於理想範圍內。': 'Your systolic pressure is within the ideal range.',
  '您的收縮壓處於正常範圍，但接近高血壓前期。': 'Your systolic pressure is normal but approaching pre-hypertension.',
  '您的收縮壓處於高血壓前期，有發展為高血壓的風險。': 'Your systolic pressure is in the pre-hypertension range, with risk of developing hypertension.',
  '您的收縮壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。':
      'Your systolic pressure is in the mild hypertension range, regular monitoring and consulting a doctor is recommended.',
  '您的收縮壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。':
      'Your systolic pressure is in the moderate to severe hypertension range, you should consult a doctor as soon as possible.',
  '收縮壓風險': 'Systolic Risk',
  '您的舒張壓處於理想範圍內。': 'Your diastolic pressure is within the ideal range.',
  '您的舒張壓處於正常範圍，但接近高血壓前期。': 'Your diastolic pressure is normal but approaching pre-hypertension.',
  '您的舒張壓處於高血壓前期，有發展為高血壓的風險。': 'Your diastolic pressure is in the pre-hypertension range, with risk of developing hypertension.',
  '您的舒張壓處於輕度高血壓範圍，建議定期監測並考慮諮詢醫生。':
      'Your diastolic pressure is in the mild hypertension range, regular monitoring and consulting a doctor is recommended.',
  '您的舒張壓處於中度至重度高血壓範圍，應該儘快諮詢醫生。':
      'Your diastolic pressure is in the moderate to severe hypertension range, you should consult a doctor as soon as possible.',
  '舒張壓風險': 'Diastolic Risk',
  '您的脈壓差偏低，可能表示心臟輸出量減少。': 'Your pulse pressure is low, which may indicate decreased cardiac output.',
  '您的脈壓差處於正常範圍。': 'Your pulse pressure is within the normal range.',
  '您的脈壓差略高，可能表示動脈彈性降低，是心血管疾病的風險因素。':
      'Your pulse pressure is slightly high, which may indicate reduced arterial elasticity, a risk factor for cardiovascular disease.',
  '您的脈壓差明顯偏高，這通常與動脈硬化相關，是心血管疾病的重要風險因素。':
      'Your pulse pressure is significantly high, which is usually associated with arterial stiffness, an important risk factor for cardiovascular disease.',
  '脈壓差分析': 'Pulse Pressure Analysis',

  // 建議相關
  '保持健康飲食': 'Maintain a Healthy Diet',
  '減少鹽分攝入，增加蔬果攝入，選擇全穀物和低脂蛋白質，避免加工食品和高糖飲料。':
      'Reduce salt intake, increase fruit and vegetable consumption, choose whole grains and low-fat proteins, avoid processed foods and high-sugar beverages.',
  '規律運動': 'Regular Exercise',
  '每週至少進行150分鐘中等強度有氧運動，如快走、游泳或騎自行車。':
      'Engage in at least 150 minutes of moderate-intensity aerobic exercise weekly, such as brisk walking, swimming, or cycling.',
  '減少鈉鹽攝入': 'Reduce Sodium Intake',
  '每日鈉鹽攝入量控制在5克以下，減少使用加工食品和外賣食品。': 'Limit daily sodium intake to less than 5g, reduce the use of processed and takeout foods.',
  '定期監測血壓': 'Regular Blood Pressure Monitoring',
  '每日固定時間測量血壓，並記錄變化趨勢，定期與醫生分享這些記錄。':
      'Measure blood pressure at the same time daily, record trends, and regularly share these records with your doctor.',
  '控制體重': 'Weight Control',
  '將體重維持在健康範圍內可以幫助降低血壓，每減少1kg體重可降低血壓約1mmHg。':
      'Maintaining weight within a healthy range can help lower blood pressure. Each 1kg reduction can lower blood pressure by about 1mmHg.',
  '減少壓力': 'Reduce Stress',
  '嘗試冥想、深呼吸或瑜伽等放鬆技巧，有助於降低壓力和血壓。': 'Try relaxation techniques such as meditation, deep breathing, or yoga to help reduce stress and blood pressure.',
  '限制酒精攝入': 'Limit Alcohol Intake',
  '男性每日酒精攝入量不超過25g，女性不超過15g。過量飲酒會顯著提高血壓。':
      'Daily alcohol intake should not exceed 25g for men and 15g for women. Excessive drinking significantly increases blood pressure.',
  '諮詢醫療建議': 'Seek Medical Advice',
  '您的血壓處於較高水平，建議儘快諮詢醫生獲取個人化的治療方案。':
      'Your blood pressure is at a high level, it is recommended to consult a doctor as soon as possible for a personalized treatment plan.',

  // 血壓趨勢預測相關
  '您的血壓在近期顯示為穩定狀態，變化範圍在正常波動範圍內。': 'Your blood pressure has been stable recently, with variations within the normal fluctuation range.',
  '您的血壓呈上升趨勢，可能需要更密切關注並考慮咨詢醫生。': 'Your blood pressure shows an upward trend, you may need to pay closer attention and consider consulting a doctor.',
  '您的血壓呈下降趨勢，如果這是治療的效果，這是個好消息。': 'Your blood pressure shows a downward trend, which is good news if this is the effect of treatment.',
  '您的血壓顯示出一些波動，建議定期監測並保持良好的生活習慣。':
      'Your blood pressure shows some fluctuations, regular monitoring and maintaining good lifestyle habits are recommended.',
};
