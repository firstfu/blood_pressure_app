/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-23 16:46:55
 * @ Description: 深度分析主組件 - 整合藥物效果、測量條件和晨峰血壓分析
 */

import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations_extension.dart';
import 'medication_effect_widget.dart';
import 'position_arm_effect_widget.dart';
import 'morning_evening_effect_widget.dart';

class DeepAnalysisWidget extends StatelessWidget {
  final Map<String, dynamic> medicationAnalysis;
  final Map<String, dynamic> positionArmAnalysis;
  final Map<String, dynamic> morningEveningAnalysis;

  const DeepAnalysisWidget({super.key, required this.medicationAnalysis, required this.positionArmAnalysis, required this.morningEveningAnalysis});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('深度分析'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(context.tr('基於您的血壓記錄進行深度分析，幫助您更好地了解血壓變化規律。'), style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),

        // 服藥效果分析
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medication, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(child: Text(context.tr('服藥效果分析'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 16),
                MedicationEffectWidget(analysis: medicationAnalysis),
              ],
            ),
          ),
        ),

        // 測量條件分析
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.compare_arrows, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(context.tr('測量條件分析'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 16),
                PositionArmEffectWidget(analysis: positionArmAnalysis),
              ],
            ),
          ),
        ),

        // 晨峰血壓分析
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(context.tr('晨峰血壓分析'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 16),
                MorningEveningEffectWidget(analysis: morningEveningAnalysis),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
