/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
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
import 'package:share_plus/share_plus.dart';

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

    // 確保日期不超過當前日期
    final now = DateTime.now();
    if (_startDate != null && _startDate!.isAfter(now)) {
      _startDate = now.subtract(const Duration(days: 30));
    }
    if (_endDate != null && _endDate!.isAfter(now)) {
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
          // 添加匯出按鈕
          IconButton(icon: const Icon(Icons.file_download), tooltip: context.tr('匯出數據'), onPressed: () => _showExportOptions(context)),
          // 添加生成報告按鈕
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
                  onExportData: () => _showExportOptions(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 顯示匯出選項
  void _showExportOptions(BuildContext context) {
    if (_filteredRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('暫無數據，無法匯出'))));
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(context.tr('選擇匯出格式'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: Text(context.tr('匯出為 CSV 檔案')),
                subtitle: Text(context.tr('適用於 Excel、Google 試算表等')),
                onTap: () {
                  Navigator.pop(context);
                  _exportData(context, 'csv');
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_view, color: Colors.blue),
                title: Text(context.tr('匯出為 Excel 檔案')),
                subtitle: Text(context.tr('包含格式化和顏色標記')),
                onTap: () {
                  Navigator.pop(context);
                  _exportData(context, 'excel');
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // 匯出數據
  Future<void> _exportData(BuildContext context, String format) async {
    if (_filteredRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('暫無數據，無法匯出'))));
      return;
    }

    // 提前獲取並保存需要的翻譯文本
    final recordDataText = context.tr('血壓記錄數據');
    String formatGeneratedText(String formatName) => context.tr('$formatName 檔案已生成');
    final exportFailedText = context.tr('匯出失敗：');

    // 保存 ScaffoldMessenger 的引用
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // 顯示加載對話框
    final loadingDialog = _showLoadingDialog(context);

    try {
      String filePath;
      String formatName;

      if (format == 'csv') {
        filePath = await ReportService.generateCSV(_filteredRecords);
        formatName = 'CSV';
      } else {
        filePath = await ReportService.generateExcel(_filteredRecords);
        formatName = 'Excel';
      }

      // 檢查 widget 是否仍然掛載在 widget 樹上
      if (!mounted) return;

      // 關閉加載對話框
      loadingDialog.dismiss();

      // 分享文件
      await Share.shareXFiles([XFile(filePath)], text: recordDataText);

      // 檢查 widget 是否仍然掛載在 widget 樹上
      if (!mounted) return;

      // 使用保存的 scaffoldMessenger 引用顯示成功消息
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(formatGeneratedText(formatName)), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      // 檢查 widget 是否仍然掛載在 widget 樹上
      if (!mounted) return;

      // 關閉加載對話框
      loadingDialog.dismiss();

      // 使用保存的 scaffoldMessenger 引用顯示錯誤消息
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('$exportFailedText$e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
    }
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

    // 提前獲取時間範圍文本
    final String timeRangeText = _getTimeRangeText(context);

    // 顯示加載對話框
    final loadingDialog = _showLoadingDialog(context);

    try {
      // 計算統計數據
      final Map<String, double> statistics = StatsUtils.calculateStatistics(_filteredRecords);

      // 計算血壓分類統計
      final Map<String, int> categoryCounts = StatsUtils.calculateCategoryCounts(_filteredRecords);

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

      // 檢查 widget 是否仍然掛載在 widget 樹上
      if (!mounted) return;

      // 顯示成功消息
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('$reportTitleText已生成'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      // 檢查 widget 是否仍然掛載在 widget 樹上
      if (!mounted) return;

      // 關閉加載對話框
      loadingDialog.dismiss();

      // 顯示錯誤消息
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('$reportFailedText: $e'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
      );
    }
  }

  // 顯示加載對話框
  LoadingDialog _showLoadingDialog(BuildContext context) {
    return LoadingDialog.show(context);
  }

  // 獲取時間範圍文本
  String _getTimeRangeText(BuildContext context) {
    switch (_selectedTimeRange) {
      case TimeRange.week:
        return context.tr('近 7 天');
      case TimeRange.twoWeeks:
        return context.tr('近 14 天');
      case TimeRange.month:
        return context.tr('近 30 天');
      case TimeRange.custom:
        if (_startDate != null && _endDate != null) {
          final dateFormat = DateFormat('yyyy/MM/dd');
          return '${dateFormat.format(_startDate!)} - ${dateFormat.format(_endDate!)}';
        }
        return context.tr('自定義時間範圍');
    }
  }
}

// 加載對話框
class LoadingDialog {
  final BuildContext context;
  final OverlayEntry _overlayEntry;
  bool _isShowing = true;

  LoadingDialog._(this.context, this._overlayEntry);

  static LoadingDialog show(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Material(
            color: Colors.black.withAlpha(77),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(context.tr('處理中...'), style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    return LoadingDialog._(context, overlayEntry);
  }

  void dismiss() {
    if (_isShowing) {
      _overlayEntry.remove();
      _isShowing = false;
    }
  }
}
