// 血壓記錄 App 健康建議卡片元件
// 用於顯示健康建議

import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class HealthTipCard extends StatelessWidget {
  final String tip;

  const HealthTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppTheme.primaryLightColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(tip, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
