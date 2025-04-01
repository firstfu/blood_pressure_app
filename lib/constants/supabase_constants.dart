//   Author: firstfu
//   Create Time: 2024-04-01 17:43:15
//   Description: Supabase 相關常數檔案
//

// Supabase URL 和 Anonymous Key
// 注意：這些值應該存放在環境變數或安全的配置文件中
// 此處僅為示例，實際部署時應該更安全地管理
class SupabaseConstants {
  // Supabase 專案 URL
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';

  // Supabase 匿名金鑰 (不包含敏感權限)
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // 重定向 URL 用於 OAuth 流程
  // 注意：這需要與你在 Supabase Dashboard 設置的 URL 一致
  static const String redirectUrl = 'io.supabase.flutterquickstart://login-callback/';

  // Supabase 會話存儲鍵
  static const String sessionKey = 'supabase_session';

  // 定義 Supabase 資料表名稱
  static const String usersTable = 'users';
  static const String profilesTable = 'profiles';

  // 定義 Supabase 存儲桶名稱
  static const String avatarBucket = 'avatars';
}
