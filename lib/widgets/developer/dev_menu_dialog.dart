// @ Author: firstfu
// @ Create Time: 2024-05-15 15:49:33
// @ Description: 開發者選單彈窗組件

import 'package:flutter/material.dart';
import '../../constants/developer_constants.dart';

/// 開發者選單彈窗
///
/// 顯示可用的開發者測試頁面列表
class DevMenuDialog extends StatelessWidget {
  const DevMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Row(children: [Icon(Icons.code, color: colorScheme.primary), const SizedBox(width: 10), Text('開發者選單', style: textTheme.titleLarge)]),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 說明文字
            Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('開發者選單：用於測試和調試功能，僅在開發環境中顯示。', style: textTheme.bodySmall)),
              ],
            ),
            const Divider(height: 24),

            // 測試頁面列表
            ...DeveloperConstants.devPages.map((pageInfo) => _buildDevPageItem(context, pageInfo)),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('關閉'))],
    );
  }

  /// 構建單個開發者測試頁面項目
  Widget _buildDevPageItem(BuildContext context, DevPageInfo pageInfo) {
    return ListTile(
      leading: Icon(pageInfo.icon),
      title: Text(pageInfo.name),
      subtitle: Text(pageInfo.description, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () {
        // 關閉對話框
        Navigator.of(context).pop();

        // 導航到測試頁面
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => pageInfo.page));
      },
    );
  }
}
