// @ Author: firstfu
// @ Create Time: 2024-05-13 17:35:30
// @ Description: 登入彈窗組件 - 整合 Supabase

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import 'auth_dialog_base.dart';
import 'register_dialog.dart';

/// 登入彈窗組件
class LoginDialog extends AuthDialogBase {
  const LoginDialog({super.key, super.message, super.onSuccess});

  @override
  LoginDialogState createState() => LoginDialogState();
}

class LoginDialogState extends AuthDialogBaseState<LoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget buildHeader(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDarkMode
                  ? [const Color(0xFF333333), const Color(0xFF1E1E1E)] // 暗黑模式使用深灰色漸層
                  : [theme.primaryColor, theme.primaryColor], // 明亮模式下使用 primaryColor 的純色
        ),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 標題
                Text(context.tr('歡迎回來'), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                // 副標題
                const SizedBox(height: 4),
                Text(context.tr('登入您的帳號繼續'), style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 14)),
              ],
            ),
          ),
          // 關閉按鈕
          IconButton(
            onPressed: () => closeDialog(),
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(51),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildContent(ThemeData theme) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 操作相關說明
          if (widget.message != null) buildInfoMessage(widget.message!, theme),

          // 錯誤信息
          if (errorMessage != null) buildErrorMessage(errorMessage!, theme),

          // 社交登入按鈕
          buildSocialLoginOptions(theme),

          // 增加分隔線
          buildDivider(theme),

          // 輸入欄位區域
          buildInputFields(theme),

          // 增加提交按鈕前的間距
          const SizedBox(height: 24),

          // 提交按鈕
          isLoading ? const Center(child: CircularProgressIndicator()) : buildSubmitButton(theme),

          // 增加切換到註冊的間距
          const SizedBox(height: 16),

          // 切換到註冊
          buildToggleToRegister(theme),
        ],
      ),
    );
  }

  // 構建輸入欄位
  Widget buildInputFields(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 電子郵件欄位
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: context.tr('電子郵件'),
            hintText: context.tr('請輸入您的電子郵件'),
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.tr('請輸入電子郵件');
            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return context.tr('電子郵件格式不正確');
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // 密碼欄位
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: context.tr('密碼'),
            hintText: context.tr('請輸入您的密碼'),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.tr('密碼不能為空');
            }
            return null;
          },
          obscureText: !isPasswordVisible,
          textInputAction: TextInputAction.done,
          enabled: !isLoading,
        ),

        // 忘記密碼選項
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isLoading ? null : _handleForgotPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              context.tr('忘記密碼？'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.brightness == Brightness.dark ? Colors.lightBlueAccent : AppTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 構建提交按鈕
  Widget buildSubmitButton(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return ElevatedButton(
      onPressed: isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? const Color(0xFF424242) : AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: isDarkMode ? 3 : 2,
        shadowColor: isDarkMode ? Colors.black.withAlpha(50) : Colors.black.withAlpha(13),
      ),
      child: Text(context.tr('登入'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    );
  }

  // 構建切換到註冊的按鈕
  Widget buildToggleToRegister(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return TextButton(
      onPressed:
          isLoading
              ? null
              : () async {
                // 先關閉當前對話框
                await closeDialog();
                if (mounted && context.mounted) {
                  // 打開註冊對話框
                  showDialog(context: context, barrierDismissible: false, builder: (context) => RegisterDialog(onSuccess: widget.onSuccess));
                }
              },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: context.tr('還沒有帳號？'), style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700)),
            TextSpan(
              text: context.tr('立即註冊'),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.lightBlueAccent : AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  /// 處理登入
  Future<void> _handleLogin() async {
    // 隱藏鍵盤
    FocusScope.of(context).unfocus();

    // 驗證表單
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 獲取輸入值
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // 獲取授權提供者
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // 執行登入
      final success = await authProvider.signInWithEmailAndPassword(email, password);

      // 如果登入成功，通知並關閉對話框
      if (success && authProvider.currentUser != null) {
        widget.onSuccess?.call(authProvider.currentUser!);
        await closeDialog(success: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = getAuthErrorMessage(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// 處理忘記密碼
  void _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        errorMessage = context.tr('請先輸入您的電子郵件地址');
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 獲取授權提供者
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.resetPassword(email);

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        if (success && context.mounted) {
          // 顯示成功消息
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.tr('重置密碼的電子郵件已發送，請檢查您的郵箱')), behavior: SnackBarBehavior.floating));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = getAuthErrorMessage(e);
          isLoading = false;
        });
      }
    }
  }
}
