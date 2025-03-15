/*
 * @ Author: 1891_0982
 * @ Create Time: 2025-03-16 10:22:30
 * @ Description: 血壓記錄 App 數據表格標籤頁組件 - 顯示血壓記錄的數據表格
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/blood_pressure_record.dart';
import '../../themes/app_theme.dart';
import '../../utils/date_time_utils.dart';
import '../../widgets/common/filter_sort_panel.dart';
import '../../l10n/app_localizations_extension.dart';

class StatsDataTableTab extends StatefulWidget {
  final List<BloodPressureRecord> records;
  final List<BloodPressureRecord> filteredRecords;
  final RangeValues systolicRange;
  final RangeValues diastolicRange;
  final RangeValues pulseRange;
  final SortField sortField;
  final SortOrder sortOrder;
  final bool isFiltered;
  final Function(RangeValues) onSystolicRangeChanged;
  final Function(RangeValues) onDiastolicRangeChanged;
  final Function(RangeValues) onPulseRangeChanged;
  final Function(SortField) onSortFieldChanged;
  final Function(SortOrder) onSortOrderChanged;
  final VoidCallback onResetFiltersAndSort;
  final VoidCallback onApplyFiltersAndSort;

  const StatsDataTableTab({
    super.key,
    required this.records,
    required this.filteredRecords,
    required this.systolicRange,
    required this.diastolicRange,
    required this.pulseRange,
    required this.sortField,
    required this.sortOrder,
    required this.isFiltered,
    required this.onSystolicRangeChanged,
    required this.onDiastolicRangeChanged,
    required this.onPulseRangeChanged,
    required this.onSortFieldChanged,
    required this.onSortOrderChanged,
    required this.onResetFiltersAndSort,
    required this.onApplyFiltersAndSort,
  });

  @override
  State<StatsDataTableTab> createState() => _StatsDataTableTabState();
}

class _StatsDataTableTabState extends State<StatsDataTableTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.filteredRecords.isEmpty) {
      return Center(child: Text(context.tr('暫無數據'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 篩選和排序按鈕
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: _showFilterSortPanel,
                icon: Icon(Icons.filter_list, color: widget.isFiltered ? AppTheme.primaryColor : Colors.grey[600]),
                label: Text(context.tr('篩選與排序'), style: TextStyle(color: widget.isFiltered ? AppTheme.primaryColor : Colors.grey[600])),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: widget.isFiltered ? AppTheme.primaryColor : Colors.grey[400]!),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(120, 36),
                  fixedSize: const Size.fromHeight(36),
                ),
              ),
              if (widget.isFiltered) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: widget.onResetFiltersAndSort,
                  icon: const Icon(Icons.clear),
                  tooltip: context.tr('清除篩選'),
                  color: Colors.grey[600],
                  iconSize: 20,
                ),
              ],
            ],
          ),
        ),
        // 記錄數量顯示
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Text(
                '${context.tr('共')} ${widget.filteredRecords.length} ${context.tr('筆')}${context.tr('記錄')}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              if (widget.isFiltered && widget.filteredRecords.length != widget.records.length) ...[
                const SizedBox(width: 4),
                Text(
                  '(${context.tr('已篩選')}，${context.tr('原')} ${widget.records.length} ${context.tr('筆')})',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        // 歷史記錄
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: widget.filteredRecords.length,
            itemBuilder: (context, index) {
              final record = widget.filteredRecords[index];
              final isBPHigh = record.systolic >= 140 || record.diastolic >= 90;
              final isBPNormal = record.systolic < 120 && record.diastolic < 80;
              final statusColor = isBPHigh ? AppTheme.warningColor : (isBPNormal ? AppTheme.successColor : AppTheme.alertColor);

              // 獲取心率狀態顏色
              final pulseColor = _getPulseStatusColor(record.pulse);
              final pulseIcon = _getPulseStatusIcon(record.pulse);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shadowColor: AppTheme.primaryColor.withAlpha(51),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: statusColor.withAlpha(77), width: 1)),
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
                            color: pulseColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: pulseColor.withAlpha(77)),
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
                                  Flexible(
                                    child: Text(record.note!, style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.w500)),
                                  ),
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
          ),
        ),
      ],
    );
  }

  void _showFilterSortPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FilterSortPanel(
            systolicRange: widget.systolicRange,
            diastolicRange: widget.diastolicRange,
            pulseRange: widget.pulseRange,
            sortField: widget.sortField,
            sortOrder: widget.sortOrder,
            onSystolicRangeChanged: widget.onSystolicRangeChanged,
            onDiastolicRangeChanged: widget.onDiastolicRangeChanged,
            onPulseRangeChanged: widget.onPulseRangeChanged,
            onSortFieldChanged: widget.onSortFieldChanged,
            onSortOrderChanged: widget.onSortOrderChanged,
            onReset: widget.onResetFiltersAndSort,
            onApply: widget.onApplyFiltersAndSort,
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
