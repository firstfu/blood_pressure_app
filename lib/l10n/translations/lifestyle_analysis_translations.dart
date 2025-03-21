// @ Author: firstfu
// @ Create Time: 2024-05-24 23:20:35
// @ Description: 生活方式分析頁面詞彙多語系翻譯

// 繁體中文生活方式分析詞彙
const Map<String, String> zhTWLifestyleAnalysis = {
  // 頁面標題
  '生活方式分析': '生活方式分析',
  '選擇生活方式因素': '選擇生活方式因素',

  // 生活方式因素名稱
  '運動': '運動',
  '睡眠': '睡眠',
  '鹽分攝取': '鹽分攝取',
  '壓力': '壓力',
  '水分攝取': '水分攝取',
  '酒精': '酒精',

  // 數據不足提示
  '沒有足夠的數據進行生活方式相關性分析。請記錄更多帶有生活方式標籤的血壓數據。': '沒有足夠的數據進行生活方式相關性分析。請記錄更多帶有生活方式標籤的血壓數據。',
  '暫無足夠數據，增加更多記錄以進行分析': '暫無足夠數據，增加更多記錄以進行分析',
  '數據不足，無法顯示圖表': '數據不足，無法顯示圖表',
  '請記錄更多數據或選擇其他因素': '請記錄更多數據或選擇其他因素',
  '無法顯示的圖表數據': '無法顯示的圖表數據',
  '相關性數據不完整': '相關性數據不完整',
  '無法顯示完整的相關性分析結果，請稍後再試或選擇其他因素。': '無法顯示完整的相關性分析結果，請稍後再試或選擇其他因素。',

  // 相關性結果描述
  '與血壓': '與血壓',
  '正相關': '正相關',
  '負相關': '負相關',
  '無明顯相關': '無明顯相關',
  '相關性混合': '相關性混合',
  '弱相關': '弱相關',
  '中等相關': '中等相關',
  '強相關': '強相關',
  '影響': '影響',
  '數據不足': '數據不足',
  '強正相關': '強正相關',
  '中等正相關': '中等正相關',
  '弱正相關': '弱正相關',
  '弱負相關': '弱負相關',
  '中等負相關': '中等負相關',
  '強負相關': '強負相關',

  // 水分攝取與血壓相關性描述
  '水分攝入與血壓呈現中等負相關，充足飲水的日子血壓略有降低。': '水分攝入與血壓呈現中等負相關，充足飲水的日子血壓略有降低。',
  '影響: 適當飲水有助於維持血液循環和血壓穩定。建議每日飲水量在1.5-2升。': '影響: 適當飲水有助於維持血液循環和血壓穩定。建議每日飲水量在1.5-2升。',

  // 生活方式因素與血壓的相關性類型
  '運動與血壓: 中等負相關': '運動與血壓: 中等負相關',
  '睡眠與血壓: 中等負相關': '睡眠與血壓: 中等負相關',
  '鹽分攝取與血壓: 中等正相關': '鹽分攝取與血壓: 中等正相關',
  '壓力與血壓: 強正相關': '壓力與血壓: 強正相關',
  '水分攝取與血壓: 中等負相關': '水分攝取與血壓: 中等負相關',
  '酒精與血壓: 中等正相關': '酒精與血壓: 中等正相關',

  // 生活方式因素的影響描述
  '規律運動有助於降低血壓，提高心肺功能。': '規律運動有助於降低血壓，提高心肺功能。',
  '缺乏運動可能導致血壓升高的風險增加。': '缺乏運動可能導致血壓升高的風險增加。',
  '充足的睡眠有助於維持健康的血壓水平。': '充足的睡眠有助於維持健康的血壓水平。',
  '睡眠不足或睡眠質量差可能導致血壓升高。': '睡眠不足或睡眠質量差可能導致血壓升高。',
  '攝入過多鹽分會導致血壓升高。': '攝入過多鹽分會導致血壓升高。',
  '適量減少鹽分攝入有助於控制血壓。': '適量減少鹽分攝入有助於控制血壓。',
  '高壓力狀態下身體會釋放壓力荷爾蒙，可能導致血壓暫時升高。': '高壓力狀態下身體會釋放壓力荷爾蒙，可能導致血壓暫時升高。',
  '長期壓力可能導致持續性高血壓。': '長期壓力可能導致持續性高血壓。',
  '適當的水分攝入有助於維持正常的血容量和血壓。': '適當的水分攝入有助於維持正常的血容量和血壓。',
  '水分攝入不足可能導致血液濃縮，增加心臟負擔。': '水分攝入不足可能導致血液濃縮，增加心臟負擔。',
  '過量飲酒會導致血壓升高，增加心血管疾病風險。': '過量飲酒會導致血壓升高，增加心血管疾病風險。',
  '適量飲酒對某些人可能有輕微的保護作用，但不建議為降血壓而飲酒。': '適量飲酒對某些人可能有輕微的保護作用，但不建議為降血壓而飲酒。',

  // 健康建議標題
  '健康建議': '健康建議',

  // 運動建議
  '每週進行至少150分鐘中等強度有氧運動': '每週進行至少150分鐘中等強度有氧運動',
  '選擇步行、游泳、騎自行車等有氧活動': '選擇步行、游泳、騎自行車等有氧活動',
  '避免過度劇烈的運動，尤其是已有高血壓的人': '避免過度劇烈的運動，尤其是已有高血壓的人',
  '堅持規律運動，而非偶爾的高強度活動': '堅持規律運動，而非偶爾的高強度活動',

  // 睡眠建議
  '保持每晚7-8小時的充足睡眠': '保持每晚7-8小時的充足睡眠',
  '建立規律的睡眠時間表，包括週末': '建立規律的睡眠時間表，包括週末',
  '創造安靜、黑暗、舒適的睡眠環境': '創造安靜、黑暗、舒適的睡眠環境',
  '避免睡前使用電子設備和攝入咖啡因': '避免睡前使用電子設備和攝入咖啡因',

  // 鹽分攝取建議
  '將每日鈉攝入量控制在2000毫克以下': '將每日鈉攝入量控制在2000毫克以下',
  '減少加工食品、罐頭和外賣食品的攝入': '減少加工食品、罐頭和外賣食品的攝入',
  '閱讀食品標籤以了解鈉含量': '閱讀食品標籤以了解鈉含量',
  '使用香草、香料代替鹽增添風味': '使用香草、香料代替鹽增添風味',

  // 壓力管理建議
  '嘗試冥想、深呼吸或瑜伽等放鬆技巧': '嘗試冥想、深呼吸或瑜伽等放鬆技巧',
  '保持適度的工作和休息平衡': '保持適度的工作和休息平衡',
  '培養興趣愛好，尋找減壓方式': '培養興趣愛好，尋找減壓方式',
  '必要時尋求專業心理支持': '必要時尋求專業心理支持',

  // 水分攝取建議
  '每日飲水2-2.5升（約8-10杯）': '每日飲水2-2.5升（約8-10杯）',
  '保持全天均勻飲水的習慣': '保持全天均勻飲水的習慣',
  '限制含糖飲料和咖啡因飲品': '限制含糖飲料和咖啡因飲品',
  '增加富含水分的蔬果攝入': '增加富含水分的蔬果攝入',

  // 酒精攝取建議
  '男性每日酒精攝入不超過25克（約2杯）': '男性每日酒精攝入不超過25克（約2杯）',
  '女性每日酒精攝入不超過15克（約1杯）': '女性每日酒精攝入不超過15克（約1杯）',
  '避免一次性大量飲酒': '避免一次性大量飲酒',
  '高血壓患者考慮完全避免飲酒': '高血壓患者考慮完全避免飲酒',

  // 圖表和數據顯示
  '血壓差異': '血壓差異',
  '平均血壓比較': '平均血壓比較',
  '血壓平均值比較': '血壓平均值比較',
  '收縮壓': '收縮壓',
  '舒張壓': '舒張壓',
  '日記錄數': '日記錄數',
  '相關性值': '相關性值',
  '相關性強度': '相關性強度',

  // 運動分組名稱
  '不運動': '不運動',
  '偶爾運動': '偶爾運動',
  '經常運動': '經常運動',

  // 睡眠分組名稱
  '睡眠不足': '睡眠不足',
  '睡眠一般': '睡眠一般',
  '睡眠充足': '睡眠充足',

  // 鹽分攝取分組名稱
  '低鹽飲食': '低鹽飲食',
  '中等鹽分': '中等鹽分',
  '高鹽飲食': '高鹽飲食',

  // 壓力分組名稱
  '壓力小': '壓力小',
  '壓力中等': '壓力中等',
  '壓力大': '壓力大',

  // 飲水量特定項
  '飲水少': '飲水少',
  '飲水適中': '飲水適中',
  '飲水充足': '飲水充足',

  // 酒精分組名稱
  '不飲酒': '不飲酒',
  '少量飲酒': '少量飲酒',
  '中量飲酒': '中量飲酒',
  '大量飲酒': '大量飲酒',
};

// 英文生活方式分析詞彙
const Map<String, String> enUSLifestyleAnalysis = {
  // 頁面標題
  '生活方式分析': 'Lifestyle Analysis',
  '選擇生活方式因素': 'Select Lifestyle Factor',

  // 生活方式因素名稱
  '運動': 'Exercise',
  '睡眠': 'Sleep',
  '鹽分攝取': 'Salt Intake',
  '壓力': 'Stress',
  '水分攝取': 'Water Intake',
  '酒精': 'Alcohol',

  // 數據不足提示
  '沒有足夠的數據進行生活方式相關性分析。請記錄更多帶有生活方式標籤的血壓數據。':
      'Not enough data for lifestyle correlation analysis. Please record more blood pressure data with lifestyle tags.',
  '暫無足夠數據，增加更多記錄以進行分析': 'Insufficient data, add more records for analysis',
  '數據不足，無法顯示圖表': 'Insufficient data, cannot display chart',
  '請記錄更多數據或選擇其他因素': 'Please record more data or select another factor',
  '無法顯示的圖表數據': 'Unable to display chart data',
  '相關性數據不完整': 'Correlation data incomplete',
  '無法顯示完整的相關性分析結果，請稍後再試或選擇其他因素。': 'Unable to display complete correlation analysis results. Please try again later or select another factor.',

  // 相關性結果描述
  '與血壓': 'and Blood Pressure',
  '正相關': 'Positive Correlation',
  '負相關': 'Negative Correlation',
  '無明顯相關': 'No Significant Correlation',
  '相關性混合': 'Mixed Correlation',
  '弱相關': 'Weak Correlation',
  '中等相關': 'Moderate Correlation',
  '強相關': 'Strong Correlation',
  '影響': 'Impact',
  '數據不足': 'Insufficient Data',
  '強正相關': 'Strong Positive Correlation',
  '中等正相關': 'Moderate Positive Correlation',
  '弱正相關': 'Weak Positive Correlation',
  '弱負相關': 'Weak Negative Correlation',
  '中等負相關': 'Moderate Negative Correlation',
  '強負相關': 'Strong Negative Correlation',

  // 水分攝取與血壓相關性描述
  '水分攝入與血壓呈現中等負相關，充足飲水的日子血壓略有降低。':
      'Water intake shows a moderate negative correlation with blood pressure, with slightly lower blood pressure on days with adequate hydration.',
  '影響: 適當飲水有助於維持血液循環和血壓穩定。建議每日飲水量在1.5-2升。':
      'Impact: Proper hydration helps maintain blood circulation and stable blood pressure. Recommended daily water intake is 1.5-2 liters.',

  // 生活方式因素與血壓的相關性類型
  '運動與血壓: 中等負相關': 'Exercise and Blood Pressure: Moderate Negative Correlation',
  '睡眠與血壓: 中等負相關': 'Sleep and Blood Pressure: Moderate Negative Correlation',
  '鹽分攝取與血壓: 中等正相關': 'Salt Intake and Blood Pressure: Moderate Positive Correlation',
  '壓力與血壓: 強正相關': 'Stress and Blood Pressure: Strong Positive Correlation',
  '水分攝取與血壓: 中等負相關': 'Water Intake and Blood Pressure: Moderate Negative Correlation',
  '酒精與血壓: 中等正相關': 'Alcohol and Blood Pressure: Moderate Positive Correlation',

  // 生活方式因素的影響描述
  '規律運動有助於降低血壓，提高心肺功能。': 'Regular exercise helps lower blood pressure and improves cardiovascular function.',
  '缺乏運動可能導致血壓升高的風險增加。': 'Lack of exercise may increase the risk of elevated blood pressure.',
  '充足的睡眠有助於維持健康的血壓水平。': 'Adequate sleep helps maintain healthy blood pressure levels.',
  '睡眠不足或睡眠質量差可能導致血壓升高。': 'Insufficient sleep or poor sleep quality can lead to elevated blood pressure.',
  '攝入過多鹽分會導致血壓升高。': 'Excessive salt intake leads to elevated blood pressure.',
  '適量減少鹽分攝入有助於控制血壓。': 'Moderate reduction in salt intake helps control blood pressure.',
  '高壓力狀態下身體會釋放壓力荷爾蒙，可能導致血壓暫時升高。': 'Under high stress, the body releases stress hormones that may temporarily raise blood pressure.',
  '長期壓力可能導致持續性高血壓。': 'Chronic stress may lead to persistent hypertension.',
  '適當的水分攝入有助於維持正常的血容量和血壓。': 'Proper hydration helps maintain normal blood volume and pressure.',
  '水分攝入不足可能導致血液濃縮，增加心臟負擔。': 'Insufficient water intake may lead to blood concentration, increasing cardiac load.',
  '過量飲酒會導致血壓升高，增加心血管疾病風險。': 'Excessive alcohol consumption raises blood pressure and increases cardiovascular disease risk.',
  '適量飲酒對某些人可能有輕微的保護作用，但不建議為降血壓而飲酒。':
      'Moderate alcohol consumption may have a slight protective effect for some people, but drinking to lower blood pressure is not recommended.',

  // 健康建議標題
  '健康建議': 'Health Recommendations',

  // 運動建議
  '每週進行至少150分鐘中等強度有氧運動': 'Engage in at least 150 minutes of moderate-intensity aerobic exercise weekly',
  '選擇步行、游泳、騎自行車等有氧活動': 'Choose aerobic activities like walking, swimming, or cycling',
  '避免過度劇烈的運動，尤其是已有高血壓的人': 'Avoid excessively intense exercise, especially for those with hypertension',
  '堅持規律運動，而非偶爾的高強度活動': 'Maintain regular exercise rather than occasional high-intensity activities',

  // 睡眠建議
  '保持每晚7-8小時的充足睡眠': 'Maintain 7-8 hours of quality sleep each night',
  '建立規律的睡眠時間表，包括週末': 'Establish a regular sleep schedule, including weekends',
  '創造安靜、黑暗、舒適的睡眠環境': 'Create a quiet, dark, and comfortable sleep environment',
  '避免睡前使用電子設備和攝入咖啡因': 'Avoid electronic devices and caffeine before bedtime',

  // 鹽分攝取建議
  '將每日鈉攝入量控制在2000毫克以下': 'Limit daily sodium intake to less than 2000mg',
  '減少加工食品、罐頭和外賣食品的攝入': 'Reduce consumption of processed foods, canned goods, and takeout meals',
  '閱讀食品標籤以了解鈉含量': 'Read food labels to understand sodium content',
  '使用香草、香料代替鹽增添風味': 'Use herbs and spices instead of salt to add flavor',

  // 壓力管理建議
  '嘗試冥想、深呼吸或瑜伽等放鬆技巧': 'Try relaxation techniques such as meditation, deep breathing, or yoga',
  '保持適度的工作和休息平衡': 'Maintain a balanced work and rest schedule',
  '培養興趣愛好，尋找減壓方式': 'Develop hobbies and find ways to relieve stress',
  '必要時尋求專業心理支持': 'Seek professional psychological support when necessary',

  // 水分攝取建議
  '每日飲水2-2.5升（約8-10杯）': 'Drink 2-2.5 liters of water daily (about 8-10 cups)',
  '保持全天均勻飲水的習慣': 'Maintain the habit of drinking water evenly throughout the day',
  '限制含糖飲料和咖啡因飲品': 'Limit sugary drinks and caffeinated beverages',
  '增加富含水分的蔬果攝入': 'Increase intake of water-rich fruits and vegetables',

  // 酒精攝取建議
  '男性每日酒精攝入不超過25克（約2杯）': 'Men should limit alcohol to no more than 25g (about 2 drinks) daily',
  '女性每日酒精攝入不超過15克（約1杯）': 'Women should limit alcohol to no more than 15g (about 1 drink) daily',
  '避免一次性大量飲酒': 'Avoid binge drinking',
  '高血壓患者考慮完全避免飲酒': 'Those with hypertension should consider avoiding alcohol completely',

  // 圖表和數據顯示
  '血壓差異': 'Blood Pressure Difference',
  '平均血壓比較': 'Average BP Comparison',
  '血壓平均值比較': 'Blood Pressure Average Comparison',
  '收縮壓': 'Systolic',
  '舒張壓': 'Diastolic',
  '日記錄數': 'Records/Day',
  '相關性值': 'Correlation Value',
  '相關性強度': 'Correlation Strength',

  // 運動分組名稱
  '不運動': 'No Exercise',
  '偶爾運動': 'Occasional Exercise',
  '經常運動': 'Regular Exercise',

  // 睡眠分組名稱
  '睡眠不足': 'Insufficient Sleep',
  '睡眠一般': 'Average Sleep',
  '睡眠充足': 'Sufficient Sleep',

  // 鹽分攝取分組名稱
  '低鹽飲食': 'Low Salt Diet',
  '中等鹽分': 'Moderate Salt',
  '高鹽飲食': 'High Salt Diet',

  // 壓力分組名稱
  '壓力小': 'Low Stress',
  '壓力中等': 'Moderate Stress',
  '壓力大': 'High Stress',

  // 飲水量特定項
  '飲水少': 'Low Water Intake',
  '飲水適中': 'Moderate Water Intake',
  '飲水充足': 'Sufficient Water Intake',

  // 酒精分組名稱
  '不飲酒': 'No Alcohol',
  '少量飲酒': 'Light Drinking',
  '中量飲酒': 'Moderate Drinking',
  '大量飲酒': 'Heavy Drinking',
};
