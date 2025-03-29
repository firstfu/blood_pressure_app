# Supabase 認證實現步驟

本文檔提供了在我們的 Flutter 應用中實現 Supabase 認證所需的詳細步驟。以下是每個登入方式的具體實施流程。

## 第一階段：基礎設置

### 1. 安裝必要套件

```bash
flutter pub add supabase_flutter
flutter pub add google_sign_in
flutter pub add sign_in_with_apple
flutter pub add crypto
```

### 2. 創建環境配置文件

創建 `.env` 文件來存儲 Supabase 及其他敏感配置：

```
SUPABASE_URL=https://your-project-url.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GOOGLE_WEB_CLIENT_ID=your-web-client-id
GOOGLE_IOS_CLIENT_ID=your-ios-client-id
```

### 3. 配置環境變量載入

安裝環境變量套件：

```bash
flutter pub add flutter_dotenv
```

在 `main.dart` 中載入環境變量：

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 載入環境變量
  await dotenv.load(fileName: ".env");

  // 初始化 Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}

// 全局 Supabase 客戶端
final supabase = Supabase.instance.client;
```

### 4. 創建 AuthService 類

創建 `lib/services/auth_service.dart` 文件：

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  // 獲取當前用戶
  User? get currentUser => _supabase.auth.currentUser;

  // 檢查是否已認證
  bool get isAuthenticated => _supabase.auth.currentSession != null;

  // 電子郵件註冊
  Future<AuthResponse> registerUser(String email, String password, String name) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    return response;
  }

  // 電子郵件登入
  Future<AuthResponse> loginUser(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // 魔法鏈接登入
  Future<void> sendMagicLink(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: kIsWeb ? null : 'io.supabase.yourapp://login-callback/',
    );
  }

  // Google 登入 (下一階段實現)
  Future<User?> signInWithGoogle() async {
    // 將在 Google 登入階段實現
    throw UnimplementedError('Google 登入尚未實現');
  }

  // Apple 登入 (下一階段實現)
  Future<User?> signInWithApple() async {
    // 將在 Apple 登入階段實現
    throw UnimplementedError('Apple 登入尚未實現');
  }

  // 登出
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // 監聽認證狀態變化
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;
}
```

### 5. 註冊服務依賴

創建 `lib/services/service_locator.dart` 文件：

```dart
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // 註冊 Supabase 客戶端
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // 註冊認證服務
  getIt.registerSingleton<AuthService>(AuthService(getIt<SupabaseClient>()));
}
```

在 `main.dart` 中設置服務定位器：

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 載入環境變量
  await dotenv.load(fileName: ".env");

  // 初始化 Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 設置服務定位器
  setupServiceLocator();

  runApp(MyApp());
}
```

## 第二階段：電子郵件登入實現

### 1. 設置 Supabase 認證

1. 登入 Supabase 控制台
2. 導航至「Authentication > Providers」
3. 確保「Email」提供者已啟用
4. 設置所需選項（確認郵件、密碼恢復等）

### 2. 創建登入界面

創建 `lib/widgets/auth/login_dialog.dart` 文件：

- 實現電子郵件和密碼表單
- 實現表單驗證
- 連接至 AuthService 進行認證

### 3. 實現「忘記密碼」功能

在 AuthService 中添加密碼重置功能：

```dart
// 添加到 AuthService 類
Future<void> resetPassword(String email) async {
  await _supabase.auth.resetPasswordForEmail(
    email,
    redirectTo: kIsWeb ? null : 'io.supabase.yourapp://reset-callback/',
  );
}
```

## 第三階段：Google 登入實現

### 1. 設置 Google Cloud 專案

1. 訪問 [Google Cloud Console](https://console.cloud.google.com/)
2. 創建新專案或選擇現有專案
3. 啟用「Google Identity API」
4. 創建 OAuth 2.0 客戶端 ID：
   - Web 應用客戶端 ID
   - Android 客戶端 ID
   - iOS 客戶端 ID

### 2. 在 Supabase 中配置 Google 登入

1. 登入 Supabase 控制台
2. 導航至「Authentication > Providers > Google」
3. 開啟 Google 登入
4. 輸入 Web 客戶端 ID
5. 如需在 iOS 上支援 Google 登入，開啟「跳過 nonce 檢查」選項

### 3. Android 平台配置

在 `android/app/build.gradle` 中添加應用簽名配置。

生成 SHA-1 和 SHA-256 證書指紋：

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

在 `android/app/src/main/AndroidManifest.xml` 中添加配置：

```xml
<manifest ...>
  <application ...>
    <activity ...>
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

### 4. iOS 平台配置

在 `ios/Runner/Info.plist` 中添加配置：

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- 從 GoogleService-Info.plist 獲取的 REVERSED_CLIENT_ID -->
      <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
      <!-- Deep Link Scheme -->
      <string>io.supabase.yourapp</string>
    </array>
  </dict>
</array>
```

### 5. 實現 Google 登入功能

在 `AuthService` 中實現 Google 登入方法：

```dart
Future<User?> signInWithGoogle() async {
  try {
    // 定義平台特定客戶端 ID
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    final iosClientId = kIsWeb ? null : dotenv.env['GOOGLE_IOS_CLIENT_ID'];

    // 配置 GoogleSignIn
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? webClientId : iosClientId,
      scopes: ['email', 'profile'],
    );

    // 啟動 Google 登入流程
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // 用戶取消登入
      return null;
    }

    // 獲取認證信息
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // 使用 Google ID 令牌在 Supabase 登入
    final AuthResponse response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
    );

    return response.user;
  } catch (error) {
    rethrow;
  }
}
```

### 6. 在登入界面添加 Google 登入按鈕

更新 `login_dialog.dart` 文件，添加 Google 登入按鈕。

## 第四階段：Apple 登入實現

### 1. 設置 Apple Developer 帳戶

1. 登入 [Apple Developer Console](https://developer.apple.com/account/)
2. 創建「App ID」並啟用「Sign in with Apple」功能
3. 創建「Service ID」並設置重定向 URL（使用您的 Supabase 重定向 URL）
4. 在「Keys」部分創建密鑰並下載 `.p8` 文件

### 2. 在 Supabase 中配置 Apple 登入

1. 登入 Supabase 控制台
2. 導航至「Authentication > Providers > Apple」
3. 開啟 Apple 登入
4. 添加「Service ID」作為客戶端 ID
5. 上傳 `.p8` 私鑰文件（如適用）

### 3. 實現 Apple 登入功能

在 `AuthService` 中實現 Apple 登入方法：

```dart
Future<User?> signInWithApple() async {
  try {
    // 生成隨機 nonce
    final rawNonce = _supabase.auth.generateRawNonce();
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
    final AuthResponse response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    return response.user;
  } catch (error) {
    rethrow;
  }
}
```

### 4. 在登入界面添加 Apple 登入按鈕

更新 `login_dialog.dart` 文件，添加 Apple 登入按鈕。

## 第五階段：用戶會話管理

### 1. 創建認證狀態提供者

創建 `lib/providers/auth_provider.dart` 文件：

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/service_locator.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = getIt<AuthService>();

  AuthNotifier() : super(AuthState.initial()) {
    // 初始化時檢查現有會話
    _checkCurrentSession();

    // 監聽認證狀態變化
    _authService.onAuthStateChange.listen((authState) {
      final user = authState.session?.user;

      if (user != null) {
        state = AuthState(
          isAuthenticated: true,
          isLoading: false,
          user: user,
        );
      } else {
        state = AuthState(
          isAuthenticated: false,
          isLoading: false,
          user: null,
        );
      }
    });
  }

  // 檢查當前會話
  Future<void> _checkCurrentSession() async {
    state = state.copyWith(isLoading: true);

    final user = _authService.currentUser;

    if (user != null) {
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: user,
      );
    } else {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        user: null,
      );
    }
  }

  // 電子郵件註冊
  Future<void> registerWithEmail(String email, String password, String name) async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.registerUser(email, password, name);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // 電子郵件登入
  Future<void> loginWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.loginUser(email, password);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // Google 登入
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // Apple 登入
  Future<void> loginWithApple() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.signInWithApple();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // 登出
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.signOut();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

// 認證狀態
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final User? user;

  AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.user,
  });

  factory AuthState.initial() {
    return AuthState(
      isAuthenticated: false,
      isLoading: true,
      user: null,
    );
  }

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    User? user,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

// Riverpod 提供者
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
```

### 2. 創建認證檢查中間件

創建 `lib/middlewares/auth_middleware.dart` 文件：

```dart
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

class AuthMiddleware extends StatelessWidget {
  final Widget child;
  final AuthState authState;

  const AuthMiddleware({
    Key? key,
    required this.child,
    required this.authState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 載入中顯示載入指示器
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 未認證導向登入頁面
    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }

    // 已認證顯示子元件
    return child;
  }
}
```

### 3. 在應用中設置認證狀態管理

更新 `main.dart` 文件，設置認證狀態管理：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/service_locator.dart';
import 'providers/auth_provider.dart';
import 'middlewares/auth_middleware.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 載入環境變量
  await dotenv.load(fileName: ".env");

  // 初始化 Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // 設置服務定位器
  setupServiceLocator();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: '應用名稱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthMiddleware(
        authState: authState,
        child: const HomeScreen(),
      ),
    );
  }
}
```

## 附錄：常見錯誤排除

### 1. Apple 登入錯誤

- 確保在 Apple Developer Console 中已正確配置「Sign in with Apple」
- 檢查「Service ID」是否已正確添加到 Supabase
- 確保應用已在 Xcode 中啟用「Sign in with Apple Capability」

### 2. Google 登入錯誤

- 確保在 Google Cloud 控制台中已正確配置 OAuth 客戶端 ID
- 確保在 Supabase 控制台中已添加 Web 客戶端 ID
- 檢查 SHA-1 和 SHA-256 證書指紋是否正確

### 3. 登入後用戶信息未更新

- 確保已正確設置認證狀態監聽器
- 檢查是否從緩存中正確獲取當前用戶

### 4. Deep Link 不工作

- 確保已在 Android 和 iOS 配置文件中正確設置 URL 方案
- 檢查重定向 URL 是否已在 Supabase 控制台中添加
- 測試 Deep Link 是否能正確啟動應用
