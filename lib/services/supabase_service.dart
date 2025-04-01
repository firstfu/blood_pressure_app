// /**
//  * @ Author: firstfu
//  * @ Create Time: 2024-04-01 17:45:10
//  * @ Description: Supabase 服務類，用於初始化和管理 Supabase 客戶端
//  */

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

/// Supabase 服務類，負責初始化和提供 Supabase 客戶端實例
class SupabaseService {
  /// 靜態單例實例
  static final SupabaseService _instance = SupabaseService._internal();

  /// 私有構造函數
  SupabaseService._internal();

  /// 工廠構造函數提供單例訪問
  factory SupabaseService() => _instance;

  /// Supabase 客戶端實例
  late final Supabase _supabase;

  /// 獲取 Supabase 客戶端
  SupabaseClient get client => _supabase.client;

  /// 獲取 Supabase 授權實例
  GoTrueClient get auth => client.auth;

  /// 初始化 Supabase
  Future<void> initialize() async {
    try {
      _supabase = await Supabase.initialize(
        url: SupabaseConstants.supabaseUrl,
        anonKey: SupabaseConstants.supabaseAnonKey,
        debug: kDebugMode, // 在開發模式啟用調試
      );
      debugPrint('Supabase 初始化成功');
    } catch (error) {
      debugPrint('Supabase 初始化失敗: $error');
      rethrow;
    }
  }

  /// 獲取當前用戶
  User? get currentUser => auth.currentUser;

  /// 檢查用戶是否已登入
  bool get isAuthenticated => currentUser != null;

  /// 獲取當前會話
  Session? get currentSession => auth.currentSession;

  /// 登出
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// 刷新會話
  Future<void> refreshSession() async {
    if (currentSession != null) {
      await auth.refreshSession();
    }
  }

  /// 監聽授權狀態變化
  Stream<AuthState> get onAuthStateChange => auth.onAuthStateChange;
}
