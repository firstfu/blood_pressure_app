# Supabase 認證常量定義

此文檔定義了應用中使用的 Supabase 認證相關常量，包括錯誤訊息、驗證規則和配置設定。

## 錯誤訊息常量

以下是應用中使用的錯誤訊息常量，用於表單驗證和認證錯誤處理。

```dart
/// 認證相關常量
class AuthConstants {
  // 電子郵件驗證錯誤
  static const String emptyEmailError = '請輸入電子郵件';
  static const String invalidEmailError = '請輸入有效的電子郵件格式';

  // 密碼驗證錯誤
  static const String emptyPasswordError = '請輸入密碼';
  static const String shortPasswordError = '密碼需至少 6 個字符';
  static const String passwordMismatchError = '兩次輸入的密碼不一致';

  // 名稱驗證錯誤
  static const String emptyNameError = '請輸入您的名稱';

  // 登入錯誤
  static const String invalidCredentialsError = '電子郵件或密碼不正確';
  static const String userNotFoundError = '未找到該用戶';
  static const String emailNotVerifiedError = '請先驗證您的電子郵件';

  // 註冊錯誤
  static const String emailAlreadyInUseError = '該電子郵件已被使用';
  static const String weakPasswordError = '密碼強度不足';

  // 社交登入錯誤
  static const String googleSignInCancelledError = 'Google 登入已取消';
  static const String googleSignInFailedError = 'Google 登入失敗';
  static const String appleSignInCancelledError = 'Apple 登入已取消';
  static const String appleSignInFailedError = 'Apple 登入失敗';

  // 其他錯誤
  static const String genericError = '發生錯誤，請稍後再試';
  static const String networkError = '網絡連接錯誤，請檢查您的網絡連接';
  static const String timeoutError = '操作超時，請稍後再試';
}
```

## 認證操作類型

定義不同的認證操作類型，用於確定 UI 行為。

```dart
/// 認證操作類型
enum OperationType {
  signIn,     // 登入
  signUp,     // 註冊
  resetPassword,  // 重設密碼
  verifyEmail     // 驗證電子郵件
}
```

## Supabase 認證配置

Supabase 認證相關配置常量。

```dart
/// Supabase 認證配置
class SupabaseAuthConfig {
  // 應用重定向 URL Scheme
  static const String redirectUrlScheme = 'io.supabase.blood_pressure_app';

  // 完整重定向 URL
  static const String loginRedirectUrl = '$redirectUrlScheme://login-callback/';
  static const String resetPasswordRedirectUrl = '$redirectUrlScheme://reset-callback/';
  static const String verifyEmailRedirectUrl = '$redirectUrlScheme://verify-callback/';

  // Supabase 重定向 URL 配置
  static const List<String> redirectUrls = [
    loginRedirectUrl,
    resetPasswordRedirectUrl,
    verifyEmailRedirectUrl,
  ];

  // 社交登入提供者 ID
  static const String googleProviderId = 'google';
  static const String appleProviderId = 'apple';
}
```

## 社交登入按鈕風格配置

定義社交登入按鈕外觀的常量。

```dart
/// 社交登入按鈕風格配置
class SocialLoginStyles {
  // Google 登入按鈕
  static const Color googleBackgroundColorLight = Colors.white;
  static const Color googleBackgroundColorDark = Color(0xFF2A2A2A);
  static const Color googleTextColorLight = Color(0xFF3C4043);
  static const Color googleTextColorDark = Colors.white;
  static const Color googleBorderColorLight = Color(0xFFDDDDDD);
  static const Color googleBorderColorDark = Color(0xFF5F6368);

  // Apple 登入按鈕
  static const Color appleBackgroundColorLight = Colors.black;
  static const Color appleBackgroundColorDark = Colors.white;
  static const Color appleTextColorLight = Colors.white;
  static const Color appleTextColorDark = Colors.black;
  static const Color appleBorderColorLight = Colors.black;
  static const Color appleBorderColorDark = Colors.white;

  // 通用樣式
  static const double buttonHeight = 52.0;
  static const double buttonBorderRadius = 12.0;
  static const double buttonIconSize = 24.0;
  static const double buttonFontSize = 16.0;
  static const FontWeight buttonFontWeight = FontWeight.w600;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 20.0);
}
```

## 認證狀態常量

認證狀態相關的常量定義。

```dart
/// 認證狀態常量
class AuthStateConstants {
  // 會話持續時間 (秒)
  static const int sessionDuration = 3600 * 24 * 7; // 7 天

  // 記住我選項的持續時間 (秒)
  static const int rememberMeDuration = 3600 * 24 * 30; // 30 天

  // 會話刷新閾值 (秒)
  static const int sessionRefreshThreshold = 3600 * 4; // 4 小時

  // 靜默刷新間隔 (毫秒)
  static const int silentRefreshInterval = 1000 * 60 * 60; // 1 小時
}
```

## 使用說明

在專案中使用這些常量：

1. 創建 `lib/constants/auth_constants.dart` 文件，並添加上述常量定義。
2. 在需要使用的地方導入：

```dart
import 'package:your_app/constants/auth_constants.dart';

// 使用示例
if (email.isEmpty) {
  return AuthConstants.emptyEmailError;
}

// 操作類型示例
final operationType = OperationType.signIn;

// 配置示例
final redirectUrl = SupabaseAuthConfig.loginRedirectUrl;
```

## 注意事項

- 請根據項目需求調整常量值和命名
- 確保 `redirectUrlScheme` 與 Android 和 iOS 配置中的 URL Scheme 一致
- 社交按鈕樣式可根據應用整體風格進行調整
