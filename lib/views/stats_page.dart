// 血壓記錄 App 統計頁面
// 用於顯示血壓統計數據

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/blood_pressure_record.dart';
import '../services/mock_data_service.dart';
import '../themes/app_theme.dart';
import '../widgets/trend_chart.dart';
import '../utils/date_time_utils.dart';

class StatsPage extends StatefulWidget {
  final TimeRange initialTimeRange;

  const StatsPage({super.key, this.initialTimeRange = TimeRange.month});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  late TimeRange _selectedTimeRange;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _selectedTimeRange = widget.initialTimeRange;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final records = MockDataService.getRecordsByTimeRange(_selectedTimeRange);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
        title: const Text('血壓統計', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [Tab(text: '趨勢圖'), Tab(text: '數據表')],
        ),
      ),
      body: Column(
        children: [
          _buildTimeRangeSelector(context),
          Expanded(child: TabBarView(controller: _tabController, children: [_buildTrendTab(records), _buildDataTableTab(records)])),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeRangeButton(context, TimeRange.week, '7天'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.twoWeeks, '2週'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.month, '1月'),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(BuildContext context, TimeRange timeRange, String label) {
    final isSelected = _selectedTimeRange == timeRange;

    return GestureDetector(
      onTap: () {
        if (_selectedTimeRange != timeRange) {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedTimeRange = timeRange;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor, width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendTab(List<BloodPressureRecord> records) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shadowColor: AppTheme.primaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2)),
                      ),
                      const SizedBox(width: 8),
                      Text('血壓趨勢', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: 250, child: TrendChart(records: records)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildStatisticsCard(records),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(List<BloodPressureRecord> records) {
    if (records.isEmpty) {
      return Card(
        elevation: 2,
        shadowColor: AppTheme.primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('暫無數據', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey))),
        ),
      );
    }

    final avgSystolic = records.map((e) => e.systolic).reduce((a, b) => a + b) ~/ records.length;
    final avgDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a + b) ~/ records.length;
    final avgPulse = records.map((e) => e.pulse).reduce((a, b) => a + b) ~/ records.length;

    final maxSystolic = records.map((e) => e.systolic).reduce((a, b) => a > b ? a : b);
    final minSystolic = records.map((e) => e.systolic).reduce((a, b) => a < b ? a : b);
    final maxDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a > b ? a : b);
    final minDiastolic = records.map((e) => e.diastolic).reduce((a, b) => a < b ? a : b);

    return Card(
      elevation: 2,
      shadowColor: AppTheme.primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 4, height: 20, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text('統計數據', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatRow('平均收縮壓', '$avgSystolic mmHg', AppTheme.primaryColor),
            _buildStatRow('平均舒張壓', '$avgDiastolic mmHg', AppTheme.successColor),
            _buildStatRow('平均心率', '$avgPulse bpm', Colors.orange),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
            _buildStatRow('最高收縮壓', '$maxSystolic mmHg', AppTheme.primaryColor),
            _buildStatRow('最低收縮壓', '$minSystolic mmHg', AppTheme.primaryColor),
            _buildStatRow('最高舒張壓', '$maxDiastolic mmHg', AppTheme.successColor),
            _buildStatRow('最低舒張壓', '$minDiastolic mmHg', AppTheme.successColor),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
            _buildStatRow('記錄總數', '${records.length} 筆', Colors.grey[700]!),
            _buildStatRow('記錄時間範圍', _getTimeRangeText(), Colors.grey[700]!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 15, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  String _getTimeRangeText() {
    switch (_selectedTimeRange) {
      case TimeRange.week:
        return '最近 7 天';
      case TimeRange.twoWeeks:
        return '最近 2 週';
      case TimeRange.month:
        return '最近 1 個月';
    }
  }

  Widget _buildDataTableTab(List<BloodPressureRecord> records) {
    if (records.isEmpty) {
      return const Center(child: Text('暫無數據', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)));
    }

    // 按時間排序
    final sortedRecords = List<BloodPressureRecord>.from(records)..sort((a, b) => b.measureTime.compareTo(a.measureTime));

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: sortedRecords.length,
      itemBuilder: (context, index) {
        final record = sortedRecords[index];
        final isBPHigh = record.systolic >= 140 || record.diastolic >= 90;
        final isBPNormal = record.systolic < 120 && record.diastolic < 80;
        final statusColor = isBPHigh ? AppTheme.warningColor : (isBPNormal ? AppTheme.successColor : AppTheme.alertColor);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shadowColor: AppTheme.primaryColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: statusColor.withOpacity(0.3), width: 1)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(
                children: [
                  Text(
                    '${record.systolic}/${record.diastolic}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey[800]),
                  ),
                  const SizedBox(width: 8),
                  Text('mmHg', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: statusColor, size: 16),
                        const SizedBox(width: 4),
                        Text('${record.pulse}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: statusColor)),
                        const SizedBox(width: 2),
                        Text('bpm', style: TextStyle(color: statusColor, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          DateTimeUtils.formatDateMMDD(record.measureTime),
                          style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          DateTimeUtils.formatTimeHHMM(record.measureTime),
                          style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    if (record.note != null && record.note!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.note, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Flexible(child: Text(record.note!, style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.w500))),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
