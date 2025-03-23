/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 20:00:30
 * @ Description: 高級功能頁面 - 顯示深度分析、血壓預測、健康風險評估和生活方式相關性分析
 */

import 'package:flutter/material.dart';
import '../../../services/record_service.dart';
import '../../../services/prediction_service.dart';
import '../../../services/risk_assessment_service.dart';
import '../../../services/lifestyle_analysis_service.dart';
import '../../../services/analysis_service.dart';
import 'widgets/blood_pressure_prediction_widget.dart';
import 'widgets/health_risk_assessment_widget.dart';
import 'widgets/lifestyle_correlation_widget.dart';
import 'widgets/deep_analysis/deep_analysis_widget.dart';
import '../../../l10n/app_localizations_extension.dart';

class AdvancedFeaturesPage extends StatefulWidget {
  const AdvancedFeaturesPage({super.key});

  @override
  State<AdvancedFeaturesPage> createState() => _AdvancedFeaturesPageState();
}

class _AdvancedFeaturesPageState extends State<AdvancedFeaturesPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final RecordService _recordService = RecordService();
  final LifestyleAnalysisService _lifestyleAnalysisService = LifestyleAnalysisService();
  late PredictionService _predictionService;
  late RiskAssessmentService _riskAssessmentService;

  // 分析結果數據
  Map<String, dynamic> _medicationAnalysis = {'hasData': false};
  Map<String, dynamic> _positionArmAnalysis = {'hasData': false};
  Map<String, dynamic> _morningEveningAnalysis = {'hasData': false};
  Map<String, dynamic> _predictionResults = {'hasData': false};
  Map<String, dynamic> _riskAssessmentResults = {'hasData': false};
  Map<String, dynamic> _correlationResults = {'hasData': false};

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _predictionService = PredictionService(context);
    _riskAssessmentService = RiskAssessmentService(context);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 加載數據
  void _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // 加載血壓記錄
      final records = await _recordService.getRecords();

      // 進行高級分析
      _medicationAnalysis = AnalysisService.analyzeMedicationEffect(records);
      _positionArmAnalysis = AnalysisService.analyzePositionArmEffect(records);
      _morningEveningAnalysis = AnalysisService.analyzeMorningEveningEffect(records);

      // 血壓預測
      _predictionResults = await _predictionService.predictBloodPressureTrend(records);

      // 健康風險評估
      _riskAssessmentResults = await _riskAssessmentService.assessHealthRisk(records);

      // 生活方式相關性分析
      _correlationResults = await _lifestyleAnalysisService.analyzeLifestyleCorrelation(records);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
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
                    child: DeepAnalysisWidget(
                      medicationAnalysis: _medicationAnalysis,
                      positionArmAnalysis: _positionArmAnalysis,
                      morningEveningAnalysis: _morningEveningAnalysis,
                    ),
                  ),

                  // 血壓預測
                  SingleChildScrollView(
                    child: Padding(padding: const EdgeInsets.all(16.0), child: BloodPressurePredictionWidget(predictionResult: _predictionResults)),
                  ),

                  // 健康風險評估
                  SingleChildScrollView(
                    child: Padding(padding: const EdgeInsets.all(16.0), child: HealthRiskAssessmentWidget(assessmentResult: _riskAssessmentResults)),
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
