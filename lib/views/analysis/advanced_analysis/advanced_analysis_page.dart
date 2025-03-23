/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 12:20:42
 * @ Description: 血壓記錄 App 高級分析頁面 - 提供深度血壓數據分析功能
 */

import 'package:flutter/material.dart';
import '../../../models/blood_pressure_record.dart';
import '../../../services/analysis_service.dart';
import '../../../services/mock_data_service.dart';
import 'widgets/medication_effect_widget.dart';
import 'widgets/position_arm_effect_widget.dart';
import 'widgets/morning_evening_effect_widget.dart';

class AdvancedAnalysisPage extends StatefulWidget {
  final List<BloodPressureRecord>? records;

  const AdvancedAnalysisPage({super.key, this.records});

  @override
  State<AdvancedAnalysisPage> createState() => _AdvancedAnalysisPageState();
}

class _AdvancedAnalysisPageState extends State<AdvancedAnalysisPage> {
  late List<BloodPressureRecord> _records;
  late Map<String, dynamic> _medicationAnalysis;
  late Map<String, dynamic> _positionArmAnalysis;
  late Map<String, dynamic> _morningEveningAnalysis;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // 使用傳入的記錄或獲取模擬數據
    _records = widget.records ?? MockDataService.getMockBloodPressureRecords();

    // 執行分析
    _medicationAnalysis = AnalysisService.analyzeMedicationEffect(_records);
    _positionArmAnalysis = AnalysisService.analyzePositionArmEffect(_records);
    _morningEveningAnalysis = AnalysisService.analyzeMorningEveningEffect(_records);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('深度分析', style: TextStyle(fontSize: 18)), elevation: 0),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('高級血壓分析', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('基於您的血壓記錄進行深度分析，幫助您更好地了解血壓變化規律。', style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                            const Row(
                              children: [
                                Icon(Icons.medication, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('服藥效果分析', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            MedicationEffectWidget(analysis: _medicationAnalysis),
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
                            const Row(
                              children: [
                                Icon(Icons.compare_arrows, color: Colors.green),
                                SizedBox(width: 8),
                                Text('測量條件分析', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            PositionArmEffectWidget(analysis: _positionArmAnalysis),
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
                            const Row(
                              children: [
                                Icon(Icons.wb_sunny, color: Colors.orange),
                                SizedBox(width: 8),
                                Text('晨峰血壓分析', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            MorningEveningEffectWidget(analysis: _morningEveningAnalysis),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
