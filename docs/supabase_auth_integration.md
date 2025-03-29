# Supabase 認證整合指南

## 目錄

1. [介紹](#介紹)
2. [準備工作](#準備工作)
3. [Supabase 設置](#supabase-設置)
4. [套件安裝](#套件安裝)
5. [專案初始化](#專案初始化)
6. [電子郵件登入](#電子郵件登入)
7. [Google 登入](#google-登入)
8. [Apple 登入](#apple-登入)
9. [用戶狀態管理](#用戶狀態管理)
10. [常見問題與解決方案](#常見問題與解決方案)

## 介紹

本文檔提供了在 Flutter 應用中整合 Supabase 認證系統的詳細指南，包括以下三種登入方式：

- 電子郵件登入 (包含密碼登入和魔法鏈接)
- Google 第三方登入
- Apple 第三方登入

Supabase 是一個開源的 Firebase 替代品，提供了豐富的後端服務，包括認證、數據庫、存儲等。

## 準備工作

### 所需工具

- Flutter SDK (最新穩定版)
- Supabase 帳戶 (https://supabase.com/)
- Google Cloud 帳戶 (用於 Google 登入)
- Apple Developer 帳戶 (用於 Apple 登入)
- IDE (如 VS Code、Android Studio 等)

## Supabase 設置

### 建立 Supabase 專案

1. 登入 Supabase 控制台：https://supabase.com/dashboard
2. 點擊「New Project」建立新專案
3. 輸入專案名稱、資料庫密碼及選擇地區
4. 等待專案建立完成（通常需要 1-2 分鐘）

### 獲取專案 API 憑證

1. 在專案控制台中，導航至「Project Settings > API」
2. 記錄以下資訊，後續會使用：
   - `URL`: 您的 Supabase URL
   - `anon key`: 匿名公開金鑰
   - `service_role key`: 服務角色金鑰（保密！）

## 套件安裝

將以下套件添加到您的 Flutter 專案中：

```bash
flutter pub add supabase_flutter
flutter pub add google_sign_in
flutter pub add sign_in_with_apple
flutter pub add crypto
```

## 專案初始化

在 `main.dart` 中初始化 Supabase：

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(MyApp());
}

// 方便後續使用的全局 Supabase 客戶端
final supabase = Supabase.instance.client;
```

## 電子郵件登入

Supabase 支持兩種電子郵件登入方式：

1. 密碼登入
2. 魔法鏈接（無密碼）登入

### 密碼登入

#### 設置 Supabase 控制台

1. 在 Supabase 控制台中導航至「Authentication > Providers」
2. 確保 Email 提供者已啟用
3. 設置所需選項（確認郵件等）

#### 註冊實現

```dart
Future<void> signUpWithEmail(String email, String password) async {
  try {
    final AuthResponse response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    // 處理註冊成功邏輯
    if (response.user != null) {
      // 用戶註冊成功
    } else {
      // 需要確認電子郵件
    }
  } catch (error) {
    // 處理錯誤
    print('註冊錯誤: $error');
  }
}
```

#### 登入實現

```dart
Future<void> signInWithEmail(String email, String password) async {
  try {
    final AuthResponse response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // 處理登入成功
    if (response.user != null) {
      // 用戶登入成功
    }
  } catch (error) {
    // 處理錯誤
    print('登入錯誤: $error');
  }
}
```

### 魔法鏈接登入

#### 設置 Supabase 控制台

1. 在 Supabase 控制台中導航至「Authentication > Providers」
2. 確保 Email 提供者已啟用
3. 在「Email Templates」中自定義魔法鏈接郵件模板

#### 實現

```dart
Future<void> signInWithMagicLink(String email) async {
  try {
    await supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.yourapp://login-callback/',
    );

    // 通知用戶檢查郵件
  } catch (error) {
    // 處理錯誤
    print('魔法鏈接錯誤: $error');
  }
}
```

## Google 登入

### 設置 Google Cloud

1. 創建 Google Cloud 專案：https://console.cloud.google.com/
2. 在 API 和服務中啟用「Google Identity」和「Google+ API」
3. 創建 OAuth 客戶端 ID：
   - Web 應用客戶端 ID
   - Android 客戶端 ID（如需支援）
   - iOS 客戶端 ID（如需支援）

### 設置 Supabase

1. 在 Supabase 控制台中導航至「Authentication > Providers > Google」
2. 開啟 Google 登入
3. 輸入 Web 客戶端 ID
4. 如果需要在 iOS 上支援 Google 登入，開啟「跳過 nonce 檢查」選項

### Android 配置

在 `android/app/src/main/AndroidManifest.xml` 中添加以下配置：

```xml
<manifest ...>
  <application ...>
    <activity ...>
      <!-- ... -->
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
      <!-- 添加 Deep Link -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="io.supabase.yourapp" />
      </intent-filter>
    </activity>
  </application>
</manifest>
```

### iOS 配置

在 `ios/Runner/Info.plist` 中添加以下配置：

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- 來自 GoogleService-Info.plist 的 REVERSED_CLIENT_ID -->
      <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
      <!-- Deep Link Scheme -->
      <string>io.supabase.yourapp</string>
    </array>
  </dict>
</array>
```

### 實現 Google 登入

```dart
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signInWithGoogle() async {
  try {
    // 配置 GoogleSignIn
    final GoogleSignIn googleSignIn = GoogleSignIn(
      // 僅在 Android 或 Web 上使用
      clientId: 'YOUR_WEB_CLIENT_ID',
      scopes: ['email', 'profile'],
    );

    // 啟動 Google 登入流程
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // 用戶取消登入
      return;
    }

    // 獲取認證信息
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // 使用 Google ID 令牌在 Supabase 登入
    final AuthResponse response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
    );

    // 處理登入成功
    if (response.user != null) {
      // 用戶登入成功
    }
  } catch (error) {
    // 處理錯誤
    print('Google 登入錯誤: $error');
  }
}
```

## Apple 登入

### 設置 Apple Developer

1. 在 Apple Developer 控制台登入：https://developer.apple.com/account/
2. 創建「App ID」並啟用「Sign in with Apple」功能
3. 創建「Service ID」並設置重定向 URL
4. 在「Keys」部分創建密鑰並下載 `.p8` 文件

### 設置 Supabase

1. 在 Supabase 控制台中導航至「Authentication > Providers > Apple」
2. 開啟 Apple 登入
3. 添加「Service ID」作為客戶端 ID

### iOS 配置

確保在 `ios/Runner/Info.plist` 中添加以下配置：

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

### 實現 Apple 登入

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<void> signInWithApple() async {
  try {
    // 生成隨機 nonce
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    // 啟動 Apple 登入流程
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    // 獲取 ID 令牌
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('無法從生成的憑證中找到 ID 令牌');
    }

    // 使用 Apple ID 令牌在 Supabase 登入
    final AuthResponse response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    // 處理登入成功
    if (response.user != null) {
      // 用戶登入成功
    }
  } catch (error) {
    // 處理錯誤
    print('Apple 登入錯誤: $error');
  }
}
```

## 用戶狀態管理

### 監聽認證狀態變化

```dart
void setupAuthListener() {
  supabase.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;

    switch (event) {
      case AuthChangeEvent.signedIn:
        // 處理用戶登入
        break;
      case AuthChangeEvent.signedOut:
        // 處理用戶登出
        break;
      case AuthChangeEvent.userUpdated:
        // 處理用戶信息更新
        break;
      case AuthChangeEvent.passwordRecovery:
        // 處理密碼恢復
        break;
      default:
        break;
    }
  });
}
```

### 登出實現

```dart
Future<void> signOut() async {
  try {
    await supabase.auth.signOut();
    // 處理登出成功
  } catch (error) {
    // 處理錯誤
    print('登出錯誤: $error');
  }
}
```

### 獲取當前用戶

```dart
User? getCurrentUser() {
  return supabase.auth.currentUser;
}

bool isAuthenticated() {
  return supabase.auth.currentSession != null;
}
```

## 常見問題與解決方案

### 認證流程失敗

- 確保所有客戶端 ID 和重定向 URL 配置正確
- 檢查網絡連接
- 查看 Supabase 控制台中的日誌

### 第三方登入按鈕沒反應

- 確保第三方登入已在 Supabase 控制台中啟用
- 檢查 Android/iOS 配置是否正確

### 魔法鏈接不工作

- 確保重定向 URL 已在 Supabase 控制台中添加
- 檢查 Deep Link 配置
- 確保應用已設置正確的 URL 方案

### 登入後無法獲取用戶信息

- 確保監聽 `onAuthStateChange` 事件
- 檢查會話是否有效
- 刷新令牌可能已過期，嘗試重新登入

---

本文檔將根據 Supabase 的更新和團隊反饋持續更新。最後更新：2024-05-12
