/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-15 18:45:30
 * @ Description: 血壓記錄 App 統計頁面 - 顯示血壓和心率的統計數據、趨勢圖和數據表
 */

// 血壓記錄 App 統計頁面
// 用於顯示血壓統計數據

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/blood_pressure_record.dart';
import '../services/mock_data_service.dart';
import '../themes/app_theme.dart';
import '../widgets/trend_chart.dart';
import '../utils/date_time_utils.dart';
import 'package:intl/intl.dart';

class StatsPage extends StatefulWidget {
  final TimeRange initialTimeRange;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const StatsPage({super.key, this.initialTimeRange = TimeRange.month, this.initialStartDate, this.initialEndDate});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  late TimeRange _selectedTimeRange;
  late TabController _tabController;
  DateTime? _startDate;
  DateTime? _endDate;
  List<BloodPressureRecord> _records = [];
  bool _showPulse = true; // 默認顯示心率

  @override
  void initState() {
    super.initState();
    _selectedTimeRange = widget.initialTimeRange;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _tabController = TabController(length: 2, vsync: this);

    // 如果初始時間範圍是自定義範圍，則設置默認的日期範圍
    if (_selectedTimeRange == TimeRange.custom && _startDate == null && _endDate == null) {
      final now = DateTime.now();
      _startDate = now.subtract(const Duration(days: 30));
      _endDate = now;
    }

    _loadRecords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadRecords() {
    if (_selectedTimeRange == TimeRange.custom && _startDate != null && _endDate != null) {
      _records = MockDataService.getRecordsByDateRange(_startDate!, _endDate!);
    } else {
      _records = MockDataService.getRecordsByTimeRange(_selectedTimeRange);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          unselectedLabelColor: Colors.white.withAlpha(179), // 0.7 * 255 ≈ 179
          tabs: const [Tab(text: '趨勢圖'), Tab(text: '數據表')],
        ),
      ),
      body: Column(
        children: [
          _buildTimeRangeSelector(context),
          if (_selectedTimeRange == TimeRange.custom) _buildDateRangeSelector(context),
          Expanded(child: TabBarView(controller: _tabController, children: [_buildTrendTab(_records), _buildDataTableTab(_records)])),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2))], // 0.05 * 255 ≈ 13
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeRangeButton(context, TimeRange.week, '7天'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.twoWeeks, '2週'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.month, '1月'),
          const SizedBox(width: 12),
          _buildTimeRangeButton(context, TimeRange.custom, '自訂'),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    final startDateText = _startDate != null ? dateFormat.format(_startDate!) : '選擇開始日期';
    final endDateText = _endDate != null ? dateFormat.format(_endDate!) : '選擇結束日期';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2))], // 0.05 * 255 ≈ 13
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, isStartDate: true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.dividerColor), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          startDateText,
                          style: TextStyle(
                            color: _startDate != null ? Colors.black87 : Colors.grey,
                            fontWeight: _startDate != null ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('至', style: TextStyle(color: Colors.grey))),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, isStartDate: false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(border: Border.all(color: AppTheme.dividerColor), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          endDateText,
                          style: TextStyle(
                            color: _endDate != null ? Colors.black87 : Colors.grey,
                            fontWeight: _endDate != null ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 120.0,
              child: ElevatedButton.icon(
                onPressed:
                    _startDate != null && _endDate != null
                        ? () {
                          setState(() {
                            _loadRecords();
                          });
                        }
                        : null,
                icon: const Icon(Icons.search, size: 18),
                label: const Text('查詢', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  shadowColor: AppTheme.primaryColor.withAlpha(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final initialDate = isStartDate ? _startDate ?? DateTime.now().subtract(const Duration(days: 30)) : _endDate ?? DateTime.now();
    final firstDate = isStartDate ? DateTime(2020) : (_startDate ?? DateTime(2020));
    final lastDate = isStartDate ? (_endDate ?? DateTime.now()) : DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor, onPrimary: Colors.white, onSurface: Colors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          // 如果開始日期晚於結束日期，或結束日期未設置，則將結束日期設為開始日期
          if (_endDate == null || _startDate!.isAfter(_endDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = pickedDate;
          // 如果結束日期早於開始日期，或開始日期未設置，則將開始日期設為結束日期
          if (_startDate == null || _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  Widget _buildTimeRangeButton(BuildContext context, TimeRange timeRange, String label) {
    final isSelected = _selectedTimeRange == timeRange;

    return GestureDetector(
      onTap: () {
        if (_selectedTimeRange != timeRange) {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedTimeRange = timeRange;
            if (timeRange != TimeRange.custom) {
              _loadRecords();
            } else {
              // 設置默認的日期範圍
              final now = DateTime.now();
              if (_startDate == null) {
                _startDate = now.subtract(const Duration(days: 30));
              }
              if (_endDate == null) {
                _endDate = now;
              }
            }
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
          boxShadow:
              isSelected
                  ? [BoxShadow(color: AppTheme.primaryColor.withAlpha(77), blurRadius: 8, offset: const Offset(0, 2))]
                  : null, // 0.3 * 255 ≈ 77
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
            shadowColor: AppTheme.primaryColor.withAlpha(77), // 0.3 * 255 ≈ 77
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // 添加心率顯示切換
                      Row(
                        children: [
                          Text('顯示心率', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14)),
                          const SizedBox(width: 8),
                          Switch(
                            value: _showPulse,
                            onChanged: (value) {
                              setState(() {
                                _showPulse = value;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: 250, child: TrendChart(records: records, showPulse: _showPulse)),
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
        shadowColor: AppTheme.primaryColor.withAlpha(77), // 0.3 * 255 ≈ 77
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
    final maxPulse = records.map((e) => e.pulse).reduce((a, b) => a > b ? a : b);
    final minPulse = records.map((e) => e.pulse).reduce((a, b) => a < b ? a : b);

    return Card(
      elevation: 2,
      shadowColor: AppTheme.primaryColor.withAlpha(77), // 0.3 * 255 ≈ 77
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
            _buildStatRow('最高心率', '$maxPulse bpm', Colors.orange),
            _buildStatRow('最低心率', '$minPulse bpm', Colors.orange),
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
      case TimeRange.custom:
        if (_startDate != null && _endDate != null) {
          final dateFormat = DateFormat('yyyy/MM/dd');
          return '${dateFormat.format(_startDate!)} 至 ${dateFormat.format(_endDate!)}';
        }
        return '自定義日期範圍';
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

        // 獲取心率狀態顏色
        final pulseColor = _getPulseStatusColor(record.pulse);
        final pulseIcon = _getPulseStatusIcon(record.pulse);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shadowColor: AppTheme.primaryColor.withAlpha(51), // 0.2 * 255 ≈ 51
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withAlpha(77), width: 1),
            ), // 0.3 * 255 ≈ 77
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
                      color: pulseColor.withAlpha(26), // 0.1 * 255 ≈ 26
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: pulseColor.withAlpha(77)), // 0.3 * 255 ≈ 77
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(pulseIcon, color: pulseColor, size: 16),
                        const SizedBox(width: 4),
                        Text('${record.pulse}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: pulseColor)),
                        const SizedBox(width: 2),
                        Text('bpm', style: TextStyle(color: pulseColor, fontSize: 12)),
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

  // 獲取心率狀態顏色
  Color _getPulseStatusColor(int pulse) {
    if (pulse < 60) {
      return Colors.blue; // 心率過低
    } else if (pulse > 100) {
      return AppTheme.warningColor; // 心率過高
    } else {
      return AppTheme.successColor; // 心率正常
    }
  }

  // 獲取心率狀態圖標
  IconData _getPulseStatusIcon(int pulse) {
    if (pulse < 60) {
      return Icons.arrow_downward; // 心率過低
    } else if (pulse > 100) {
      return Icons.arrow_upward; // 心率過高
    } else {
      return Icons.favorite; // 心率正常
    }
  }
}
