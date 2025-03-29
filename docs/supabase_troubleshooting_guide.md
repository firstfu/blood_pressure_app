# Supabase 認證故障排除指南

本文檔提供了使用 Supabase 實現認證功能時可能遇到的常見問題和解決方案。

## 常見認證錯誤

### 1. 電子郵件註冊/登入問題

#### 問題: 用戶無法註冊新帳戶

**可能原因:**

- 電子郵件已被使用
- 密碼不符合安全要求
- 網絡連接問題
- Supabase 配置錯誤

**解決方案:**

1. **檢查電子郵件唯一性**:

   ```dart
   try {
     await supabase.auth.signUp(...);
   } catch (error) {
     if (error.toString().contains('User already registered')) {
       // 顯示「電子郵件已被使用」錯誤
     }
   }
   ```

2. **檢查密碼複雜度**:

   - 確保密碼長度至少為 6 個字符
   - 建議使用前端密碼強度驗證

3. **添加錯誤日誌**:
   ```dart
   try {
     await supabase.auth.signUp(...);
   } catch (error) {
     print('註冊錯誤: $error');
     // 根據錯誤類型顯示特定錯誤訊息
   }
   ```

#### 問題: 登入失敗但無錯誤訊息

**可能原因:**

- 用戶輸入錯誤的憑證
- 用戶尚未確認電子郵件
- Supabase 服務暫時不可用

**解決方案:**

1. **檢查憑證**:

   ```dart
   try {
     final response = await supabase.auth.signInWithPassword(...);
     if (response.user == null) {
       // 顯示登入失敗訊息
     }
   } catch (error) {
     print('登入錯誤: $error');
   }
   ```

2. **檢查電子郵件確認**:

   - 如果您設置了需要電子郵件確認，請引導用戶查看郵箱

3. **檢查 Supabase 服務狀態**:
   - 訪問 [Supabase 狀態頁面](https://status.supabase.com)

### 2. 社交登入問題

#### 問題: Google 登入失敗

**可能原因:**

- Google 客戶端 ID 設置錯誤
- OAuth 範圍設置不正確
- Android/iOS 配置問題

**解決方案:**

1. **檢查客戶端 ID**:

   - 確保在 Supabase 控制台中使用的是 Web 客戶端 ID
   - 確保在移動應用中使用的是正確平台的客戶端 ID

2. **檢查 OAuth 範圍**:

   ```dart
   final GoogleSignIn googleSignIn = GoogleSignIn(
     scopes: ['email', 'profile'],
   );
   ```

3. **檢查 Android 配置**:

   - 確保 `android/app/build.gradle` 中的 applicationId 與 Google Cloud 配置一致
   - 檢查 SHA-1 和 SHA-256 憑證是否正確添加到 Google Cloud 專案

4. **檢查 iOS 配置**:

   - 確保 Info.plist 中的 URL Schemes 正確
   - 確保 REVERSED_CLIENT_ID 正確設置

5. **檢查完整的錯誤訊息**:
   ```dart
   try {
     await signInWithGoogle();
   } catch (error) {
     print('Google 登入錯誤詳情: $error');
     // 儲存詳細錯誤日誌
   }
   ```

#### 問題: Apple 登入失敗

**可能原因:**

- Apple Developer 帳戶設置問題
- 缺少必要的配置
- nonce 驗證問題

**解決方案:**

1. **檢查 Apple Developer 設置**:

   - 確保已在 Apple Developer 控制台啟用「Sign in with Apple」
   - 確認 App ID 和 Service ID 設置正確

2. **確保正確處理 nonce**:

   ```dart
   final rawNonce = supabase.auth.generateRawNonce();
   final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

   final credential = await SignInWithApple.getAppleIDCredential(
     scopes: [
       AppleIDAuthorizationScopes.email,
       AppleIDAuthorizationScopes.fullName
     ],
     nonce: hashedNonce,
   );

   final response = await supabase.auth.signInWithIdToken(
     provider: OAuthProvider.apple,
     idToken: credential.identityToken!,
     nonce: rawNonce,
   );
   ```

3. **檢查 iOS 配置**:

   - 確保專案配置了正確的 Entitlements
   - 在 Xcode 中啟用「Sign in with Apple Capability」

4. **處理 `identityToken` 可能為空的情況**:
   ```dart
   if (credential.identityToken == null) {
     throw '無法獲取 Apple Identity Token';
   }
   ```

### 3. 會話管理問題

#### 問題: 自動登出問題

**可能原因:**

- 會話過期
- 會話存儲錯誤
- 多裝置登入衝突

**解決方案:**

1. **實現自動刷新令牌**:

   - 使用 Supabase 的自動會話刷新:

   ```dart
   await Supabase.initialize(
     url: '...',
     anonKey: '...',
     authFlowType: AuthFlowType.pkce,
   );
   ```

2. **處理會話過期**:

   ```dart
   supabase.auth.onAuthStateChange.listen((data) {
     if (data.event == AuthChangeEvent.tokenRefreshFailure) {
       // 令牌刷新失敗，引導用戶重新登入
     }
   });
   ```

3. **添加會話持久化**:
   ```dart
   await Supabase.initialize(
     url: '...',
     anonKey: '...',
     authFlowType: AuthFlowType.pkce,
     storageRetryAttempts: 5,  // 嘗試重新讀取存儲的次數
   );
   ```

#### 問題: 無法獲取當前登入用戶

**可能原因:**

- 會話未正確初始化
- 應用啟動時 Supabase 初始化未完成
- 會話已過期

**解決方案:**

1. **確保在使用前等待初始化完成**:

   ```dart
   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Supabase.initialize(...);
     runApp(MyApp());
   }
   ```

2. **添加會話檢查**:

   ```dart
   Future<User?> getCurrentUser() async {
     // 嘗試獲取當前會話
     final currentUser = supabase.auth.currentUser;

     if (currentUser != null) {
       // 檢查訪問令牌是否有效
       final session = supabase.auth.currentSession;
       if (session != null && !_isTokenExpired(session.expiresAt)) {
         return currentUser;
       }
     }

     return null;
   }

   bool _isTokenExpired(int expiresAt) {
     final expiryDateTime = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
     return DateTime.now().isAfter(expiryDateTime);
   }
   ```

3. **使用 onAuthStateChange 監聽會話變化**:
   ```dart
   supabase.auth.onAuthStateChange.listen((data) {
     setState(() {
       _currentUser = data.session?.user;
     });
   });
   ```

### 4. 密碼重置問題

#### 問題: 密碼重置郵件未收到

**可能原因:**

- 電子郵件服務配置錯誤
- 用戶輸入了錯誤的電子郵件
- 郵件被標記為垃圾郵件

**解決方案:**

1. **確認 Supabase 電子郵件服務工作正常**:

   - 在 Supabase 控制台檢查電子郵件服務狀態
   - 考慮配置自定義 SMTP 服務

2. **添加用戶反饋**:

   ```dart
   try {
     await supabase.auth.resetPasswordForEmail(email);
     // 通知用戶檢查郵箱
     // 建議同時檢查垃圾郵件資料夾
   } catch (error) {
     print('重置密碼錯誤: $error');
   }
   ```

3. **配置自定義電子郵件模板**:
   - 在 Supabase 控制台自定義重置密碼郵件模板，使其更不像垃圾郵件

#### 問題: 密碼重置鏈接不工作

**可能原因:**

- 深度鏈接配置錯誤
- 重定向 URL 未在 Supabase 註冊
- 鏈接已過期

**解決方案:**

1. **確保重定向 URL 已註冊**:

   - 在 Supabase 控制台的 `Authentication > URL Configuration` 中檢查

2. **正確設置深度鏈接**:

   - 在 iOS 和 Android 中設置正確的 URL Scheme

3. **處理重置鏈接回調**:

   ```dart
   // 在適當位置處理回調
   Future<void> _handleDeepLink(Uri uri) async {
     if (uri.toString().contains('reset-callback')) {
       final accessToken = uri.queryParameters['access_token'];
       final tokenType = uri.queryParameters['token_type'];
       final refreshToken = uri.queryParameters['refresh_token'];

       if (accessToken != null && tokenType != null && refreshToken != null) {
         try {
           await _navigateToResetPasswordScreen();
         } catch (error) {
           print('處理密碼重置回調錯誤: $error');
         }
       }
     }
   }
   ```

### 5. 深度鏈接問題

#### 問題: 深度鏈接無法回到應用

**可能原因:**

- URL Scheme 設置錯誤
- Android/iOS 配置問題
- 重定向 URL 格式錯誤

**解決方案:**

1. **檢查 Android 配置**:

   ```xml
   <intent-filter>
     <action android:name="android.intent.action.VIEW" />
     <category android:name="android.intent.category.DEFAULT" />
     <category android:name="android.intent.category.BROWSABLE" />
     <data android:scheme="io.supabase.yourapp" />
   </intent-filter>
   ```

2. **檢查 iOS 配置**:

   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>io.supabase.yourapp</string>
       </array>
     </dict>
   </array>
   ```

3. **檢查重定向 URL 格式**:

   ```dart
   // 正確格式: scheme://path/
   final redirectUrl = 'io.supabase.yourapp://login-callback/';

   await supabase.auth.signInWithOtp(
     email: email,
     emailRedirectTo: redirectUrl,
   );
   ```

4. **使用深度鏈接包處理鏈接**:

   ```dart
   // 安裝 uni_links 套件
   import 'package:uni_links/uni_links.dart';

   // 設置鏈接監聽
   StreamSubscription? _sub;

   Future<void> initUniLinks() async {
     // 處理應用啟動時的深度鏈接
     try {
       final initialLink = await getInitialLink();
       if (initialLink != null) {
         _handleDeepLink(Uri.parse(initialLink));
       }
     } catch (e) {
       print('初始深度鏈接錯誤: $e');
     }

     // 處理應用運行時的深度鏈接
     _sub = linkStream.listen((String? link) {
       if (link != null) {
         _handleDeepLink(Uri.parse(link));
       }
     }, onError: (err) {
       print('深度鏈接流錯誤: $err');
     });
   }
   ```

## 一般故障排除技巧

### 1. 啟用詳細日誌記錄

為了更容易診斷認證問題，啟用 Supabase 的詳細日誌記錄：

```dart
await Supabase.initialize(
  url: '...',
  anonKey: '...',
  debug: true,  // 啟用詳細日誌
);
```

### 2. 檢查 Supabase 專案配置

1. **確認 Supabase 專案服務可用**:

   - 導航至 Supabase 控制台
   - 檢查「Project Status」確保所有服務正常運行

2. **確認認證提供者已啟用**:

   - 導航至「Authentication > Providers」
   - 確保您使用的提供者已啟用

3. **檢查重定向 URL**:
   - 導航至「Authentication > URL Configuration」
   - 確保您的應用 URL Scheme 已添加

### 3. 監控網絡請求

使用網絡監控工具來檢查認證請求和響應：

```dart
import 'package:flutter_supalog/flutter_supalog.dart';

// 設置網絡監控
await SupaLog.init(
  supabaseUrl: '...',
  supabaseAnonKey: '...',
);
```

### 4. 處理常見 Supabase 錯誤碼

實現具體的錯誤處理邏輯來提高用戶體驗：

```dart
String handleSupabaseError(String errorMessage) {
  if (errorMessage.contains('Invalid login credentials')) {
    return '電子郵件或密碼不正確';
  } else if (errorMessage.contains('User already registered')) {
    return '該電子郵件已被使用';
  } else if (errorMessage.contains('Email not confirmed')) {
    return '請先確認您的電子郵件';
  } else if (errorMessage.contains('Password should be at least 6 characters')) {
    return '密碼需至少 6 個字符';
  } else if (errorMessage.contains('network request failed')) {
    return '網絡連接錯誤，請檢查您的網絡連接';
  } else {
    return '發生錯誤，請稍後再試';
  }
}
```

### 5. 實現重試機制

對於不穩定的網絡環境，實現重試機制：

```dart
Future<T> retryOperation<T>(Future<T> Function() operation, {int maxAttempts = 3}) async {
  int attempts = 0;
  while (attempts < maxAttempts) {
    try {
      return await operation();
    } catch (e) {
      attempts++;
      if (attempts >= maxAttempts) {
        rethrow;
      }

      // 增加退避時間
      final waitTime = Duration(milliseconds: 500 * attempts);
      await Future.delayed(waitTime);
    }
  }

  throw Exception('超過最大重試次數');
}

// 使用示例
final user = await retryOperation(() => authService.loginUser(email, password));
```

## 聯繫 Supabase 支援

如果上述步驟無法解決您的問題，請考慮通過以下方式獲取幫助：

1. **Supabase 社區論壇**: https://supabase.com/community
2. **GitHub Issues**: https://github.com/supabase/supabase-flutter/issues
3. **Discord 社區**: https://discord.supabase.com

提交問題時，請提供以下信息：

- Flutter 和 Supabase Flutter SDK 版本
- 詳細的錯誤信息和日誌
- 重現問題的步驟
- 您的代碼示例（移除所有敏感資訊）
