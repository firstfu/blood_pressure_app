// @ Author: firstfu
// @ Create Time: 2024-05-15 15:52:20
// @ Description: 開發者選單觸發器組件

import 'package:flutter/material.dart';
import '../../constants/developer_constants.dart';
import 'dev_menu_dialog.dart';

/// 開發者選單觸發器
///
/// 將此組件包裝在需要觸發開發者選單的 Widget 外部
/// 當用戶連續點擊五次時，將顯示開發者選單
class DevMenuTrigger extends StatefulWidget {
  /// 子組件
  final Widget child;

  /// 觸發所需的點擊次數
  final int requiredTaps;

  /// 點擊時間重置計時（毫秒）
  final int resetDuration;

  const DevMenuTrigger({super.key, required this.child, this.requiredTaps = 5, this.resetDuration = 3000});

  @override
  State<DevMenuTrigger> createState() => _DevMenuTriggerState();
}

class _DevMenuTriggerState extends State<DevMenuTrigger> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    // 如果開發者選單被禁用，則直接返回子組件
    if (!DeveloperConstants.enableDevMenu) {
      return widget.child;
    }

    return GestureDetector(
      onTap: _handleTap,
      // 確保 GestureDetector 不阻擋子組件的點擊
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }

  /// 處理點擊事件
  void _handleTap() {
    final now = DateTime.now();

    // 檢查是否超過重置時間
    if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds > widget.resetDuration) {
      _tapCount = 0;
    }

    // 更新點擊時間和計數
    _lastTapTime = now;
    _tapCount++;

    // 檢查是否達到所需點擊次數
    if (_tapCount >= widget.requiredTaps) {
      _tapCount = 0;
      _showDevMenu();
    }
  }

  /// 顯示開發者選單
  void _showDevMenu() {
    showDialog(context: context, builder: (context) => const DevMenuDialog());
  }
}
