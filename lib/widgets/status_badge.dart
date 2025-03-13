// 血壓記錄 App 狀態標籤元件
// 用於顯示血壓狀態

import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const StatusBadge({super.key, required this.text, required this.color, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold)),
    );
  }
}
