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
      shadowColor: AppTheme.primaryColor.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withAlpha(26), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('健康小貼士', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  const SizedBox(height: 4),
                  Text(tip, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
