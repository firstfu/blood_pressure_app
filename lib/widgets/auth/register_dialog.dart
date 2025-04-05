// @ Author: firstfu
// @ Create Time: 2024-05-13 17:50:30
// @ Description: 註冊彈窗組件 - 整合 Supabase

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import 'auth_dialog_base.dart';
import 'login_dialog.dart';

/// 註冊彈窗組件
class RegisterDialog extends AuthDialogBase {
  const RegisterDialog({super.key, super.message, super.onSuccess});

  @override
  RegisterDialogState createState() => RegisterDialogState();
}

class RegisterDialogState extends AuthDialogBaseState<RegisterDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                Text(context.tr('創建新帳號'), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                // 副標題
                const SizedBox(height: 4),
                Text(context.tr('註冊'), style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 14)),
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

          // 增加切換到登入的間距
          const SizedBox(height: 16),

          // 切換到登入
          buildToggleToLogin(theme),
        ],
      ),
    );
  }

  // 構建輸入欄位
  Widget buildInputFields(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 名稱欄位
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: context.tr('名字'),
            hintText: context.tr('請輸入您的名字'),
            prefixIcon: const Icon(Icons.person_outline_rounded),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.tr('名字不能為空');
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

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
            } else if (value.length < 6) {
              return context.tr('密碼至少需要6個字符');
            }
            return null;
          },
          obscureText: !isPasswordVisible,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // 確認密碼欄位
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: context.tr('確認密碼'),
            hintText: context.tr('請再次輸入密碼'),
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
              return context.tr('請確認您的密碼');
            } else if (value != _passwordController.text) {
              return context.tr('密碼不匹配');
            }
            return null;
          },
          obscureText: !isPasswordVisible,
          textInputAction: TextInputAction.done,
          enabled: !isLoading,
        ),
      ],
    );
  }

  // 構建提交按鈕
  Widget buildSubmitButton(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return ElevatedButton(
      onPressed: isLoading ? null : _handleRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? const Color(0xFF424242) : AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: isDarkMode ? 3 : 2,
        shadowColor: isDarkMode ? Colors.black.withAlpha(50) : Colors.black.withAlpha(13),
      ),
      child: Text(context.tr('註冊'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    );
  }

  // 構建切換到登入的按鈕
  Widget buildToggleToLogin(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return TextButton(
      onPressed:
          isLoading
              ? null
              : () async {
                // 先關閉當前對話框
                await closeDialog();
                if (mounted && context.mounted) {
                  // 打開登入對話框
                  showDialog(context: context, barrierDismissible: false, builder: (context) => LoginDialog(onSuccess: widget.onSuccess));
                }
              },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: context.tr('已有帳號？'), style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700)),
            TextSpan(
              text: context.tr('立即登入'),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.lightBlueAccent : AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  /// 處理註冊
  Future<void> _handleRegister() async {
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

      // 執行註冊
      final success = await authProvider.signUpWithEmailAndPassword(email, password);

      if (success) {
        if (mounted) {
          setState(() {
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
          });

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('請檢查您的郵箱激活帳號')), behavior: SnackBarBehavior.floating));
          }

          // 註冊成功後自動切換到登入界面
          await closeDialog();
          if (mounted && context.mounted) {
            showDialog(context: context, barrierDismissible: false, builder: (context) => LoginDialog(onSuccess: widget.onSuccess));
          }
        }
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
}
