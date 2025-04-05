// @ Author: firstfu
// @ Create Time: 2024-05-13 17:22:35
// @ Description: 認證對話框基礎組件 - 提供共用功能給登入和註冊對話框

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';

/// 認證對話框基礎組件
/// 提供共用的對話框架構、動畫、社交登入和錯誤處理
abstract class AuthDialogBase extends StatefulWidget {
  final String? message;
  final Function(User user)? onSuccess;

  const AuthDialogBase({super.key, this.message, this.onSuccess});
}

abstract class AuthDialogBaseState<T extends AuthDialogBase> extends State<T> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final dialogHeight = height * 0.85;
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0 * _animation.value, sigmaY: 8.0 * _animation.value),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(_animation),
                child: Container(
                  constraints: BoxConstraints(maxWidth: width > 520 ? 520 : width * 0.90, maxHeight: dialogHeight),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? const Color(0xFF2A2A2A) // 暗黑模式下使用較淺的灰色，增加與背景的對比度
                            : theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black.withAlpha(120) : Colors.black.withAlpha(51),
                        blurRadius: isDarkMode ? 40 : 30,
                        spreadRadius: isDarkMode ? 4 : 2,
                      ),
                    ],
                    border: isDarkMode ? Border.all(color: Colors.grey.shade800, width: 1) : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 頭部
                      buildHeader(theme),

                      // 可滾動內容
                      Flexible(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                          child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 16, 24, 24), child: buildContent(theme)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 構建頭部 - 子類必須實現
  Widget buildHeader(ThemeData theme);

  /// 構建內容 - 子類必須實現
  Widget buildContent(ThemeData theme);

  /// 關閉對話框
  Future<void> closeDialog({bool success = false}) async {
    // 執行退出動畫
    await _animationController.reverse();
    // 退出動畫完成後關閉對話框
    if (mounted && context.mounted) {
      Navigator.of(context).pop(success);
    }
  }

  /// 構建提示信息
  Widget buildInfoMessage(String message, ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      // 增加底部間距
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0D2C4D) : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? AppTheme.darkPrimaryColor.withAlpha(128) : AppTheme.primaryLightColor.withAlpha(128), width: 1.0),
        boxShadow: [
          BoxShadow(color: isDarkMode ? Colors.black.withAlpha(26) : Colors.black.withAlpha(13), blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDarkMode ? AppTheme.darkPrimaryLightColor : AppTheme.primaryDarkColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 構建錯誤信息
  Widget buildErrorMessage(String message, ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      // 增加底部間距
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF3E2426) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? AppTheme.warningColor.withAlpha(102) : AppTheme.warningLightColor.withAlpha(128), width: 1.0),
        boxShadow: [
          BoxShadow(color: isDarkMode ? Colors.black.withAlpha(26) : Colors.black.withAlpha(13), blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: isDarkMode ? AppTheme.warningLightColor : AppTheme.warningColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: isDarkMode ? AppTheme.warningLightColor : AppTheme.warningColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// 構建社交登入選項
  Widget buildSocialLoginOptions(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        // Apple 登入按鈕 (只在支持的平台上顯示)
        if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS)
          ElevatedButton.icon(
            onPressed: _isLoading ? null : handleAppleSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.white : Colors.black,
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              elevation: isDarkMode ? 1.5 : 1,
              shadowColor: isDarkMode ? Colors.black.withAlpha(50) : Colors.black.withAlpha(30),
            ),
            icon: const Icon(Icons.apple, size: 24),
            label: Text(
              context.tr('使用 Apple 帳號繼續'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.black : Colors.white),
            ),
          ),
        if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) const SizedBox(height: 12),
        // Google 登入按鈕
        ElevatedButton.icon(
          onPressed: _isLoading ? null : handleGoogleSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            foregroundColor: isDarkMode ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            elevation: isDarkMode ? 1.5 : 1,
            shadowColor: isDarkMode ? Colors.black.withAlpha(50) : Colors.black.withAlpha(30),
          ),
          icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 26),
          label: Text(
            context.tr('使用 Google 帳號繼續'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }

  /// 構建分隔線
  Widget buildDivider(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.tr('或者使用其他方式登入'),
              style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Divider(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }

  /// 處理 Google 登入
  Future<void> handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 獲取授權提供者
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithGoogle();

      // 如果登入成功，通知並關閉對話框
      if (success && authProvider.currentUser != null) {
        widget.onSuccess?.call(authProvider.currentUser!);
        await closeDialog(success: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = getAuthErrorMessage(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 處理 Apple 登入
  Future<void> handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 獲取授權提供者
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithApple();

      // 如果登入成功，通知並關閉對話框
      if (success && authProvider.currentUser != null) {
        widget.onSuccess?.call(authProvider.currentUser!);
        await closeDialog(success: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = getAuthErrorMessage(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 獲取認證錯誤的友好消息
  String getAuthErrorMessage(dynamic error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('user already registered') ||
        errorMessage.contains('email already in use') ||
        errorMessage.contains('email already registered')) {
      return context.tr('此電子郵件已被註冊');
    } else if (errorMessage.contains('invalid login credentials')) {
      return context.tr('帳號密碼不匹配');
    } else if (errorMessage.contains('email not confirmed')) {
      return context.tr('請先驗證您的電子郵件再登入');
    } else if (errorMessage.contains('network')) {
      return context.tr('網絡連接出現問題，請檢查您的網絡連接');
    } else if (errorMessage.contains('too many requests')) {
      return context.tr('嘗試次數過多，請稍後再試');
    } else if (errorMessage.contains('weak password')) {
      return context.tr('密碼太弱，請使用更強的密碼');
    } else if (errorMessage.contains('canceled') || errorMessage.contains('cancelled')) {
      return context.tr('登入已取消');
    } else {
      return context.tr('認證過程中發生錯誤') + ': $errorMessage';
    }
  }

  // 提供狀態訪問給子類
  GlobalKey<FormState> get formKey => _formKey;
  bool get isLoading => _isLoading;
  set isLoading(bool value) => setState(() => _isLoading = value);
  String? get errorMessage => _errorMessage;
  set errorMessage(String? value) => setState(() => _errorMessage = value);
  bool get isPasswordVisible => _isPasswordVisible;
  set isPasswordVisible(bool value) => setState(() => _isPasswordVisible = value);
}
