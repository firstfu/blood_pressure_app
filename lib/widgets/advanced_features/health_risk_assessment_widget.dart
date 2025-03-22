/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-22 10:08:30
 * @ Description: 健康風險評估小部件 - 顯示用戶的血壓相關健康風險評估
 */

import 'package:flutter/material.dart';
import 'package:blood_pressure_app/l10n/app_localizations_extension.dart';

class HealthRiskAssessmentWidget extends StatelessWidget {
  final Map<String, dynamic> assessmentResult;

  const HealthRiskAssessmentWidget({super.key, required this.assessmentResult});

  @override
  Widget build(BuildContext context) {
    if (assessmentResult['hasData'] != true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                assessmentResult['message'] ?? context.tr('無法進行健康風險評估，數據不足'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // 總體風險評分
    final overallScore = assessmentResult['overallScore'] as double;

    // 各項風險
    final riskCategories = assessmentResult['riskCategories'] as List<dynamic>;

    // 生活方式建議
    final healthSuggestions = assessmentResult['healthSuggestions'] as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 風險評分儀表板
        _buildRiskScoreDashboard(context, overallScore),
        const SizedBox(height: 24),

        // 各項風險分類
        Text(context.tr('風險因素分析'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildRiskCategoriesList(context, riskCategories),
        const SizedBox(height: 24),

        // 健康生活方式建議
        Text(context.tr('健康生活方式建議'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildHealthSuggestions(context, healthSuggestions),
      ],
    );
  }

  // 構建風險評分儀表板
  Widget _buildRiskScoreDashboard(BuildContext context, double score) {
    Color scoreColor;
    String riskLevel;

    if (score <= 2.0) {
      scoreColor = Colors.green;
      riskLevel = context.tr('低風險');
    } else if (score <= 3.5) {
      scoreColor = Colors.orange;
      riskLevel = context.tr('中度風險');
    } else {
      scoreColor = Colors.red;
      riskLevel = context.tr('高風險');
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: scoreColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scoreColor.withAlpha(77)),
      ),
      child: Column(
        children: [
          Text(context.tr('總體風險評分'), style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(score.toStringAsFixed(1), style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: scoreColor)),
              Text('/5.0', style: TextStyle(fontSize: 24, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: scoreColor.withAlpha(51), borderRadius: BorderRadius.circular(20)),
            child: Text(riskLevel, style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Text(_getRiskSummary(context, score), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // 獲取風險摘要
  String _getRiskSummary(BuildContext context, double score) {
    if (score <= 2.0) {
      return context.tr('您的血壓狀況良好，總體心血管風險較低。');
    } else if (score <= 3.5) {
      return context.tr('您有一定的心血管風險，建議關注血壓變化並保持健康生活方式。');
    } else {
      return context.tr('您的心血管風險較高，建議諮詢醫生並嚴格控制血壓。');
    }
  }

  // 構建風險類別列表
  Widget _buildRiskCategoriesList(BuildContext context, List<dynamic> categories) {
    return Column(
      children:
          categories.map((category) {
            final score = category['score'] as double;
            final title = category['title'] as String;
            final description = category['description'] as String;

            Color categoryColor;
            if (score <= 2.0) {
              categoryColor = Colors.green;
            } else if (score <= 3.5) {
              categoryColor = Colors.orange;
            } else {
              categoryColor = Colors.red;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: categoryColor.withAlpha(51),
                  child: Text(score.toStringAsFixed(1), style: TextStyle(color: categoryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                title: Text(title),
                children: [Padding(padding: const EdgeInsets.all(16.0), child: Text(description))],
              ),
            );
          }).toList(),
    );
  }

  // 構建健康建議
  Widget _buildHealthSuggestions(BuildContext context, List<dynamic> suggestions) {
    return Column(
      children:
          suggestions.map((suggestion) {
            final title = suggestion['title'] as String;
            final description = suggestion['description'] as String;
            final IconData icon = _getSuggestionIcon(title);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(13),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withAlpha(51)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: Colors.blue, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(description),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  // 獲取建議圖標
  IconData _getSuggestionIcon(String title) {
    if (title.contains(RegExp(r'運動|活動', caseSensitive: false))) {
      return Icons.directions_run;
    } else if (title.contains(RegExp(r'飲食|食物|鹽|鈉', caseSensitive: false))) {
      return Icons.restaurant;
    } else if (title.contains(RegExp(r'壓力|緊張|放鬆', caseSensitive: false))) {
      return Icons.spa;
    } else if (title.contains(RegExp(r'睡眠|休息', caseSensitive: false))) {
      return Icons.bedtime;
    } else if (title.contains(RegExp(r'酒|酗酒|飲酒', caseSensitive: false))) {
      return Icons.local_bar;
    } else if (title.contains(RegExp(r'煙|抽煙|吸煙', caseSensitive: false))) {
      return Icons.smoke_free;
    } else if (title.contains(RegExp(r'體重|減重|肥胖', caseSensitive: false))) {
      return Icons.monitor_weight;
    } else if (title.contains(RegExp(r'藥|藥物|醫療|治療', caseSensitive: false))) {
      return Icons.medication;
    } else {
      return Icons.favorite;
    }
  }
}
