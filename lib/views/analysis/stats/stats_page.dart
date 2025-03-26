/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-15 16:16:42
 * @ Description: 血壓記錄 App 統計頁面 - 顯示血壓和心率的統計數據、趨勢圖和數據表
 */

// 血壓記錄 App 統計頁面
// 用於顯示血壓統計數據

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/blood_pressure_record.dart';
import '../../../services/mock_data_service.dart';
import '../../../services/export_service.dart';
import '../../../utils/stats_utils.dart';
import '../advanced_features/advanced_features_page.dart';
import 'widgets/time_range_selector.dart';
import 'widgets/date_range_selector.dart';
import 'widgets/stats_trend_tab.dart';
import 'widgets/stats_data_table_tab.dart';
import '../../../widgets/common/filter_sort_panel.dart';
import '../../../l10n/app_localizations_extension.dart';
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
    _tabController = TabController(length: 3, vsync: this);

    // 添加標籤切換事件監聽
    _tabController.addListener(_handleTabSelection);

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

  // 處理標籤切換事件
  void _handleTabSelection() {
    // 只有當標籤索引為 2（高級功能）且不是由程式自動設置時才跳轉
    if (_tabController.index == 2 && _tabController.indexIsChanging) {
      // 延遲執行以避免在動畫過程中進行導航
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          // 將標籤切換回之前的標籤（避免重複導航）
          _tabController.animateTo(0);
          // 導航到高級功能頁面
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvancedFeaturesPage()));
        }
      });
    }
  }

  @override
  void dispose() {
    // 移除標籤切換事件監聽
    _tabController.removeListener(_handleTabSelection);
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
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: brightness == Brightness.dark ? const Color(0xFF121212) : theme.primaryColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
          statusBarBrightness: brightness == Brightness.light ? Brightness.light : Brightness.dark,
        ),
        title: Text(context.tr('血壓統計'), style: TextStyle(color: theme.appBarTheme.foregroundColor, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        actions: [
          // 添加匯出按鈕
          IconButton(
            icon: Icon(Icons.file_download, color: theme.appBarTheme.foregroundColor),
            tooltip: context.tr('匯出數據'),
            onPressed: () => _showExportOptions(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.appBarTheme.foregroundColor,
          indicatorWeight: 3,
          labelColor: theme.appBarTheme.foregroundColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelColor: theme.appBarTheme.foregroundColor?.withAlpha(179),
          tabs: [Tab(text: context.tr('趨勢圖')), Tab(text: context.tr('歷史記錄')), Tab(text: context.tr('高級功能'))],
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
                Builder(
                  builder: (context) {
                    // 顯示一個loading視圖，因為會立即跳轉
                    return const Center(child: CircularProgressIndicator());
                  },
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
    final theme = Theme.of(context);

    if (_filteredRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('暫無數據，無法匯出'))));
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  context.tr('選擇匯出格式'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color),
                ),
              ),
              Divider(color: theme.dividerColor),
              ListTile(
                leading: Icon(Icons.table_chart, color: theme.colorScheme.primary),
                title: Text(context.tr('匯出為 CSV 檔案'), style: TextStyle(color: theme.textTheme.titleMedium?.color)),
                subtitle: Text(context.tr('適用於 Excel、Google 試算表等'), style: TextStyle(color: theme.textTheme.bodySmall?.color)),
                onTap: () {
                  Navigator.pop(context);
                  _exportData(context, 'csv');
                },
              ),
              ListTile(
                leading: Icon(Icons.table_view, color: theme.colorScheme.secondary),
                title: Text(context.tr('匯出為 Excel 檔案'), style: TextStyle(color: theme.textTheme.titleMedium?.color)),
                subtitle: Text(context.tr('包含格式化和顏色標記'), style: TextStyle(color: theme.textTheme.bodySmall?.color)),
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
    // 記錄這個頁面的狀態
    bool isCurrentlyMounted = mounted;

    if (_filteredRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('暫無數據，無法匯出'))));
      return;
    }

    // 先提前獲取所有需要的資源
    final theme = Theme.of(context);
    final recordDataText = context.tr('血壓記錄數據');
    final processingText = context.tr('處理中...');
    final csvGeneratedText = context.tr('CSV 檔案已生成');
    final excelGeneratedText = context.tr('Excel 檔案已生成');
    final exportFailedText = context.tr('匯出失敗：');
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // 使用不依賴於 Navigator 操作的方法
    late final OverlayEntry loadingOverlay;

    // 顯示加載狀態
    loadingOverlay = OverlayEntry(
      builder: (BuildContext ctx) {
        return Material(
          color: Colors.black.withValues(alpha: 128),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: theme.primaryColor),
                  const SizedBox(height: 16),
                  Text(processingText, style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color)),
                ],
              ),
            ),
          ),
        );
      },
    );

    // 將加載層添加到覆蓋層
    if (isCurrentlyMounted) {
      Overlay.of(context).insert(loadingOverlay);
    }

    try {
      // 執行匯出操作
      String filePath;
      String successMessage;

      if (format == 'csv') {
        filePath = await ExportService.generateCSV(_filteredRecords);
        successMessage = csvGeneratedText;
      } else {
        filePath = await ExportService.generateExcel(_filteredRecords);
        successMessage = excelGeneratedText;
      }

      // 移除加載層
      loadingOverlay.remove();

      // 檢查頁面是否仍然可用
      if (!isCurrentlyMounted || !mounted) return;

      // 嘗試分享文件
      try {
        await Share.shareXFiles([XFile(filePath)], text: recordDataText);
        // 顯示成功消息
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(successMessage), backgroundColor: theme.colorScheme.primary, behavior: SnackBarBehavior.floating),
        );
      } catch (shareError) {
        // 文件已生成但分享失敗
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('$successMessage，但分享時出錯'), backgroundColor: theme.colorScheme.secondary, behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      // 移除加載層
      loadingOverlay.remove();

      // 顯示錯誤消息
      if (isCurrentlyMounted && mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('$exportFailedText$e'), backgroundColor: theme.colorScheme.error, behavior: SnackBarBehavior.floating),
        );
      }
    }
  }
}
