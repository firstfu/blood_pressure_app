/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-20 14:30:00
 * @ Description: Supabase 配置常量
 */

/// Supabase 配置常量
class SupabaseConstants {
  // Supabase 專案 URL (需要替換成您的專案 URL)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';

  // Supabase 匿名金鑰 (需要替換成您的匿名金鑰)
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // 應用程式 URL Scheme (用於 Deep Link)
  static const String urlScheme = 'io.supabase.bloodpressureapp';

  // 完整重定向 URL
  static const String loginRedirectUrl = '$urlScheme://login-callback/';
  static const String resetPasswordRedirectUrl = '$urlScheme://reset-callback/';
  static const String verifyEmailRedirectUrl = '$urlScheme://verify-callback/';

  // 社交登入提供者 ID
  static const String googleProviderId = 'google';
  static const String appleProviderId = 'apple';
}
