/\*

- @ Author: firstfu
- @ Create Time: 2024-05-15 16:10:23
- @ Description: Firebase 認證系統實作方案
  \*/

# Firebase 認證系統實作方案

## 1. 需求概述

本專案需要透過 Firebase Authentication 實現以下登入方式：

- 電子郵件/密碼登入
- Google 登入
- Apple 登入

這些認證方式需要在 iOS 和 Android 平台上同時支援，提供用戶多種便捷的登入選項。

## 2. 技術選型

### 2.1 依賴庫選擇

需要引入以下主要 Flutter 套件：

| 套件名稱           | 用途                      | 版本    |
| ------------------ | ------------------------- | ------- |
| firebase_core      | Firebase 基礎功能         | ^2.32.0 |
| firebase_auth      | Firebase 認證功能         | ^5.5.1  |
| google_sign_in     | Google 登入               | ^6.3.0  |
| sign_in_with_apple | Apple 登入                | ^6.1.4  |
| crypto             | 處理 Apple 認證中的 nonce | ^3.0.6  |

### 2.2 平台支援情況

| 登入方式      | iOS | Android         | Web |
| ------------- | --- | --------------- | --- |
| 電子郵件/密碼 | ✅  | ✅              | ✅  |
| Google        | ✅  | ✅              | ✅  |
| Apple         | ✅  | ✅ (需額外配置) | ✅  |

**注意**：Apple 登入在 Android 平台上需要額外的後端配置，因為 Android 沒有原生支援 Apple 登入。

## 3. Firebase 專案配置

### 3.1 建立 Firebase 專案

1. 訪問 [Firebase 控制台](https://console.firebase.google.com/)
2. 點擊「新增專案」並填寫專案名稱
3. 依照指引完成專案建立

### 3.2 應用程式註冊

需要在 Firebase 專案中添加以下應用程式：

1. **iOS 應用程式**

   - 需要提供 Bundle ID
   - 下載 GoogleService-Info.plist 並加入專案

2. **Android 應用程式**

   - 需要提供 Package Name
   - 提供 SHA-1 憑證指紋 (用於 Google 登入)
   - 下載 google-services.json 並加入專案

3. **Web 應用程式** (如果需要)
   - 提供應用程式暱稱
   - 記錄 Web API Key 與其他配置資訊

## 4. 認證方式配置詳解

### 4.1 電子郵件/密碼登入

1. 在 Firebase 控制台中開啟「Authentication」→「Sign-in method」
2. 啟用「電子郵件/密碼」提供者
3. 可選：啟用「電子郵件連結」登入方式

配置重點：

- 需要設計表單驗證邏輯
- 實作密碼重設功能
- 考慮郵箱驗證的流程

### 4.2 Google 登入

1. 在 Firebase 控制台中開啟「Authentication」→「Sign-in method」
2. 啟用「Google」提供者
3. 設定支援電子郵件與專案公開名稱

**iOS 平台配置**：

- 在 Info.plist 中配置「URL types」
- 添加 Google 反向用戶端 ID (從 GoogleService-Info.plist 中獲取)
- 確保添加了以下配置：

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
    </array>
  </dict>
</array>
```

**Android 平台配置**：

- 確保已正確配置 SHA-1 與 SHA-256 指紋
- 在 google-services.json 中已包含所需配置
- 在 AndroidManifest.xml 中添加必要的權限：

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 4.3 Apple 登入

1. 加入 Apple 開發者計劃（年費 $99 美元）
2. 在 [Apple Developer Portal](https://developer.apple.com/) 配置「Sign in with Apple」

   - 創建 App ID 並啟用「Sign in with Apple」功能
   - 創建 Service ID
   - 創建並下載私鑰 (.p8 文件)

3. 在 Firebase 控制台配置：
   - 啟用「Apple」提供者
   - 提供 Service ID
   - 在 OAuth 代碼流程配置區域提供 Apple Team ID、私鑰和私鑰 ID

**iOS 平台配置**：

- 在 Xcode 中添加「Sign in with Apple」功能
- 在 Info.plist 中添加以下配置：

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR-REVERSED-CLIENT-ID</string>
    </array>
  </dict>
</array>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR-SERVICE-ID</string>
    </array>
  </dict>
</array>
```

**Android 平台配置**：

- 在 AndroidManifest.xml 中添加回調活動：

```xml
<activity
  android:name="com.aboutyou.dart_packages.sign_in_with_apple.SignInWithAppleCallback"
  android:exported="true">
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="signinwithapple" />
    <data android:path="callback" />
  </intent-filter>
</activity>
```

## 5. 實現架構

### 5.1 服務層設計

建立一個統一的認證服務類來處理所有登入方式：

```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 電子郵件登入
  Future<UserCredential> loginUser(String email, String password);

  // 電子郵件註冊
  Future<UserCredential> registerUser(String email, String password, String name);

  // Google 登入
  Future<UserCredential?> signInWithGoogle();

  // Apple 登入
  Future<UserCredential?> signInWithApple();

  // 登出
  Future<void> signOut();

  // 獲取當前用戶
  User? getCurrentUser();

  // 監聽用戶登入狀態
  Stream<User?> authStateChanges();
}
```

### 5.2 用戶模型設計

創建一個統一的用戶模型類：

```dart
class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String provider; // 'password', 'google', 'apple'
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.provider,
    this.createdAt,
    this.lastLoginAt,
  });

  // 從 Firebase User 轉換
  factory AppUser.fromFirebaseUser(User user, String provider) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      provider: provider,
      createdAt: user.metadata.creationTime,
      lastLoginAt: user.metadata.lastSignInTime,
    );
  }

  // 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'provider': provider,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  // 從 JSON 轉換
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      provider: json['provider'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
    );
  }
}
```

## 6. 實現進度規劃

實作此認證系統的預計進度：

1. **準備階段** (1 天)

   - Firebase 專案創建與配置
   - 開發環境設置與依賴添加

2. **基礎功能實現** (2 天)

   - 實現電子郵件/密碼登入與註冊
   - 設計與實現認證 UI 界面

3. **社交登入整合** (2 天)

   - Google 登入實現與測試
   - Apple 登入實現與測試

4. **優化與測試** (1 天)
   - 錯誤處理與提示優化
   - 跨平台兼容性測試
   - 登入流程用戶體驗優化

## 7. 注意事項與風險

1. **Apple 登入要求**：

   - 用戶必須擁有開啟兩因素認證的 Apple ID
   - 用戶必須登入 iCloud
   - 由於隱私政策，首次登入後可能無法獲取郵箱

2. **安全風險**：

   - 需確保正確處理認證 token
   - 妥善保管私鑰和配置文件
   - 考慮實現帳號關聯邏輯，避免用戶重複註冊

3. **跨平台兼容性**：

   - 確保在不同平台上測試所有登入方式
   - 處理特定平台的限制和差異
   - 考慮使用 Flutter 2.0+ 的空安全功能

4. **版本兼容性問題**：

   - Firebase 套件有較快的更新迭代，需注意版本兼容性
   - 確保 android/build.gradle 中的 compileSdkVersion 和 targetSdkVersion 至少為 33
   - 確保最低 iOS 版本為 12.0 以支援 Sign in with Apple

## 8. 後續擴展計劃

未來可考慮添加的功能：

1. 手機號碼登入/驗證
2. 其他第三方登入方式 (如 Facebook、Twitter)
3. 多重身份驗證
4. 匿名登入
5. 自定義認證伺服器整合
6. 網頁應用程式 (Web) 的認證支援

## 9. Firebase Auth 實作 Code Snippets

### 9.1 初始化 Firebase

```dart
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
```

### 9.2 Email 登入實作

```dart
Future<UserCredential> loginWithEmail(String email, String password) async {
  try {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw '找不到該電子郵件的用戶';
    } else if (e.code == 'wrong-password') {
      throw '密碼不正確';
    } else {
      throw '登入失敗: ${e.message}';
    }
  }
}
```

### 9.3 Google 登入實作

```dart
Future<UserCredential?> signInWithGoogle() async {
  try {
    // 觸發 Google 登入流程
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    // 取得 Google 登入認證
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // 創建 Firebase 認證憑證
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 使用認證憑證登入 Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    throw '使用 Google 登入失敗: $e';
  }
}
```

### 9.4 Apple 登入實作

```dart
Future<UserCredential?> signInWithApple() async {
  try {
    // 準備請求
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // 請求 Apple 認證
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // 創建 Firebase 認證憑證
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // 使用認證憑證登入 Firebase
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  } catch (e) {
    throw '使用 Apple 登入失敗: $e';
  }
}

// 產生隨機 nonce
String generateNonce([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

// 計算字串的 SHA-256 雜湊值
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

## 10. 參考資源

- [Firebase Authentication 文檔](https://firebase.google.com/docs/auth)
- [Google Sign In 文檔](https://pub.dev/packages/google_sign_in)
- [Sign in with Apple 文檔](https://pub.dev/packages/sign_in_with_apple)
- [Apple Developer 文檔](https://developer.apple.com/sign-in-with-apple/get-started/)
- [Firebase Flutter 整合指南](https://firebase.google.com/docs/flutter/setup)
