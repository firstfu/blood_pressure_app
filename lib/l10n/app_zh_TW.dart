/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-25 14:08:45
 * @ Description: 繁體中文語系文件
 */

import 'translations/index.dart';

// 透過模組化方式整合所有翻譯
// 對外導出變數，確保可以被其他文件引用
Map<String, String> zhTW = mergeZhTWTranslations();

// 若有未在模組中定義的特殊翻譯，可以在此添加
// zhTW.addAll({
//   '特殊翻譯鍵': '特殊翻譯值',
// });
