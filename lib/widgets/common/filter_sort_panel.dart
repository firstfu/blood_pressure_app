/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 11:00:30
 * @ Description: 血壓記錄篩選和排序面板元件
 */

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../../l10n/app_localizations_extension.dart';

enum SortField { time, systolic, diastolic, pulse }

enum SortOrder { ascending, descending }

class FilterSortPanel extends StatefulWidget {
  final RangeValues? systolicRange;
  final RangeValues? diastolicRange;
  final RangeValues? pulseRange;
  final SortField sortField;
  final SortOrder sortOrder;
  final Function(RangeValues) onSystolicRangeChanged;
  final Function(RangeValues) onDiastolicRangeChanged;
  final Function(RangeValues) onPulseRangeChanged;
  final Function(SortField) onSortFieldChanged;
  final Function(SortOrder) onSortOrderChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const FilterSortPanel({
    super.key,
    this.systolicRange,
    this.diastolicRange,
    this.pulseRange,
    required this.sortField,
    required this.sortOrder,
    required this.onSystolicRangeChanged,
    required this.onDiastolicRangeChanged,
    required this.onPulseRangeChanged,
    required this.onSortFieldChanged,
    required this.onSortOrderChanged,
    required this.onReset,
    required this.onApply,
  });

  @override
  State<FilterSortPanel> createState() => _FilterSortPanelState();
}

class _FilterSortPanelState extends State<FilterSortPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RangeValues _systolicRange;
  late RangeValues _diastolicRange;
  late RangeValues _pulseRange;
  late SortField _sortField;
  late SortOrder _sortOrder;
  late DraggableScrollableController _panelController;
  int _currentTabIndex = 0;

  // 兩種標籤頁的高度設定
  late double _filterTabInitialSize;
  late double _sortTabInitialSize;
  late double _filterTabMinSize;
  late double _sortTabMinSize;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _panelController = DraggableScrollableController();
    _systolicRange = widget.systolicRange ?? const RangeValues(70, 200);
    _diastolicRange = widget.diastolicRange ?? const RangeValues(40, 130);
    _pulseRange = widget.pulseRange ?? const RangeValues(40, 160);
    _sortField = widget.sortField;
    _sortOrder = widget.sortOrder;
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging || _tabController.index != _currentTabIndex) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });

      // 當切換到排序面板時，調整面板高度以顯示完整內容
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_currentTabIndex == 1) {
          // 排序面板
          _panelController.animateTo(_sortTabInitialSize, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        } else {
          // 篩選面板
          _panelController.animateTo(_filterTabInitialSize, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 獲取主題顏色
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 獲取螢幕尺寸
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    // 計算合適的面板高度，針對不同標籤頁調整高度
    // 篩選頁面的高度設定
    _filterTabInitialSize = Platform.isAndroid ? 0.6 : 0.65;
    _filterTabMinSize = 0.35;

    // 排序頁面的高度設定 - 排序選項較多，需要更高的初始高度
    _sortTabInitialSize = Platform.isAndroid ? 0.72 : 0.75;
    _sortTabMinSize = 0.45;

    // 根據當前標籤頁選擇合適的初始高度和最小高度
    final initialChildSize = _currentTabIndex == 0 ? _filterTabInitialSize : _sortTabInitialSize;
    final minChildSize = _currentTabIndex == 0 ? _filterTabMinSize : _sortTabMinSize;
    final maxChildSize = 0.95; // 略微增加最大高度以確保在小螢幕上完整顯示所有內容

    // 根據平台和螢幕大小調整底部間距
    final buttonBottomPadding = Platform.isAndroid ? 12.0 : 20.0;

    // 計算面板內部間距
    final double verticalPadding = screenHeight < 700 ? 8.0 : 12.0;

    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      controller: _panelController,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 12, offset: const Offset(0, -2))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖動指示器 - 增加大小使其更易於操作
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDarkMode ? theme.colorScheme.onSurfaceVariant.withAlpha(150) : theme.dividerColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              // 頂部標題和關閉按鈕 - 增加內間距和字體大小
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.tr('篩選與排序'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(180),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // 標籤頁 - 增加高度和字體大小
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.dividerColor))),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: theme.primaryColor,
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withAlpha(153),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  tabs: [
                    Tab(text: context.tr('篩選'), height: 44), // 增加標籤高度
                    Tab(text: context.tr('排序'), height: 44),
                  ],
                ),
              ),
              // 標籤頁內容
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildFilterTab(scrollController, verticalPadding), _buildSortTab(scrollController, verticalPadding)],
                ),
              ),
              // 底部按鈕 - 增加按鈕大小和文字字體
              Container(
                padding: EdgeInsets.fromLTRB(20, 12, 20, buttonBottomPadding),
                decoration: BoxDecoration(color: theme.cardColor, border: Border(top: BorderSide(color: theme.dividerColor))),
                child: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  // 確保按鈕不會被系統導航欄遮擋
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _systolicRange = const RangeValues(70, 200);
                              _diastolicRange = const RangeValues(40, 130);
                              _pulseRange = const RangeValues(40, 160);
                              _sortField = SortField.time;
                              _sortOrder = SortOrder.descending;
                            });
                            widget.onReset();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                            side: BorderSide(color: theme.primaryColor, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(context.tr('重置'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onSystolicRangeChanged(_systolicRange);
                            widget.onDiastolicRangeChanged(_diastolicRange);
                            widget.onPulseRangeChanged(_pulseRange);
                            widget.onSortFieldChanged(_sortField);
                            widget.onSortOrderChanged(_sortOrder);
                            widget.onApply();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: isDarkMode ? Colors.white : theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(context.tr('應用'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterTab(ScrollController scrollController, double verticalPadding) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 收縮壓範圍
          _buildRangeSlider(
            title: '${context.tr('收縮壓')} ${context.tr('範圍')} (mmHg)',
            min: 70,
            max: 200,
            divisions: 130,
            rangeValues: _systolicRange,
            onChanged: (values) {
              setState(() {
                _systolicRange = values;
              });
            },
          ),
          const SizedBox(height: 22),
          // 舒張壓範圍
          _buildRangeSlider(
            title: '${context.tr('舒張壓')} ${context.tr('範圍')} (mmHg)',
            min: 40,
            max: 130,
            divisions: 90,
            rangeValues: _diastolicRange,
            onChanged: (values) {
              setState(() {
                _diastolicRange = values;
              });
            },
          ),
          const SizedBox(height: 22),
          // 心率範圍
          _buildRangeSlider(
            title: '${context.tr('心率')} ${context.tr('範圍')} (bpm)',
            min: 40,
            max: 160,
            divisions: 120,
            rangeValues: _pulseRange,
            onChanged: (values) {
              setState(() {
                _pulseRange = values;
              });
            },
          ),
          // 增加底部間距避免內容被遮擋
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildRangeSlider({
    required String title,
    required double min,
    required double max,
    required int divisions,
    required RangeValues rangeValues,
    required Function(RangeValues) onChanged,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color)),
        const SizedBox(height: 12),
        Row(
          children: [
            // 增加數值文字大小
            Text(
              '${rangeValues.start.round()}',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: theme.primaryColor,
                  inactiveTrackColor: isDarkMode ? theme.primaryColor.withAlpha(51) : theme.dividerColor,
                  thumbColor: isDarkMode ? theme.primaryColor : Colors.white,
                  // 增加滑塊大小
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayColor: theme.primaryColor.withAlpha(32),
                  valueIndicatorColor: isDarkMode ? theme.colorScheme.primary : theme.primaryColor,
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  // 增加滑塊軌道高度
                  trackHeight: 4,
                ),
                child: RangeSlider(
                  values: rangeValues,
                  min: min,
                  max: max,
                  divisions: divisions,
                  labels: RangeLabels('${rangeValues.start.round()}', '${rangeValues.end.round()}'),
                  onChanged: onChanged,
                ),
              ),
            ),
            // 增加數值文字大小
            Text('${rangeValues.end.round()}', style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildSortTab(ScrollController scrollController, double verticalPadding) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 排序欄位
          Text(context.tr('排序欄位'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color)),
          const SizedBox(height: 6),
          // 優化排序選項間距，使其更緊湊以顯示更多內容
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? theme.cardColor.withAlpha(128) : theme.cardColor.withAlpha(204),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(top: 4),
            child: Column(
              children: [
                _buildSortFieldOption(SortField.time, context.tr('時間')),
                _buildSortFieldOption(SortField.systolic, context.tr('收縮壓')),
                _buildSortFieldOption(SortField.diastolic, context.tr('舒張壓')),
                _buildSortFieldOption(SortField.pulse, context.tr('心率')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 排序方式
          Text(context.tr('排序方式'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color)),
          const SizedBox(height: 6),
          // 優化排序方式選項
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? theme.cardColor.withAlpha(128) : theme.cardColor.withAlpha(204),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(top: 4),
            child: Column(
              children: [
                _buildSortOrderOption(SortOrder.ascending, context.tr('升序（小到大）')),
                _buildSortOrderOption(SortOrder.descending, context.tr('降序（大到小）')),
              ],
            ),
          ),
          // 增加底部間距避免內容被遮擋
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSortFieldOption(SortField field, String label) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return RadioListTile<SortField>(
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
      value: field,
      groupValue: _sortField,
      onChanged: (SortField? value) {
        if (value != null) {
          setState(() {
            _sortField = value;
          });
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      activeColor: isDarkMode ? theme.colorScheme.secondary : theme.primaryColor,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1), // 使選項更緊湊
    );
  }

  Widget _buildSortOrderOption(SortOrder order, String label) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return RadioListTile<SortOrder>(
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
      value: order,
      groupValue: _sortOrder,
      onChanged: (SortOrder? value) {
        if (value != null) {
          setState(() {
            _sortOrder = value;
          });
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      activeColor: isDarkMode ? theme.colorScheme.secondary : theme.primaryColor,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1), // 使選項更緊湊
    );
  }
}
