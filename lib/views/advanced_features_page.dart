/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 20:00:30
 * @ Description: 高級功能頁面 - 顯示深度分析、血壓預測、健康風險評估和生活方式相關性分析
 */

import 'package:flutter/material.dart';
import '../services/record_service.dart';
import '../services/prediction_service.dart';
import '../services/risk_assessment_service.dart';
import '../services/lifestyle_analysis_service.dart';
import '../services/analysis_service.dart';
import '../widgets/advanced_features/blood_pressure_prediction_widget.dart';
import '../widgets/advanced_features/health_risk_assessment_widget.dart';
import '../widgets/advanced_features/lifestyle_correlation_widget.dart';
import '../widgets/analysis/medication_effect_widget.dart';
import '../widgets/analysis/position_arm_effect_widget.dart';
import '../widgets/analysis/morning_evening_effect_widget.dart';
import '../l10n/app_localizations_extension.dart';

class AdvancedFeaturesPage extends StatefulWidget {
  const AdvancedFeaturesPage({super.key});

  @override
  State<AdvancedFeaturesPage> createState() => _AdvancedFeaturesPageState();
}

class _AdvancedFeaturesPageState extends State<AdvancedFeaturesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? _errorMessage;

  // 服務實例
  final RecordService _recordService = RecordService();
  final PredictionService _predictionService = PredictionService();
  final RiskAssessmentService _riskAssessmentService = RiskAssessmentService();
  final LifestyleAnalysisService _lifestyleAnalysisService = LifestyleAnalysisService();

  // 分析結果
  Map<String, dynamic> _predictionResults = {'hasData': false, 'message': '正在加載數據...'};
  Map<String, dynamic> _riskAssessmentResults = {'hasData': false, 'message': '正在加載數據...'};
  Map<String, dynamic> _correlationResults = {'hasData': false, 'message': '正在加載數據...'};

  // 深度分析結果，添加預設欄位避免空值錯誤
  late Map<String, dynamic> _medicationAnalysis = {'hasData': false, 'message': '正在加載數據...'};
  late Map<String, dynamic> _positionArmAnalysis = {'hasData': false, 'message': '正在加載數據...'};
  late Map<String, dynamic> _morningEveningAnalysis = {
    'hasData': false,
    'message': '正在加載數據...',
    'morningData': {'systolic': 0.0, 'diastolic': 0.0, 'count': 0},
    'eveningData': {'systolic': 0.0, 'diastolic': 0.0, 'count': 0},
    'difference': {'systolic': 0.0, 'diastolic': 0.0},
    'surgeIndex': 0.0,
    'surgeDegree': 'none',
  };

  // 用戶健康信息
  Map<String, dynamic> _userInfo = {'age': 45, 'gender': '男', 'hasDiabetes': false, 'isSmoker': false, 'cholesterolLevel': 180.0};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 加載數據
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 加載血壓記錄
      await _recordService.getRecords();
      final records = _recordService.records;

      if (records.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = context.tr('沒有可用的血壓記錄數據');
        });
        return;
      }

      // 進行血壓趨勢預測
      final predictionResults = await _predictionService.predictBloodPressureTrend(records);

      // 進行健康風險評估
      final riskAssessmentResults = await _riskAssessmentService.assessHealthRisk(records, userInfo: _userInfo);

      // 進行生活方式相關性分析
      final correlationResults = await _lifestyleAnalysisService.analyzeLifestyleCorrelation(records);

      // 執行深度分析
      final medicationAnalysis = AnalysisService.analyzeMedicationEffect(records);
      final positionArmAnalysis = AnalysisService.analyzePositionArmEffect(records);
      final morningEveningAnalysis = AnalysisService.analyzeMorningEveningEffect(records);

      setState(() {
        _predictionResults = predictionResults;
        _riskAssessmentResults = riskAssessmentResults;
        _correlationResults = correlationResults;
        _medicationAnalysis = medicationAnalysis;
        _positionArmAnalysis = positionArmAnalysis;
        _morningEveningAnalysis = morningEveningAnalysis;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '${context.tr('加載數據時發生錯誤')}: $e';
      });
    }
  }

  // 更新用戶健康信息
  void _updateUserInfo(Map<String, dynamic> userInfo) async {
    setState(() {
      _userInfo = userInfo;
      _isLoading = true;
    });

    // 重新計算健康風險評估
    try {
      final riskAssessmentResults = await _riskAssessmentService.assessHealthRisk(_recordService.records, userInfo: _userInfo);

      setState(() {
        _riskAssessmentResults = riskAssessmentResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '${context.tr('更新風險評估時發生錯誤')}: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 更新加載訊息為本地化文本
    final loadingMessage = context.tr('正在加載數據...');
    if (!_isLoading) {
      if (_predictionResults['hasData'] == false && _predictionResults['message'] == '正在加載數據...') {
        _predictionResults['message'] = loadingMessage;
      }
      if (_riskAssessmentResults['hasData'] == false && _riskAssessmentResults['message'] == '正在加載數據...') {
        _riskAssessmentResults['message'] = loadingMessage;
      }
      if (_correlationResults['hasData'] == false && _correlationResults['message'] == '正在加載數據...') {
        _correlationResults['message'] = loadingMessage;
      }
      if (_medicationAnalysis['hasData'] == false && _medicationAnalysis['message'] == '正在加載數據...') {
        _medicationAnalysis['message'] = loadingMessage;
      }
      if (_positionArmAnalysis['hasData'] == false && _positionArmAnalysis['message'] == '正在加載數據...') {
        _positionArmAnalysis['message'] = loadingMessage;
      }
      if (_morningEveningAnalysis['hasData'] == false && _morningEveningAnalysis['message'] == '正在加載數據...') {
        _morningEveningAnalysis['message'] = loadingMessage;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('高級功能'), style: const TextStyle(fontSize: 18)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.analytics), text: context.tr('深度分析')),
            Tab(icon: const Icon(Icons.trending_up), text: context.tr('血壓預測')),
            Tab(icon: const Icon(Icons.favorite), text: context.tr('風險評估')),
            Tab(icon: const Icon(Icons.bar_chart), text: context.tr('生活方式分析')),
          ],
          labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData, tooltip: context.tr('重新加載數據'))],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 24),
                      ElevatedButton(onPressed: _loadData, child: Text(context.tr('重試'))),
                    ],
                  ),
                ),
              )
              : TabBarView(
                controller: _tabController,
                children: [
                  // 深度分析
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                                    Text(context.tr('服藥效果分析'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                Row(
                                  children: [
                                    const Icon(Icons.compare_arrows, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text(context.tr('測量條件分析'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                Row(
                                  children: [
                                    const Icon(Icons.wb_sunny, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text(context.tr('晨峰血壓分析'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

                  // 血壓預測
                  SingleChildScrollView(
                    child: Padding(padding: const EdgeInsets.all(16.0), child: BloodPressurePredictionWidget(predictionResult: _predictionResults)),
                  ),

                  // 健康風險評估
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: HealthRiskAssessmentWidget(riskAssessmentResults: _riskAssessmentResults, onUpdateUserInfo: _updateUserInfo),
                    ),
                  ),

                  // 生活方式相關性分析
                  SingleChildScrollView(
                    child: Padding(padding: const EdgeInsets.all(16.0), child: LifestyleCorrelationWidget(correlationResults: _correlationResults)),
                  ),
                ],
              ),
    );
  }
}
