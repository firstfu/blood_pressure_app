/*
 * @ Author: 1891_0982
 * @ Create Time: 2024-03-15 18:30:15
 * @ Description: 健康風險評估小部件 - 顯示健康風險評估結果
 */

import 'package:flutter/material.dart';

class HealthRiskAssessmentWidget extends StatefulWidget {
  final Map<String, dynamic> riskAssessmentResults;
  final Function(Map<String, dynamic>) onUpdateUserInfo;

  const HealthRiskAssessmentWidget({super.key, required this.riskAssessmentResults, required this.onUpdateUserInfo});

  @override
  State<HealthRiskAssessmentWidget> createState() => _HealthRiskAssessmentWidgetState();
}

class _HealthRiskAssessmentWidgetState extends State<HealthRiskAssessmentWidget> {
  bool _showUserInfoForm = false;
  final _formKey = GlobalKey<FormState>();

  // 用戶信息控制器
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = '男';
  bool _hasDiabetes = false;
  bool _isSmoking = false;
  final TextEditingController _cholesterolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initUserInfoControllers();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _cholesterolController.dispose();
    super.dispose();
  }

  // 初始化用戶信息控制器
  void _initUserInfoControllers() {
    final userInfo = widget.riskAssessmentResults['userInfo'] as Map<String, dynamic>?;
    if (userInfo != null) {
      _ageController.text = userInfo['age']?.toString() ?? '';
      _selectedGender = userInfo['gender'] ?? '男';
      _hasDiabetes = userInfo['hasDiabetes'] ?? false;
      _isSmoking = userInfo['isSmoking'] ?? false;
      _cholesterolController.text = userInfo['cholesterolLevel']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.riskAssessmentResults['hasData'] != true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                widget.riskAssessmentResults['message'] ?? '無法進行健康風險評估，數據不足',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final averageSystolic = widget.riskAssessmentResults['avgSystolic'] as int;
    final averageDiastolic = widget.riskAssessmentResults['avgDiastolic'] as int;
    final bpRiskLevel = widget.riskAssessmentResults['bpRiskLevel'] as String;
    final cvdRiskScore = widget.riskAssessmentResults['cvdRiskScore'] as double;
    final strokeRiskScore = widget.riskAssessmentResults['strokeRiskScore'] as double;
    final recommendations = widget.riskAssessmentResults['recommendations'] as List<dynamic>;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用戶信息表單切換按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('健康風險評估', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  icon: Icon(_showUserInfoForm ? Icons.close : Icons.edit),
                  label: Text(_showUserInfoForm ? '關閉' : '更新個人資料'),
                  onPressed: () {
                    setState(() {
                      _showUserInfoForm = !_showUserInfoForm;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 用戶信息表單
            if (_showUserInfoForm) _buildUserInfoForm(),

            // 平均血壓信息
            if (!_showUserInfoForm) ...[
              _buildBloodPressureInfo(averageSystolic, averageDiastolic, bpRiskLevel),
              const SizedBox(height: 24),

              // 風險評分
              const Text('風險評分', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildRiskScoreCard('心血管疾病風險', cvdRiskScore, 10.0, Colors.red)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRiskScoreCard('中風風險', strokeRiskScore, 10.0, Colors.orange)),
                ],
              ),
              const SizedBox(height: 24),

              // 健康建議
              const Text('健康建議', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...recommendations.map((recommendation) => _buildRecommendationItem(recommendation)),
            ],
          ],
        ),
      ),
    );
  }

  // 構建用戶信息表單
  Widget _buildUserInfoForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('個人健康資料', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // 年齡
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: '年齡', border: OutlineInputBorder(), suffixText: '歲'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '請輸入年齡';
                }
                final age = int.tryParse(value);
                if (age == null || age < 18 || age > 120) {
                  return '請輸入有效年齡 (18-120)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 性別
            Row(
              children: [
                const Text('性別：', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                Radio<String>(
                  value: '男',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const Text('男'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: '女',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const Text('女'),
              ],
            ),
            const SizedBox(height: 16),

            // 糖尿病
            Row(
              children: [
                Checkbox(
                  value: _hasDiabetes,
                  onChanged: (value) {
                    setState(() {
                      _hasDiabetes = value!;
                    });
                  },
                ),
                const Text('我有糖尿病'),
              ],
            ),

            // 吸煙
            Row(
              children: [
                Checkbox(
                  value: _isSmoking,
                  onChanged: (value) {
                    setState(() {
                      _isSmoking = value!;
                    });
                  },
                ),
                const Text('我有吸煙習慣'),
              ],
            ),
            const SizedBox(height: 16),

            // 膽固醇
            TextFormField(
              controller: _cholesterolController,
              decoration: const InputDecoration(labelText: '總膽固醇', border: OutlineInputBorder(), suffixText: 'mg/dL'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '請輸入總膽固醇值';
                }
                final cholesterol = double.tryParse(value);
                if (cholesterol == null || cholesterol < 100 || cholesterol > 400) {
                  return '請輸入有效膽固醇值 (100-400)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // 提交按鈕
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitUserInfo,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text('更新資料'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 提交用戶信息
  void _submitUserInfo() {
    if (_formKey.currentState!.validate()) {
      final userInfo = {
        'age': int.parse(_ageController.text),
        'gender': _selectedGender,
        'hasDiabetes': _hasDiabetes,
        'isSmoking': _isSmoking,
        'cholesterolLevel': double.parse(_cholesterolController.text),
      };

      widget.onUpdateUserInfo(userInfo);

      setState(() {
        _showUserInfoForm = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('個人資料已更新，風險評估已重新計算')));
    } else {
      // 顯示錯誤對話框
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('輸入錯誤'),
              content: const Text('請檢查您輸入的資料是否正確'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('確定'))],
            ),
      );
    }
  }

  // 構建血壓信息
  Widget _buildBloodPressureInfo(int systolic, int diastolic, String riskLevel) {
    Color riskColor;
    String riskText;

    switch (riskLevel) {
      case 'normal':
        riskColor = Colors.green;
        riskText = '正常';
        break;
      case 'elevated':
        riskColor = Colors.yellow.shade800;
        riskText = '偏高';
        break;
      case 'hypertension1':
        riskColor = Colors.orange;
        riskText = '高血壓一期';
        break;
      case 'hypertension2':
        riskColor = Colors.red;
        riskText = '高血壓二期';
        break;
      case 'crisis':
        riskColor = Colors.purple;
        riskText = '高血壓危象';
        break;
      default:
        riskColor = Colors.grey;
        riskText = '未知';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: riskColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: riskColor),
              const SizedBox(width: 8),
              Text('平均血壓: $systolic/$diastolic mmHg', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: riskColor, borderRadius: BorderRadius.circular(4)),
                child: Text(riskText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(_getRiskLevelDescription(riskLevel), style: TextStyle(color: riskColor))),
            ],
          ),
        ],
      ),
    );
  }

  // 獲取風險等級描述
  String _getRiskLevelDescription(String riskLevel) {
    switch (riskLevel) {
      case 'normal':
        return '您的血壓處於正常範圍，繼續保持健康的生活方式。';
      case 'elevated':
        return '您的血壓略高於正常值，建議調整生活方式以防止高血壓。';
      case 'hypertension1':
        return '您的血壓處於高血壓一期，建議諮詢醫生並調整生活方式。';
      case 'hypertension2':
        return '您的血壓處於高血壓二期，需要醫療干預和生活方式改變。';
      case 'crisis':
        return '您的血壓處於危險水平，請立即就醫！';
      default:
        return '無法確定血壓風險等級。';
    }
  }

  // 構建風險評分卡片
  Widget _buildRiskScoreCard(String title, double score, double maxScore, Color color) {
    final percentage = (score / maxScore) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  children: [
                    Text(score.toStringAsFixed(1), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                    Text('/ $maxScore', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(_getRiskScoreDescription(score, maxScore), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  // 獲取風險評分描述
  String _getRiskScoreDescription(double score, double maxScore) {
    final percentage = (score / maxScore) * 100;

    if (percentage < 20) {
      return '風險較低';
    } else if (percentage < 40) {
      return '風險輕微';
    } else if (percentage < 60) {
      return '風險中等';
    } else if (percentage < 80) {
      return '風險較高';
    } else {
      return '風險非常高';
    }
  }

  // 構建建議項目
  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(recommendation)),
          ],
        ),
      ),
    );
  }
}
