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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _systolicRange = widget.systolicRange ?? const RangeValues(70, 200);
    _diastolicRange = widget.diastolicRange ?? const RangeValues(40, 130);
    _pulseRange = widget.pulseRange ?? const RangeValues(40, 160);
    _sortField = widget.sortField;
    _sortOrder = widget.sortOrder;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 獲取主題顏色
    final theme = Theme.of(context);

    // 獲取螢幕尺寸和安全區域
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final viewInsets = mediaQuery.viewInsets.bottom;

    // 計算合適的面板高度，限制最大高度，以避免溢出
    final initialChildSize = Platform.isAndroid ? 0.5 : 0.6;
    final minChildSize = 0.3;
    final maxChildSize = 0.85;

    // 根據平台調整底部間距
    final buttonBottomPadding = Platform.isAndroid ? 8.0 : 16.0;

    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10, offset: const Offset(0, -2))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖動指示器
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              // 頂部標題和關閉按鈕
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.tr('篩選與排序'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // 標籤頁
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.dividerColor))),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: theme.primaryColor,
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  tabs: [Tab(text: context.tr('篩選')), Tab(text: context.tr('排序'))],
                ),
              ),
              // 標籤頁內容
              Expanded(child: TabBarView(controller: _tabController, children: [_buildFilterTab(scrollController), _buildSortTab(scrollController)])),
              // 底部按鈕
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, buttonBottomPadding),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border(top: BorderSide(color: theme.dividerColor)),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, -1))],
                ),
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
                            side: BorderSide(color: theme.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(context.tr('重置')),
                        ),
                      ),
                      const SizedBox(width: 16),
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
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(context.tr('應用')),
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

  Widget _buildFilterTab(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 20),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color)),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('${rangeValues.start.round()}', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: theme.primaryColor,
                  inactiveTrackColor: theme.dividerColor,
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayColor: theme.primaryColor.withAlpha(32), // 0.125 * 255 ≈ 32
                  valueIndicatorColor: theme.primaryColor,
                  showValueIndicator: ShowValueIndicator.always,
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
            Text('${rangeValues.end.round()}', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
          ],
        ),
      ],
    );
  }

  Widget _buildSortTab(ScrollController scrollController) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 排序欄位
          Text(context.tr('排序欄位'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color)),
          const SizedBox(height: 8),
          _buildSortFieldOption(SortField.time, context.tr('時間')),
          _buildSortFieldOption(SortField.systolic, context.tr('收縮壓')),
          _buildSortFieldOption(SortField.diastolic, context.tr('舒張壓')),
          _buildSortFieldOption(SortField.pulse, context.tr('心率')),
          const SizedBox(height: 16),
          // 排序方式
          Text(context.tr('排序方式'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color)),
          const SizedBox(height: 8),
          _buildSortOrderOption(SortOrder.ascending, context.tr('升序（小到大）')),
          _buildSortOrderOption(SortOrder.descending, context.tr('降序（大到小）')),
          // 增加底部間距避免內容被遮擋
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSortFieldOption(SortField field, String label) {
    final theme = Theme.of(context);

    return RadioListTile<SortField>(
      title: Text(label),
      value: field,
      groupValue: _sortField,
      onChanged: (SortField? value) {
        if (value != null) {
          setState(() {
            _sortField = value;
          });
        }
      },
      contentPadding: EdgeInsets.zero,
      activeColor: theme.primaryColor,
      dense: true,
    );
  }

  Widget _buildSortOrderOption(SortOrder order, String label) {
    final theme = Theme.of(context);

    return RadioListTile<SortOrder>(
      title: Text(label),
      value: order,
      groupValue: _sortOrder,
      onChanged: (SortOrder? value) {
        if (value != null) {
          setState(() {
            _sortOrder = value;
          });
        }
      },
      contentPadding: EdgeInsets.zero,
      activeColor: theme.primaryColor,
      dense: true,
    );
  }
}
