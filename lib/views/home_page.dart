// 血壓記錄 App 首頁
// 顯示用戶的血壓記錄和健康建議

import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/app_constants.dart';
import '../models/blood_pressure_record.dart';
import '../services/mock_data_service.dart';
import '../utils/date_time_utils.dart';
import '../widgets/blood_pressure_card.dart';
import '../widgets/trend_chart.dart';
import '../widgets/health_tip_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final lastRecord = MockDataService.getLastBloodPressureRecord();
    final isMeasuredToday = MockDataService.isMeasuredToday();
    final last7DaysRecords = MockDataService.getLast7DaysRecords();

    // 隨機選擇 3 條健康建議
    final random = Random();
    final healthTips = List<String>.from(AppConstants.healthTipsList)..shuffle(random);
    final selectedTips = healthTips.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildMeasurementStatus(context, isMeasuredToday),
                const SizedBox(height: 16),
                if (lastRecord != null) ...[
                  Text(AppConstants.lastMeasurement, style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 8),
                  BloodPressureCard(record: lastRecord),
                  const SizedBox(height: 24),
                ],
                Text(AppConstants.weeklyTrend, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                _buildTrendCard(context, last7DaysRecords),
                const SizedBox(height: 24),
                Text(AppConstants.healthTips, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                ...selectedTips.map((tip) => Padding(padding: const EdgeInsets.only(bottom: 8), child: HealthTipCard(tip: tip))),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 導航到記錄頁面
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final greeting = DateTimeUtils.getGreeting();
    final currentDate = DateTimeUtils.getFullCurrentDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$greeting，用戶', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 4),
        Text(currentDate, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildMeasurementStatus(BuildContext context, bool isMeasuredToday) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMeasuredToday ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isMeasuredToday ? Colors.green[300]! : Colors.orange[300]!),
      ),
      child: Row(
        children: [
          Icon(isMeasuredToday ? Icons.check_circle_outline : Icons.info_outline, color: isMeasuredToday ? Colors.green[700] : Colors.orange[700]),
          const SizedBox(width: 12),
          Text(
            isMeasuredToday ? AppConstants.todayMeasured : AppConstants.todayNotMeasured,
            style: theme.textTheme.bodyMedium?.copyWith(color: isMeasuredToday ? Colors.green[700] : Colors.orange[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(BuildContext context, List<BloodPressureRecord> records) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 200, child: TrendChart(records: records)),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: 導航到統計頁面
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(AppConstants.viewDetails), const SizedBox(width: 4), const Icon(Icons.arrow_forward, size: 16)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
