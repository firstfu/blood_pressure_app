/*
 * @ Author: firstfu
 * @ Create Time: 2024-07-23 17:15:12
 * @ Description: 血壓記錄 App 服藥效果分析組件 - 顯示服藥前後的血壓變化
 */

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blood_pressure_app/l10n/app_localizations_extension.dart';

class MedicationEffectWidget extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const MedicationEffectWidget({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (!analysis['hasData']) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 48, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
              const SizedBox(height: 16),
              Text(
                analysis['message'] ?? context.tr('沒有足夠的數據進行分析'),
                textAlign: TextAlign.center,
                style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('請確保您有記錄服藥和未服藥時的血壓數據'),
                textAlign: TextAlign.center,
                style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    final medicatedAvg = analysis['medicatedAvg'];
    final nonMedicatedAvg = analysis['nonMedicatedAvg'];
    final difference = analysis['difference'];
    final percentChange = analysis['percentChange'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 服藥效果摘要 - 優化後的設計
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDarkMode
                      ? [theme.colorScheme.primary.withAlpha(60), theme.colorScheme.primary.withAlpha(30)]
                      : [Colors.blue.withAlpha(26), Colors.lightBlue.withAlpha(13)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(isDarkMode ? 20 : 13), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medication_outlined,
                    color: isDarkMode ? theme.colorScheme.primary.withAlpha(230) : Colors.blue.withAlpha(179),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('服藥效果摘要'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDarkMode ? theme.textTheme.titleMedium?.color : null),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 使用垂直佈局而非擁擠的水平佈局
              Column(
                children: [
                  // 收縮壓
                  _buildEffectSummaryCard(
                    context.tr('收縮壓'),
                    '${difference['systolic'].toStringAsFixed(1)} ${context.tr('mmHg')}',
                    percentChange['systolic'].toStringAsFixed(1) + context.tr('%'),
                    difference['systolic'] > 0,
                    isDarkMode,
                    theme,
                  ),
                  const SizedBox(height: 10),

                  // 舒張壓
                  _buildEffectSummaryCard(
                    context.tr('舒張壓'),
                    '${difference['diastolic'].toStringAsFixed(1)} ${context.tr('mmHg')}',
                    percentChange['diastolic'].toStringAsFixed(1) + context.tr('%'),
                    difference['diastolic'] > 0,
                    isDarkMode,
                    theme,
                  ),
                  const SizedBox(height: 10),

                  // 心率
                  _buildEffectSummaryCard(
                    context.tr('心率'),
                    '${difference['pulse'].toStringAsFixed(1)} ${context.tr('bpm')}',
                    percentChange['pulse'].toStringAsFixed(1) + context.tr('%'),
                    difference['pulse'] > 0,
                    isDarkMode,
                    theme,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 服藥效果對比圖
        Row(
          children: [
            Icon(Icons.bar_chart_outlined, color: isDarkMode ? theme.colorScheme.primary.withAlpha(230) : Colors.blue.withAlpha(179), size: 16),
            const SizedBox(width: 6),
            Text(
              context.tr('服藥效果對比'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDarkMode ? theme.textTheme.titleMedium?.color : null),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode ? theme.cardColor : Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(isDarkMode ? 15 : 5), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 200,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: isDarkMode ? theme.colorScheme.surfaceContainerHighest : Colors.blueGrey,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String title;
                          String value;
                          if (groupIndex == 0) {
                            title = context.tr('收縮壓');
                            value = rod.toY.toStringAsFixed(1);
                          } else if (groupIndex == 1) {
                            title = context.tr('舒張壓');
                            value = rod.toY.toStringAsFixed(1);
                          } else {
                            title = context.tr('心率');
                            value = rod.toY.toStringAsFixed(1);
                          }
                          return BarTooltipItem(
                            '$title\n$value',
                            TextStyle(color: isDarkMode ? theme.colorScheme.onSurfaceVariant : Colors.white, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            String text = '';
                            if (value == 0) {
                              text = context.tr('收縮壓');
                            } else if (value == 1) {
                              text = context.tr('舒張壓');
                            } else if (value == 2) {
                              text = context.tr('心率');
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(153) : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value % 50 == 0) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(153) : Colors.grey, fontSize: 10),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(38) : Colors.grey.withAlpha(26),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      // 收縮壓
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: nonMedicatedAvg['systolic'],
                            color: isDarkMode ? Colors.red.withAlpha(230) : Colors.red.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                          BarChartRodData(
                            toY: medicatedAvg['systolic'],
                            color: isDarkMode ? Colors.blue.withAlpha(230) : Colors.blue.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                        ],
                      ),
                      // 舒張壓
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: nonMedicatedAvg['diastolic'],
                            color: isDarkMode ? Colors.red.withAlpha(230) : Colors.red.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                          BarChartRodData(
                            toY: medicatedAvg['diastolic'],
                            color: isDarkMode ? Colors.blue.withAlpha(230) : Colors.blue.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                        ],
                      ),
                      // 心率
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: nonMedicatedAvg['pulse'],
                            color: isDarkMode ? Colors.red.withAlpha(230) : Colors.red.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                          BarChartRodData(
                            toY: medicatedAvg['pulse'],
                            color: isDarkMode ? Colors.blue.withAlpha(230) : Colors.blue.withAlpha(204),
                            width: 18,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(context.tr('未服藥'), Colors.red, isDarkMode),
                  const SizedBox(width: 24),
                  _buildLegendItem(context.tr('服藥後'), Colors.blue, isDarkMode),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 服藥效果詳細數據
        Row(
          children: [
            Icon(Icons.analytics_outlined, color: isDarkMode ? theme.colorScheme.primary.withAlpha(230) : Colors.blue.withAlpha(179), size: 16),
            const SizedBox(width: 6),
            Text(
              context.tr('詳細數據'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDarkMode ? theme.textTheme.titleMedium?.color : null),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(38) : Colors.grey.withAlpha(51)),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(isDarkMode ? 15 : 5), blurRadius: 2, offset: const Offset(0, 1))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(38) : Colors.grey.withAlpha(51)),
                verticalInside: BorderSide(color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(38) : Colors.grey.withAlpha(51)),
              ),
              columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3), 2: FlexColumnWidth(3)},
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isDarkMode
                              ? [theme.colorScheme.primary.withAlpha(100), theme.colorScheme.primary.withAlpha(70)]
                              : [Colors.blue.withAlpha(77), Colors.blue.withAlpha(51)],
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        context.tr('指標'),
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? theme.colorScheme.onSurface : Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        context.tr('未服藥'),
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? theme.colorScheme.onSurface : Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        context.tr('服藥後'),
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? theme.colorScheme.onSurface : Colors.white),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: isDarkMode ? theme.cardColor : Colors.white),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(context.tr('收縮壓'), style: TextStyle(color: isDarkMode ? theme.colorScheme.onSurface : Colors.black87)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${nonMedicatedAvg['systolic'].toStringAsFixed(1)} ${context.tr('mmHg')}',
                        style: TextStyle(color: isDarkMode ? Colors.red.withAlpha(255) : Colors.red.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${medicatedAvg['systolic'].toStringAsFixed(1)} ${context.tr('mmHg')}',
                        style: TextStyle(color: isDarkMode ? Colors.blue.withAlpha(255) : Colors.blue.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(13) : Colors.grey.withAlpha(13)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(context.tr('舒張壓'), style: TextStyle(color: isDarkMode ? theme.colorScheme.onSurface : Colors.black87)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${nonMedicatedAvg['diastolic'].toStringAsFixed(1)} ${context.tr('mmHg')}',
                        style: TextStyle(color: isDarkMode ? Colors.red.withAlpha(255) : Colors.red.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${medicatedAvg['diastolic'].toStringAsFixed(1)} ${context.tr('mmHg')}',
                        style: TextStyle(color: isDarkMode ? Colors.blue.withAlpha(255) : Colors.blue.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(color: isDarkMode ? theme.cardColor : Colors.white),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(context.tr('心率'), style: TextStyle(color: isDarkMode ? theme.colorScheme.onSurface : Colors.black87)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${nonMedicatedAvg['pulse'].toStringAsFixed(1)} ${context.tr('bpm')}',
                        style: TextStyle(color: isDarkMode ? Colors.red.withAlpha(255) : Colors.red.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${medicatedAvg['pulse'].toStringAsFixed(1)} ${context.tr('bpm')}',
                        style: TextStyle(color: isDarkMode ? Colors.blue.withAlpha(255) : Colors.blue.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEffectSummaryCard(String title, String value, String percent, bool isPositive, bool isDarkMode, ThemeData theme) {
    final Color valueColor = isPositive ? (isDarkMode ? Colors.green.shade300 : Colors.green) : (isDarkMode ? Colors.red.shade300 : Colors.red);
    final Color percentColor =
        isPositive
            ? (isDarkMode ? Colors.green.shade300.withAlpha(204) : Colors.green.withAlpha(204))
            : (isDarkMode ? Colors.red.shade300.withAlpha(204) : Colors.red.withAlpha(204));
    final IconData arrowIcon = isPositive ? Icons.arrow_downward : Icons.arrow_upward;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? theme.cardColor.withAlpha(51) : Colors.white.withAlpha(102),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDarkMode ? theme.colorScheme.onSurface.withAlpha(20) : Colors.grey.withAlpha(20), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 標題
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDarkMode ? theme.colorScheme.onSurface : Colors.black87)),

          // 變化值與百分比
          Row(
            children: [
              Icon(arrowIcon, color: valueColor, size: 16),
              const SizedBox(width: 4),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor, fontSize: 15)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: percentColor.withAlpha(isDarkMode ? 40 : 26), borderRadius: BorderRadius.circular(10)),
                child: Text(percent, style: TextStyle(fontSize: 12, color: percentColor, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDarkMode) {
    final effectiveColor = isDarkMode ? color.withAlpha(255) : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: effectiveColor.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: effectiveColor.withAlpha(51), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: effectiveColor, borderRadius: BorderRadius.circular(5))),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? effectiveColor.withAlpha(255) : effectiveColor.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }
}
