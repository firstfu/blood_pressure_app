/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 20:00:30
 * @ Description: 高級功能頁面 - 顯示血壓預測、健康風險評估和生活方式相關性分析
 */

import 'package:flutter/material.dart';
import '../services/record_service.dart';
import '../services/prediction_service.dart';
import '../services/risk_assessment_service.dart';
import '../services/lifestyle_analysis_service.dart';
import '../widgets/advanced_features/blood_pressure_prediction_widget.dart';
import '../widgets/advanced_features/health_risk_assessment_widget.dart';
import '../widgets/advanced_features/lifestyle_correlation_widget.dart';

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

  // 用戶健康信息
  Map<String, dynamic> _userInfo = {'age': 45, 'gender': '男', 'hasDiabetes': false, 'isSmoker': false, 'cholesterolLevel': 180.0};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          _errorMessage = '沒有可用的血壓記錄數據';
        });
        return;
      }

      // 進行血壓趨勢預測
      final predictionResults = await _predictionService.predictBloodPressureTrend(records);

      // 進行健康風險評估
      final riskAssessmentResults = await _riskAssessmentService.assessHealthRisk(records, userInfo: _userInfo);

      // 進行生活方式相關性分析
      final correlationResults = await _lifestyleAnalysisService.analyzeLifestyleCorrelation(records);

      setState(() {
        _predictionResults = predictionResults;
        _riskAssessmentResults = riskAssessmentResults;
        _correlationResults = correlationResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '加載數據時發生錯誤: $e';
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
        _errorMessage = '更新風險評估時發生錯誤: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('高級功能', style: TextStyle(fontSize: 18)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.trending_up), text: '血壓預測'),
            Tab(icon: Icon(Icons.favorite), text: '風險評估'),
            Tab(icon: Icon(Icons.bar_chart), text: '生活方式分析'),
          ],
          labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData, tooltip: '重新加載數據')],
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
                      ElevatedButton(onPressed: _loadData, child: const Text('重試')),
                    ],
                  ),
                ),
              )
              : TabBarView(
                controller: _tabController,
                children: [
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
