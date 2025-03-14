/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-15 17:25:30
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
import '../utils/date_time_utils.dart';
import '../widgets/trend_chart.dart';
import '../widgets/health_tip_card.dart';
import '../themes/app_theme.dart';
import '../views/record_page.dart';
import '../views/stats_page.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              if (!isMeasuredToday)
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildMeasurementStatus(context, isMeasuredToday)),
              const SizedBox(height: 24),
              if (lastRecord != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(AppConstants.lastMeasurement, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 12),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildLastMeasurementCard(context, lastRecord)),
                const SizedBox(height: 24),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getTrendTitle(), style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600)),
                    _buildTimeRangeSelector(context),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildTrendCard(context, _records),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(AppConstants.healthTips, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              ...selectedTips.map((tip) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), child: HealthTipCard(tip: tip))),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  // 根據選擇的時間範圍獲取標題
  String _getTrendTitle() {
    switch (_selectedTimeRange) {
      case TimeRange.week:
        return AppConstants.weeklyTrend;
      case TimeRange.twoWeeks:
        return AppConstants.twoWeeksTrend;
      case TimeRange.month:
        return AppConstants.monthlyTrend;
      default:
        return AppConstants.weeklyTrend;
    }
  }

  // 構建時間範圍選擇器
  Widget _buildTimeRangeSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeRangeButton(context, TimeRange.week, '7天'),
          _buildTimeRangeButton(context, TimeRange.twoWeeks, '2週'),
          _buildTimeRangeButton(context, TimeRange.month, '1月'),
        ],
      ),
    );
  }

  // 構建時間範圍按鈕
  Widget _buildTimeRangeButton(BuildContext context, TimeRange timeRange, String label) {
    final isSelected = _selectedTimeRange == timeRange;

    return GestureDetector(
      onTap: () {
        if (_selectedTimeRange != timeRange) {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedTimeRange = timeRange;
            _loadRecords();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? AppTheme.primaryColor : Colors.transparent, borderRadius: BorderRadius.circular(14)),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
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

  Widget _buildHeader(BuildContext context) {
    final greeting = DateTimeUtils.getGreeting();
    final currentDate = DateTimeUtils.getFullCurrentDate();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting，用戶', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 26)),
          const SizedBox(height: 4),
          Text(currentDate, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondaryColor, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildMeasurementStatus(BuildContext context, bool isMeasuredToday) {
    final successColorLight = AppTheme.successColor.withAlpha(20);
    final alertColorLight = AppTheme.alertColor.withAlpha(20);
    final successColorBorder = AppTheme.successColor.withAlpha(77);
    final alertColorBorder = AppTheme.alertColor.withAlpha(77);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isMeasuredToday ? successColorLight : alertColorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isMeasuredToday ? successColorBorder : alertColorBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMeasuredToday ? AppTheme.successColor.withAlpha(38) : AppTheme.alertColor.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isMeasuredToday ? Icons.check_circle : Icons.notifications_none,
              color: isMeasuredToday ? AppTheme.successColor : AppTheme.alertColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMeasuredToday ? '已完成今日測量' : '今日尚未測量',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: isMeasuredToday ? AppTheme.successColor : AppTheme.alertColor),
                ),
                if (!isMeasuredToday)
                  Text('建議每日測量血壓以保持健康追蹤', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastMeasurementCard(BuildContext context, BloodPressureRecord record) {
    final isBPHigh = record.systolic >= 140 || record.diastolic >= 90;
    final isBPNormal = record.systolic < 120 && record.diastolic < 80;
    final statusColor = isBPHigh ? AppTheme.warningColor : (isBPNormal ? AppTheme.successColor : AppTheme.alertColor);
    final statusText = isBPHigh ? '偏高' : (isBPNormal ? '正常' : '臨界');

    // 根據血壓狀態選擇圖標
    IconData statusIcon;
    if (isBPHigh) {
      statusIcon = Icons.warning_amber_rounded;
    } else if (isBPNormal) {
      statusIcon = Icons.check_circle_outline;
    } else {
      statusIcon = Icons.info_outline;
    }

    return Card(
      elevation: 1,
      shadowColor: AppTheme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '今天 ${DateTimeUtils.formatTimeHHMM(record.measureTime)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondaryColor),
                ),
                GestureDetector(
                  onTap: () {
                    if (statusText == '臨界') {
                      _showBorderlineExplanation(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: statusColor.withAlpha(26), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 16),
                        const SizedBox(width: 4),
                        Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14)),
                        if (statusText == '臨界') ...[const SizedBox(width: 4), Icon(Icons.help_outline, color: statusColor, size: 14)],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBPValueColumn(
                  context,
                  record.systolic.toString(),
                  'SYS',
                  'mmHg',
                  isBPHigh ? (record.systolic >= 140 ? AppTheme.warningColor : AppTheme.alertColor) : AppTheme.textPrimaryColor,
                ),
                Container(height: 50, width: 1, color: AppTheme.dividerColor),
                _buildBPValueColumn(
                  context,
                  record.diastolic.toString(),
                  'DIA',
                  'mmHg',
                  isBPHigh ? (record.diastolic >= 90 ? AppTheme.warningColor : AppTheme.alertColor) : AppTheme.textPrimaryColor,
                ),
                Container(height: 50, width: 1, color: AppTheme.dividerColor),
                _buildBPValueColumn(context, record.pulse.toString(), 'PULSE', 'bpm', AppTheme.textPrimaryColor),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMeasurementTag(context, '備註: ${record.note}'),
                const SizedBox(width: 8),
                _buildMeasurementTag(context, record.position),
                if (record.arm.isNotEmpty) ...[const SizedBox(width: 8), _buildMeasurementTag(context, record.arm)],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBPValueColumn(BuildContext context, String value, String label, String unit, Color valueColor) {
    // 根據數值顏色選擇適當的圖標
    IconData? valueIcon;
    if (valueColor == AppTheme.warningColor) {
      valueIcon = Icons.arrow_upward;
    } else if (valueColor == AppTheme.alertColor) {
      valueIcon = Icons.arrow_upward;
    } else if (valueColor == AppTheme.successColor) {
      valueIcon = Icons.check;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: valueColor, fontSize: 36)),
            if (valueIcon != null) Padding(padding: const EdgeInsets.only(left: 2, top: 4), child: Icon(valueIcon, color: valueColor, size: 16)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w500)),
        Text(unit, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
      ],
    );
  }

  Widget _buildMeasurementTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(16)),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
    );
  }

  Widget _buildTrendCard(BuildContext context, List<BloodPressureRecord> records) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: AppTheme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 220, padding: const EdgeInsets.only(top: 8), child: TrendChart(records: records)),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(6))),
                    const SizedBox(width: 4),
                    Text('收縮壓', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                    const SizedBox(width: 16),
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: AppTheme.successColor, borderRadius: BorderRadius.circular(6))),
                    const SizedBox(width: 4),
                    Text('舒張壓', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // 導航到統計頁面，並傳遞當前選擇的時間範圍
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => StatsPage(initialTimeRange: _selectedTimeRange))).then((_) {
                      // 返回時刷新數據
                      setState(() {
                        _loadRecords();
                      });
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('查看詳情'), const SizedBox(width: 4), const Icon(Icons.arrow_forward, size: 16)],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 顯示臨界狀態的解釋
  void _showBorderlineExplanation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('什麼是臨界血壓？', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('臨界血壓是指血壓值處於正常值和高血壓之間的狀態：'),
              SizedBox(height: 8),
              Text('• 收縮壓在 120-139 mmHg 之間'),
              Text('• 舒張壓在 80-89 mmHg 之間'),
              SizedBox(height: 12),
              Text('處於臨界狀態時，雖然尚未達到高血壓標準，但已有發展為高血壓的風險。建議：'),
              SizedBox(height: 8),
              Text('• 定期監測血壓變化'),
              Text('• 保持健康的生活方式'),
              Text('• 適當控制鹽分攝入'),
              Text('• 規律運動'),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('了解了'))],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        );
      },
    );
  }
}
