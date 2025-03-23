/*
 * @ Author: firstfu
 * @ Create Time: 2025-03-16 10:22:30
 * @ Description: 血壓記錄 App 數據表格標籤頁組件 - 顯示血壓記錄的數據表格
 */

import 'package:flutter/material.dart';
import '../../../../models/blood_pressure_record.dart';
import '../../../../themes/app_theme.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../widgets/common/filter_sort_panel.dart';
import '../../../../l10n/app_localizations_extension.dart';

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
  final VoidCallback? onExportData;

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
    this.onExportData,
  });

  @override
  State<StatsDataTableTab> createState() => _StatsDataTableTabState();
}

class _StatsDataTableTabState extends State<StatsDataTableTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.filteredRecords.isEmpty) {
      return Center(
        child: Text(
          context.tr('暫無數據'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
        ),
      );
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
              // 匯出按鈕
              if (widget.onExportData != null)
                OutlinedButton.icon(
                  onPressed: widget.onExportData,
                  icon: const Icon(Icons.file_download, color: Colors.blue),
                  label: Text(context.tr('匯出'), style: const TextStyle(color: Colors.blue)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(100, 36),
                    fixedSize: const Size.fromHeight(36),
                  ),
                ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _showFilterSortPanel,
                icon: Icon(Icons.filter_list, color: widget.isFiltered ? theme.primaryColor : theme.textTheme.bodyMedium?.color),
                label: Text(context.tr('篩選與排序'), style: TextStyle(color: widget.isFiltered ? theme.primaryColor : theme.textTheme.bodyMedium?.color)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: widget.isFiltered ? theme.primaryColor : theme.dividerColor),
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
                  color: theme.textTheme.bodyMedium?.color,
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
                style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 14),
              ),
              if (widget.isFiltered && widget.filteredRecords.length != widget.records.length) ...[
                const SizedBox(width: 4),
                Text(
                  '(${context.tr('已篩選')}，${context.tr('原')} ${widget.records.length} ${context.tr('筆')})',
                  style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
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
              final isDarkMode = theme.brightness == Brightness.dark;

              // 獲取心率狀態顏色
              final pulseColor = _getPulseStatusColor(record.pulse);
              final pulseIcon = _getPulseStatusIcon(record.pulse);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shadowColor: theme.primaryColor.withAlpha(51),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.2) : statusColor.withAlpha(77), width: isDarkMode ? 1.0 : 1.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Row(
                      children: [
                        Text(
                          '${record.systolic}/${record.diastolic}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: theme.textTheme.titleLarge?.color),
                        ),
                        const SizedBox(width: 8),
                        Text('mmHg', style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 14, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDarkMode ? pulseColor.withAlpha(40) : pulseColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDarkMode ? pulseColor.withAlpha(120) : pulseColor.withAlpha(77)),
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
                              Icon(Icons.calendar_today, size: 14, color: theme.textTheme.bodySmall?.color),
                              const SizedBox(width: 4),
                              Text(
                                DateTimeUtils.formatDateMMDD(record.measureTime),
                                style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.access_time, size: 14, color: theme.textTheme.bodySmall?.color),
                              const SizedBox(width: 4),
                              Text(
                                DateTimeUtils.formatTimeHHMM(record.measureTime),
                                style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          if (record.note != null && record.note!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDarkMode ? theme.cardColor.withOpacity(0.3) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.note, size: 14, color: theme.textTheme.bodySmall?.color),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      record.note!,
                                      style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w500),
                                    ),
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
      return Colors.orange; // 心率過高
    } else {
      return Colors.green; // 心率正常
    }
  }

  // 獲取心率狀態圖標
  IconData _getPulseStatusIcon(int pulse) {
    if (pulse < 60) {
      return Icons.arrow_downward; // 心率過低
    } else if (pulse > 100) {
      return Icons.arrow_upward; // 心率過高
    } else {
      return Icons.check_circle; // 心率正常
    }
  }
}
