/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 首頁 - 顯示用戶的血壓記錄、健康狀態和趨勢圖表
 */

// 血壓記錄 App 首頁
// 顯示用戶的血壓記錄和健康建議

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../constants/app_constants.dart';
import '../models/blood_pressure_record.dart';
import '../services/mock_data_service.dart';
import '../widgets/cards/health_tip_card.dart';
import '../themes/app_theme.dart';
import '../views/record_page.dart';
import '../views/stats_page.dart';
import '../widgets/home/greeting_header.dart';
import '../widgets/home/measurement_status_card.dart';
import '../widgets/home/last_measurement_card.dart';
import '../widgets/home/trend_chart_card.dart';
import '../widgets/home/time_range_selector.dart';
import '../l10n/app_localizations_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  TimeRange _selectedTimeRange = TimeRange.week; // 默認選擇7天
  List<BloodPressureRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _loadRecords();

    // 設置沉浸式狀態欄
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadRecords() {
    _records = MockDataService.getRecordsByTimeRange(_selectedTimeRange);
  }

  @override
  Widget build(BuildContext context) {
    final lastRecord = MockDataService.getLastBloodPressureRecord();
    final isMeasuredToday = MockDataService.isMeasuredToday();

    // 隨機選擇 2 條健康建議
    final random = Random();
    final healthTips = List<String>.from(AppConstants.healthTipsList)..shuffle(random);
    final selectedTips = healthTips.take(2).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 沉浸式頂部問候區域
          const GreetingHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  if (!isMeasuredToday)
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: MeasurementStatusCard(isMeasuredToday: isMeasuredToday)),
                  const SizedBox(height: 24),
                  if (lastRecord != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(context.tr('最近一次測量'), style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 12),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: LastMeasurementCard(record: lastRecord)),
                    const SizedBox(height: 24),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getTrendTitle(), style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600)),
                        HomeTimeRangeSelector(
                          selectedTimeRange: _selectedTimeRange,
                          onTimeRangeChanged: (timeRange) {
                            setState(() {
                              _selectedTimeRange = timeRange;
                              _loadRecords();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TrendChartCard(
                    records: _records,
                    selectedTimeRange: _selectedTimeRange,
                    onViewDetails: () {
                      // 導航到統計頁面，並傳遞當前選擇的時間範圍
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StatsPage(initialTimeRange: _selectedTimeRange))).then((_) {
                        // 返回時刷新數據
                        setState(() {
                          _loadRecords();
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(context.tr('健康建議'), style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  ...selectedTips.map(
                    (tip) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), child: HealthTipCard(tip: tip)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  // 根據選擇的時間範圍獲取標題
  String _getTrendTitle() {
    switch (_selectedTimeRange) {
      case TimeRange.week:
        return context.tr('近 7 天趨勢');
      case TimeRange.twoWeeks:
        return context.tr('近 2 週趨勢');
      case TimeRange.month:
        return context.tr('近 1 個月趨勢');
      default:
        return context.tr('近 7 天趨勢');
    }
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        // 導航到記錄頁面
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecordPage())).then((value) {
          // 如果有新記錄添加，刷新頁面
          if (value == true) {
            setState(() {});
          }
        });
      },
      backgroundColor: AppTheme.primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
