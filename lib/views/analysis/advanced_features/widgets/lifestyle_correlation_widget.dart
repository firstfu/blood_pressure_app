/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 19:15:30
 * @ Description: 生活方式相關性分析小部件 - 顯示生活方式與血壓的相關性分析結果
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_localizations_extension.dart';

class LifestyleCorrelationWidget extends StatefulWidget {
  final Map<String, dynamic> correlationResults;

  const LifestyleCorrelationWidget({super.key, required this.correlationResults});

  @override
  State<LifestyleCorrelationWidget> createState() => _LifestyleCorrelationWidgetState();
}

class _LifestyleCorrelationWidgetState extends State<LifestyleCorrelationWidget> {
  String _selectedFactor = 'exercise';
  late Map<String, String> _factorNames;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化因素名稱映射，使用翻譯
    _factorNames = {
      'exercise': context.tr('運動'),
      'sleep': context.tr('睡眠'),
      'salt': context.tr('鹽分攝取'),
      'stress': context.tr('壓力'),
      'water': context.tr('水分攝取'),
      'alcohol': context.tr('酒精'),
    };
  }

  @override
  Widget build(BuildContext context) {
    // 檢查是否有相關性結果
    if (widget.correlationResults.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(context.tr('沒有足夠的數據進行生活方式相關性分析。請記錄更多帶有生活方式標籤的血壓數據。'))));
    }

    // 獲取選定因素的數據
    final factorData = widget.correlationResults[_selectedFactor];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFactorSelector(),
        const SizedBox(height: 16),
        _buildCorrelationResults(factorData),
        const SizedBox(height: 16),
        _buildCorrelationChart(factorData),
        const SizedBox(height: 16),
        _buildHealthRecommendations(factorData),
      ],
    );
  }

  // =============================================
  // 構建因素選擇器
  Widget _buildFactorSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('選擇生活方式因素'), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.0,
            children:
                _factorNames.entries.map((entry) {
                  final isSelected = _selectedFactor == entry.key;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFactor = entry.key;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300, width: isSelected ? 2 : 1),
                        boxShadow:
                            isSelected ? [BoxShadow(color: Colors.blue.shade200.withAlpha(128), blurRadius: 4, offset: const Offset(0, 2))] : null,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSelected) Icon(Icons.check_circle, color: Colors.blue.shade800, size: 14),
                            if (isSelected) const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  color: isSelected ? Colors.blue.shade800 : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // 構建相關性圖表
  Widget _buildCorrelationChart(Map<String, dynamic> factorData) {
    // 檢查是否有數據
    final hasData = factorData['hasData'] == true;

    // 如果沒有數據，顯示提示訊息
    if (!hasData) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withAlpha(77)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(context.tr('數據不足，無法顯示圖表'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(context.tr('請記錄更多數據或選擇其他因素'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    // 檢查是否有分組數據
    final groups = factorData['groups'];
    if (groups == null || (groups is List && groups.isEmpty)) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withAlpha(77)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(context.tr('無法顯示的圖表數據'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // 確保 groups 是一個列表
    final List<dynamic> groupsList = groups is List ? groups : [groups];

    // 構建柱狀圖
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(context.tr('血壓平均值比較'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 200,
              minY: 0,
              groupsSpace: 12,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueGrey.withAlpha(204),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String title = '';
                    if (rodIndex == 0) {
                      title = context.tr('收縮壓');
                    } else if (rodIndex == 1) {
                      title = context.tr('舒張壓');
                    }
                    return BarTooltipItem('$title: ${rod.toY.toStringAsFixed(1)}', const TextStyle(color: Colors.white));
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String text = '';
                      if (value < groupsList.length) {
                        text = context.tr(groupsList[value.toInt()]['name'] ?? '');
                      }
                      return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(text, style: const TextStyle(fontSize: 12)));
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value % 50 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withAlpha(51))),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                },
                drawVerticalLine: false,
              ),
              barGroups: List.generate(groupsList.length, (index) {
                final group = groupsList[index];
                final systolic = group['avgSystolic'] ?? 0.0;
                final diastolic = group['avgDiastolic'] ?? 0.0;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: systolic.toDouble(),
                      color: Colors.red.withAlpha(179),
                      width: 16,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: diastolic.toDouble(),
                      color: Colors.blue.withAlpha(179),
                      width: 16,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12, height: 12, color: Colors.red.withAlpha(179)),
            const SizedBox(width: 4),
            Text(context.tr('收縮壓'), style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            Container(width: 12, height: 12, color: Colors.blue.withAlpha(179)),
            const SizedBox(width: 4),
            Text(context.tr('舒張壓'), style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  // 構建相關性結果
  Widget _buildCorrelationResults(Map<String, dynamic> factorData) {
    // 添加空值檢查
    final correlation = factorData['correlation'];
    final hasData = factorData['hasData'] == true;

    // 從服務獲取的描述和影響，但我們將改為使用翻譯文件中的內容
    final serviceDes = factorData['description'];
    final serviceImpact = factorData['impact'];

    // 如果關鍵數據缺失，顯示錯誤訊息
    if (correlation == null || serviceDes == null || serviceImpact == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withAlpha(77)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${_factorNames[_selectedFactor]} ${context.tr('相關性數據不完整')}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(context.tr('無法顯示完整的相關性分析結果，請稍後再試或選擇其他因素。'), softWrap: true),
          ],
        ),
      );
    }

    // 根據選擇的因素和相關性值，從翻譯文件中獲取相應的描述和影響文本
    String descriptionKey = '';
    String impactKey = '';

    // 根據相關性值和因素選擇對應的翻譯鍵
    final double correlationValue = correlation as double;

    // 為每種因素確定描述和影響的翻譯鍵
    switch (_selectedFactor) {
      case 'exercise':
        if (correlationValue < 0) {
          descriptionKey = '規律運動有助於降低血壓，提高心肺功能。';
          impactKey = '缺乏運動可能導致血壓升高的風險增加。';
        } else {
          descriptionKey = '缺乏運動可能導致血壓升高的風險增加。';
          impactKey = '規律運動有助於降低血壓，提高心肺功能。';
        }
        break;
      case 'sleep':
        if (correlationValue < 0) {
          descriptionKey = '充足的睡眠有助於維持健康的血壓水平。';
          impactKey = '睡眠不足或睡眠質量差可能導致血壓升高。';
        } else {
          descriptionKey = '睡眠不足或睡眠質量差可能導致血壓升高。';
          impactKey = '充足的睡眠有助於維持健康的血壓水平。';
        }
        break;
      case 'salt':
        if (correlationValue > 0) {
          descriptionKey = '攝入過多鹽分會導致血壓升高。';
          impactKey = '適量減少鹽分攝入有助於控制血壓。';
        } else {
          descriptionKey = '適量減少鹽分攝入有助於控制血壓。';
          impactKey = '攝入過多鹽分會導致血壓升高。';
        }
        break;
      case 'stress':
        if (correlationValue > 0) {
          descriptionKey = '高壓力狀態下身體會釋放壓力荷爾蒙，可能導致血壓暫時升高。';
          impactKey = '長期壓力可能導致持續性高血壓。';
        } else {
          descriptionKey = '長期壓力可能導致持續性高血壓。';
          impactKey = '高壓力狀態下身體會釋放壓力荷爾蒙，可能導致血壓暫時升高。';
        }
        break;
      case 'water':
        if (correlationValue < 0) {
          descriptionKey = '水分攝入與血壓呈現中等負相關，充足飲水的日子血壓略有降低。';
          impactKey = '適當的水分攝入有助於維持正常的血容量和血壓。';
        } else {
          descriptionKey = '水分攝入不足可能導致血液濃縮，增加心臟負擔。';
          impactKey = '適當的水分攝入有助於維持正常的血容量和血壓。';
        }
        break;
      case 'alcohol':
        if (correlationValue > 0) {
          descriptionKey = '過量飲酒會導致血壓升高，增加心血管疾病風險。';
          impactKey = '適量飲酒對某些人可能有輕微的保護作用，但不建議為降血壓而飲酒。';
        } else {
          descriptionKey = '適量飲酒對某些人可能有輕微的保護作用，但不建議為降血壓而飲酒。';
          impactKey = '過量飲酒會導致血壓升高，增加心血管疾病風險。';
        }
        break;
      default:
        // 使用服務提供的描述和影響作為後備
        descriptionKey = serviceDes;
        impactKey = serviceImpact;
    }

    // 使用本地化文本
    final String descriptionText = context.tr(descriptionKey);
    final String impactText = context.tr(impactKey);

    // 根據 hasData 決定顯示樣式
    Color color;
    IconData icon;
    String correlationText;

    if (!hasData) {
      // 數據不足但有基本信息時的樣式
      icon = Icons.info_outline;
      color = Colors.blue;
      correlationText = context.tr('數據不足');
    } else if (correlationValue > 0.7) {
      icon = Icons.arrow_upward;
      color = Colors.red;
      correlationText = context.tr('強正相關');
    } else if (correlationValue > 0.3) {
      icon = Icons.arrow_upward;
      color = Colors.orange;
      correlationText = context.tr('中等正相關');
    } else if (correlationValue > 0) {
      icon = Icons.arrow_upward;
      color = Colors.yellow.shade800;
      correlationText = context.tr('弱正相關');
    } else if (correlationValue > -0.3) {
      icon = Icons.arrow_downward;
      color = Colors.green.shade300;
      correlationText = context.tr('弱負相關');
    } else if (correlationValue > -0.7) {
      icon = Icons.arrow_downward;
      color = Colors.green.shade600;
      correlationText = context.tr('中等負相關');
    } else {
      icon = Icons.arrow_downward;
      color = Colors.green.shade900;
      correlationText = context.tr('強負相關');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withAlpha(77))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 因素名稱 - 單獨一行並增大字體
          Text(_factorNames[_selectedFactor] ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18), softWrap: true),
          const SizedBox(height: 12),

          // 相關性指標 - 使用Flexible包裝並處理溢出
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  hasData
                      ? '${context.tr('與血壓')}: $correlationText (${correlationValue.toStringAsFixed(2)})'
                      : '${context.tr('與血壓')}: $correlationText',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ],
          ),

          // 描述文本 - 增加間距
          const SizedBox(height: 16),
          Text(descriptionText, softWrap: true, style: const TextStyle(height: 1.4)),

          // 影響部分 - 標題和內容分開顯示
          const SizedBox(height: 16),
          Text(context.tr('影響'), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(impactText, softWrap: true, style: const TextStyle(height: 1.4)),

          if (!hasData && factorData['message'] != null) ...[
            const SizedBox(height: 12),
            Text(factorData['message'], style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic), softWrap: true),
          ],
        ],
      ),
    );
  }

  // 構建建議項目
  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withAlpha(13),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withAlpha(51)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(recommendation, softWrap: true)),
          ],
        ),
      ),
    );
  }

  // 構建健康建議部分
  Widget _buildHealthRecommendations(Map<String, dynamic> factorData) {
    // 檢查是否有建議
    final recommendations = factorData['recommendations'];
    if (recommendations == null || (recommendations is List && recommendations.isEmpty)) {
      return Container();
    }

    // 創建適當的建議列表
    List<String> recommendationsList = [];

    // 根據因素類型選擇合適的建議
    switch (_selectedFactor) {
      case 'exercise':
        recommendationsList = ['每週進行至少150分鐘中等強度有氧運動', '選擇步行、游泳、騎自行車等有氧活動', '避免過度劇烈的運動，尤其是已有高血壓的人', '堅持規律運動，而非偶爾的高強度活動'];
        break;
      case 'sleep':
        recommendationsList = ['保持每晚7-8小時的充足睡眠', '建立規律的睡眠時間表，包括週末', '創造安靜、黑暗、舒適的睡眠環境', '避免睡前使用電子設備和攝入咖啡因'];
        break;
      case 'salt':
        recommendationsList = ['將每日鈉攝入量控制在2000毫克以下', '減少加工食品、罐頭和外賣食品的攝入', '閱讀食品標籤以了解鈉含量', '使用香草、香料代替鹽增添風味'];
        break;
      case 'stress':
        recommendationsList = ['嘗試冥想、深呼吸或瑜伽等放鬆技巧', '保持適度的工作和休息平衡', '培養興趣愛好，尋找減壓方式', '必要時尋求專業心理支持'];
        break;
      case 'water':
        recommendationsList = ['每日飲水2-2.5升（約8-10杯）', '保持全天均勻飲水的習慣', '限制含糖飲料和咖啡因飲品', '增加富含水分的蔬果攝入'];
        break;
      case 'alcohol':
        recommendationsList = ['男性每日酒精攝入不超過25克（約2杯）', '女性每日酒精攝入不超過15克（約1杯）', '避免一次性大量飲酒', '高血壓患者考慮完全避免飲酒'];
        break;
      default:
        // 如果服務提供了建議，則使用這些建議作為後備
        if (recommendations is List) {
          recommendationsList = List<String>.from(recommendations);
        } else if (recommendations is String) {
          recommendationsList = [recommendations];
        }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(context.tr('健康建議'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...recommendationsList.map((recommendation) => _buildRecommendationItem(context.tr(recommendation))),
      ],
    );
  }
}
