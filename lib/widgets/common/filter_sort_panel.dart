/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-15 11:00:30
 * @ Description: 血壓記錄篩選和排序面板元件
 */

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../../themes/app_theme.dart';
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
    // 獲取螢幕尺寸和安全區域
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final viewInsets = mediaQuery.viewInsets.bottom;

    // 計算合適的面板高度
    // 在 Android 上使用較小的比例，避免面板過大
    final heightFactor = Platform.isAndroid ? 0.6 : 0.7;
    final maxPanelHeight = (screenHeight - viewInsets) * heightFactor;

    // 根據平台調整底部間距
    // 在 Android 上添加少量間距，避免按鈕與底部太近
    final buttonBottomPadding = Platform.isAndroid ? 8.0 : 16.0;

    return Container(
      constraints: BoxConstraints(maxHeight: maxPanelHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 ≈ 26
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 頂部標題和關閉按鈕
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.tr('篩選與排序'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.grey[600],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // 標籤頁
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryColor,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              tabs: [Tab(text: context.tr('篩選')), Tab(text: context.tr('排序'))],
            ),
          ),
          // 標籤頁內容
          Expanded(child: TabBarView(controller: _tabController, children: [_buildFilterTab(), _buildSortTab()])),
          // 底部按鈕
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, buttonBottomPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
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
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
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
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
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
  }

  Widget _buildFilterTab() {
    return SingleChildScrollView(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[800])),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(rangeValues.start.round().toString(), style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(rangeValues.end.round().toString(), style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.primaryColor,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayColor: AppTheme.primaryColor.withAlpha(32), // 0.125 * 255 ≈ 32
            valueIndicatorColor: AppTheme.primaryColor,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
            trackHeight: 4,
          ),
          child: RangeSlider(
            values: rangeValues,
            min: min,
            max: max,
            divisions: divisions,
            labels: RangeLabels(rangeValues.start.round().toString(), rangeValues.end.round().toString()),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSortTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr('排序依據'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[800])),
            const SizedBox(height: 4),
            _buildSortFieldRadio(SortField.time, context.tr('測量時間')),
            _buildSortFieldRadio(SortField.systolic, context.tr('收縮壓')),
            _buildSortFieldRadio(SortField.diastolic, context.tr('舒張壓')),
            _buildSortFieldRadio(SortField.pulse, context.tr('心率')),
            const SizedBox(height: 12),
            Text(context.tr('排序方式'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[800])),
            const SizedBox(height: 4),
            _buildSortOrderRadio(SortOrder.descending, context.tr('從高到低')),
            _buildSortOrderRadio(SortOrder.ascending, context.tr('從低到高')),
          ],
        ),
      ),
    );
  }

  Widget _buildSortFieldRadio(SortField value, String title) {
    return RadioListTile<SortField>(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      groupValue: _sortField,
      onChanged: (newValue) {
        setState(() {
          _sortField = newValue!;
        });
      },
      activeColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }

  Widget _buildSortOrderRadio(SortOrder value, String title) {
    return RadioListTile<SortOrder>(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      groupValue: _sortOrder,
      onChanged: (newValue) {
        setState(() {
          _sortOrder = newValue!;
        });
      },
      activeColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}
