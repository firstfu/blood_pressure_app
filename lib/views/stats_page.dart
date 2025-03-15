/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-15 18:45:30
 * @ Description: 血壓記錄 App 統計頁面 - 顯示血壓和心率的統計數據、趨勢圖和數據表
 */

// 血壓記錄 App 統計頁面
// 用於顯示血壓統計數據

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/blood_pressure_record.dart';
import '../services/mock_data_service.dart';
import '../services/report_service.dart';
import '../themes/app_theme.dart';
import '../utils/stats_utils.dart';
import '../views/advanced_features_page.dart';
import '../widgets/stats/time_range_selector.dart';
import '../widgets/stats/date_range_selector.dart';
import '../widgets/stats/stats_trend_tab.dart';
import '../widgets/stats/stats_data_table_tab.dart';
import '../widgets/common/filter_sort_panel.dart';
import '../l10n/app_localizations_extension.dart';

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
  List<BloodPressureRecord> _filteredRecords = [];

  // 篩選和排序相關變數
  RangeValues _systolicRange = const RangeValues(70, 200);
  RangeValues _diastolicRange = const RangeValues(40, 130);
  RangeValues _pulseRange = const RangeValues(40, 160);
  SortField _sortField = SortField.time;
  SortOrder _sortOrder = SortOrder.descending;
  bool _isFiltered = false;

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
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    _filteredRecords = StatsUtils.applyFiltersAndSort(
      records: _records,
      systolicRange: _systolicRange,
      diastolicRange: _diastolicRange,
      pulseRange: _pulseRange,
      sortField: _sortField,
      sortOrder: _sortOrder,
    );

    // 更新是否已篩選的標誌
    _isFiltered = _filteredRecords.length != _records.length || _sortField != SortField.time || _sortOrder != SortOrder.descending;

    setState(() {});
  }

  void _resetFiltersAndSort() {
    setState(() {
      _systolicRange = const RangeValues(70, 200);
      _diastolicRange = const RangeValues(40, 130);
      _pulseRange = const RangeValues(40, 160);
      _sortField = SortField.time;
      _sortOrder = SortOrder.descending;
      _isFiltered = false;
    });
    _applyFiltersAndSort();
  }

  void _onTimeRangeChanged(TimeRange timeRange) {
    setState(() {
      _selectedTimeRange = timeRange;
      if (timeRange != TimeRange.custom) {
        _loadRecords();
      } else {
        // 設置默認的日期範圍
        final now = DateTime.now();
        _startDate ??= now.subtract(const Duration(days: 30));
        _endDate ??= now;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        title: Text(context.tr('血壓統計'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        actions: [
          // 添加進階功能按鈕
          IconButton(
            icon: const Icon(Icons.auto_graph),
            tooltip: context.tr('高級功能'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvancedFeaturesPage()));
            },
          ),
          IconButton(icon: const Icon(Icons.picture_as_pdf), tooltip: context.tr('生成報告'), onPressed: () => _generateReport(context)),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelColor: Colors.white.withAlpha(179),
          tabs: [Tab(text: context.tr('趨勢圖')), Tab(text: context.tr('歷史記錄'))],
        ),
      ),
      body: Column(
        children: [
          TimeRangeSelector(selectedTimeRange: _selectedTimeRange, onTimeRangeChanged: _onTimeRangeChanged),
          if (_selectedTimeRange == TimeRange.custom)
            DateRangeSelector(
              startDate: _startDate,
              endDate: _endDate,
              onStartDateChanged: (date) => setState(() => _startDate = date),
              onEndDateChanged: (date) => setState(() => _endDate = date),
              onSearch: () => setState(() => _loadRecords()),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                StatsTrendTab(records: _filteredRecords, selectedTimeRange: _selectedTimeRange, startDate: _startDate, endDate: _endDate),
                StatsDataTableTab(
                  records: _records,
                  filteredRecords: _filteredRecords,
                  systolicRange: _systolicRange,
                  diastolicRange: _diastolicRange,
                  pulseRange: _pulseRange,
                  sortField: _sortField,
                  sortOrder: _sortOrder,
                  isFiltered: _isFiltered,
                  onSystolicRangeChanged: (value) => _systolicRange = value,
                  onDiastolicRangeChanged: (value) => _diastolicRange = value,
                  onPulseRangeChanged: (value) => _pulseRange = value,
                  onSortFieldChanged: (value) => _sortField = value,
                  onSortOrderChanged: (value) => _sortOrder = value,
                  onResetFiltersAndSort: _resetFiltersAndSort,
                  onApplyFiltersAndSort: _applyFiltersAndSort,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 生成健康報告
  Future<void> _generateReport(BuildContext context) async {
    if (_filteredRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('暫無數據，無法生成報告'))));
      return;
    }

    // 保存當前 context 的引用
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // 提前獲取並保存需要的翻譯文本
    final reportTitleText = context.tr('血壓健康報告');
    final reportFailedText = context.tr('生成報告失敗');
    final recordUnitText = context.tr('筆');

    // 顯示加載對話框
    final loadingDialog = _showLoadingDialog(context);

    try {
      // 計算統計數據
      final Map<String, double> statistics = StatsUtils.calculateStatistics(_filteredRecords);

      // 計算血壓分類統計
      final Map<String, int> categoryCounts = StatsUtils.calculateCategoryCounts(_filteredRecords);

      // 獲取時間範圍文本
      final String timeRangeText = _getTimeRangeText();

      // 獲取開始和結束日期
      final DateTime startDate = _startDate ?? DateTime.now().subtract(const Duration(days: 30));
      final DateTime endDate = _endDate ?? DateTime.now();

      // 生成報告
      final pdfData = await ReportService.generateReport(
        records: _filteredRecords,
        startDate: startDate,
        endDate: endDate,
        categoryCounts: categoryCounts,
        statistics: statistics,
        timeRangeText: timeRangeText,
        recordUnit: recordUnitText,
      );

      // 檢查 widget 是否仍然掛載在 widget 樹上
      if (!mounted) return;

      // 關閉加載對話框
      loadingDialog.dismiss();

      // 生成文件名
      final dateFormat = DateFormat('yyyyMMdd');
      final fileName = '${reportTitleText}_${dateFormat.format(DateTime.now())}.pdf';

      // 保存並分享報告
      await ReportService.saveAndShareReport(pdfData, fileName);
    } catch (e) {
      // 檢查 widget 是否仍然掛載在 widget 樹上
      if (!mounted) return;

      // 關閉加載對話框
      loadingDialog.dismiss();

      // 使用之前保存的 scaffoldMessenger 顯示錯誤訊息，避免使用異步操作後的 context
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('$reportFailedText: $e')));
    }
  }

  // 顯示加載對話框並返回一個可以安全關閉的對話框控制器
  _LoadingDialogController _showLoadingDialog(BuildContext context) {
    final controller = _LoadingDialogController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        controller.dialogContext = dialogContext;
        return const Center(child: CircularProgressIndicator());
      },
    );

    return controller;
  }

  String _getTimeRangeText() {
    final localContext = context; // 保存當前 context 的引用

    switch (_selectedTimeRange) {
      case TimeRange.week:
        return localContext.tr('最近 7 天');
      case TimeRange.twoWeeks:
        return localContext.tr('最近 2 週');
      case TimeRange.month:
        return localContext.tr('最近 1 個月');
      case TimeRange.custom:
        if (_startDate != null && _endDate != null) {
          final dateFormat = DateFormat('yyyy/MM/dd');
          return '${dateFormat.format(_startDate!)} 至 ${dateFormat.format(_endDate!)}';
        }
        return localContext.tr('自定義日期範圍');
    }
  }
}

// 加載對話框控制器，用於安全地關閉對話框
class _LoadingDialogController {
  BuildContext? dialogContext;

  void dismiss() {
    if (dialogContext != null && Navigator.canPop(dialogContext!)) {
      Navigator.pop(dialogContext!);
      dialogContext = null;
    }
  }
}
