/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:10:23
 * @ Description: 認證相關的常量和操作類型枚舉
 */

/// 定義需要認證的操作類型
enum OperationType {
  addRecord, // 添加血壓記錄
  viewHistory, // 查看歷史記錄
  editProfile, // 編輯個人資料
  setReminder, // 設置提醒
  exportData, // 導出數據
  editRecord, // 編輯記錄
  deleteRecord, // 刪除記錄
}

/// 擴展方法，用於獲取操作的描述文本
extension OperationTypeExtension on OperationType {
  String get description {
    switch (this) {
      case OperationType.addRecord:
        return '添加血壓記錄';
      case OperationType.viewHistory:
        return '查看歷史記錄';
      case OperationType.editProfile:
        return '編輯個人資料';
      case OperationType.setReminder:
        return '設置提醒';
      case OperationType.exportData:
        return '導出數據';
      case OperationType.editRecord:
        return '編輯記錄';
      case OperationType.deleteRecord:
        return '刪除記錄';
    }
  }
}

/// 認證相關的常量
class AuthConstants {
  static const String guestUserPrefix = 'guest_';
  static const String userProfileKey = 'user_profile';
  static const String authTokenKey = 'auth_token';

  // 登入/註冊錯誤信息
  static const String invalidEmailError = '請輸入有效的電子郵件';
  static const String emptyEmailError = '請輸入電子郵件';
  static const String emptyPasswordError = '請輸入密碼';
  static const String shortPasswordError = '密碼至少需要6個字符';
  static const String emptyNameError = '請輸入您的名稱';
  static const String passwordMismatchError = '兩次輸入的密碼不一致';

  // 登入彈窗默認信息
  static const String defaultLoginMessage = '登入後可以使用更多功能';
}
