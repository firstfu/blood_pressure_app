// @ Author: firstfu
// @ Create Time: 2024-05-11 17:45:30
// @ Description: 登入/註冊彈窗組件 - 整合 Supabase

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../themes/app_theme.dart';
import '../../providers/auth_provider.dart';

// 認證操作類型
enum AuthOperation { login, register }

/// 登入/註冊彈窗組件
class LoginDialog extends StatefulWidget {
  final String? message;
  final AuthOperation operationType;
  final Function(User user)? onSuccess;

  const LoginDialog({super.key, this.message, required this.operationType, this.onSuccess});

  @override
  LoginDialogState createState() => LoginDialogState();
}

class LoginDialogState extends State<LoginDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _isPasswordVisible = false;
  late AuthOperation _operationType;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint);
    _animationController.forward();
    _operationType = widget.operationType;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
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

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0 * _animation.value, sigmaY: 8.0 * _animation.value),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(_animation),
                child: Container(
                  constraints: BoxConstraints(maxWidth: width > 400 ? 400 : width * 0.9, maxHeight: dialogHeight),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 30, spreadRadius: 2)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 頭部
                      _buildHeader(theme),

                      // 可滾動內容
                      Flexible(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                          child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 4, 24, 24), child: _buildContent(theme)),
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

  // 構建頭部
  Widget _buildHeader(ThemeData theme) {
    final isLogin = _operationType == AuthOperation.login;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.brightness == Brightness.light ? AppTheme.primaryLightColor : AppTheme.primaryDarkColor, AppTheme.primaryColor],
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
                // 標題動畫
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    isLogin ? '歡迎回來' : '創建帳號',
                    key: ValueKey<bool>(isLogin),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                // 副標題
                const SizedBox(height: 4),
                Text(isLogin ? '登入您的帳號繼續' : '註冊新帳號開始使用', style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 14)),
              ],
            ),
          ),
          // 關閉按鈕
          IconButton(
            onPressed: () async {
              // 執行退出動畫
              await _animationController.reverse();
              // 退出動畫完成後關閉對話框
              if (mounted && context.mounted) {
                Navigator.of(context).pop(false);
              }
            },
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

  // 構建主要內容
  Widget _buildContent(ThemeData theme) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 操作相關說明
                if (widget.message != null) _buildInfoMessage(widget.message!, theme),

                // 錯誤信息
                if (_errorMessage != null) _buildErrorMessage(_errorMessage!, theme),

                // 社交登入按鈕
                _buildSocialLoginOptions(theme),

                // 增加分隔線
                _buildDivider(theme),

                // 輸入欄位區域
                _buildInputFields(theme),

                // 增加提交按鈕前的間距
                const SizedBox(height: 24),

                // 提交按鈕
                _isLoading ? const Center(child: CircularProgressIndicator()) : _buildSubmitButton(theme),

                // 增加切換登入/註冊前的間距
                const SizedBox(height: 16),

                // 切換登入/註冊
                _buildToggleMode(theme),
              ],
            ),
          ),
        );
      },
    );
  }

  // 構建提示信息
  Widget _buildInfoMessage(String message, ThemeData theme) {
    return Container(
      // 增加底部間距
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light ? const Color(0xFFE3F2FD) : const Color(0xFF0D2C4D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.brightness == Brightness.light ? AppTheme.primaryLightColor.withAlpha(128) : AppTheme.primaryDarkColor.withAlpha(128),
          width: 1.0,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 3, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppTheme.primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: theme.brightness == Brightness.light ? AppTheme.primaryDarkColor : AppTheme.primaryLightColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 構建錯誤信息
  Widget _buildErrorMessage(String message, ThemeData theme) {
    return Container(
      // 增加底部間距
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light ? const Color(0xFFFFEBEE) : const Color(0xFF3E2426),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.brightness == Brightness.light ? AppTheme.warningLightColor.withAlpha(128) : AppTheme.warningColor.withAlpha(102),
          width: 1.0,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 3, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppTheme.warningColor, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(color: AppTheme.warningColor, fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  // 構建社交登入選項
  Widget _buildSocialLoginOptions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        // Apple 登入按鈕 (只在支持的平台上顯示)
        if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS)
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _handleAppleSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.brightness == Brightness.light ? Colors.black : Colors.white,
              foregroundColor: theme.brightness == Brightness.light ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              elevation: 1,
            ),
            icon: const Icon(Icons.apple, size: 24),
            label: Text(
              '使用 Apple 帳號繼續',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.brightness == Brightness.light ? Colors.white : Colors.black),
            ),
          ),
        if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) const SizedBox(height: 12),
        // Google 登入按鈕
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _handleGoogleSignIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.brightness == Brightness.light ? Colors.white : const Color(0xFF2A2A2A),
            foregroundColor: theme.brightness == Brightness.light ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade700, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            elevation: 1,
          ),
          icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 26),
          label: Text(
            '使用 Google 帳號繼續',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white),
          ),
        ),
      ],
    );
  }

  // 構建分隔線
  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade700, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '或者',
              style: TextStyle(
                color: theme.brightness == Brightness.light ? Colors.grey.shade600 : Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: theme.brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade700, thickness: 1)),
        ],
      ),
    );
  }

  // 構建輸入欄位
  Widget _buildInputFields(ThemeData theme) {
    final bool isLogin = _operationType == AuthOperation.login;
    final bool isRegister = _operationType == AuthOperation.register;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 註冊時顯示名稱欄位
        if (isRegister) ...[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '您的名字',
              hintText: '請輸入您的名字',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            validator: (value) {
              if (isRegister && (value == null || value.trim().isEmpty)) {
                return '請輸入您的名字';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
        ],

        // 電子郵件欄位
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: '電子郵件',
            hintText: '請輸入您的電子郵件',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '請輸入電子郵件';
            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return '請輸入有效的電子郵件地址';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16),

        // 密碼欄位
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: '密碼',
            hintText: isRegister ? '請設定至少 8 位的密碼' : '請輸入您的密碼',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '請輸入密碼';
            } else if (isRegister && value.length < 8) {
              return '密碼長度至少為 8 位';
            }
            return null;
          },
          obscureText: !_isPasswordVisible,
          textInputAction: isRegister ? TextInputAction.next : TextInputAction.done,
          enabled: !_isLoading,
        ),

        // 如果是登入模式，增加忘記密碼選項
        if (isLogin) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading ? null : _handleForgotPassword,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('忘記密碼？', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.primaryColor)),
            ),
          ),
        ],

        // 如果是註冊模式，增加確認密碼欄位
        if (isRegister) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: '確認密碼',
              hintText: '請再次輸入密碼',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '請確認您的密碼';
              } else if (value != _passwordController.text) {
                return '兩次輸入的密碼不一致';
              }
              return null;
            },
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
          ),
        ],
      ],
    );
  }

  // 構建提交按鈕
  Widget _buildSubmitButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 2,
        shadowColor: Colors.black.withAlpha(13),
      ),
      child: Text(
        _operationType == AuthOperation.login ? '登入' : '註冊',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    );
  }

  // 構建切換登入/註冊模式
  Widget _buildToggleMode(ThemeData theme) {
    final bool isLogin = _operationType == AuthOperation.login;
    return TextButton(
      onPressed:
          _isLoading
              ? null
              : () {
                setState(() {
                  _operationType = isLogin ? AuthOperation.register : AuthOperation.login;
                  _errorMessage = null; // 切換時清除錯誤訊息
                });
              },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: isLogin ? '還沒有帳號？' : '已經有帳號？',
              style: TextStyle(fontSize: 14, color: theme.brightness == Brightness.light ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            TextSpan(text: isLogin ? ' 立即註冊' : ' 立即登入', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
          ],
        ),
      ),
    );
  }

  /// 處理提交按鈕事件
  Future<void> _handleSubmit() async {
    // 隱藏鍵盤
    FocusScope.of(context).unfocus();

    // 驗證表單
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 獲取輸入值
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // 獲取授權提供者
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // 根據操作類型執行登入或註冊
      bool success = false;
      if (_operationType == AuthOperation.login) {
        success = await authProvider.signInWithEmailAndPassword(email, password);
      } else {
        success = await authProvider.signUpWithEmailAndPassword(email, password);
        if (success) {
          // 如果是註冊模式且註冊成功，自動切換到登入模式
          if (mounted) {
            setState(() {
              _operationType = AuthOperation.login;
              _passwordController.clear(); // 清除密碼
              _confirmPasswordController.clear(); // 清除確認密碼
            });
          }

          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('註冊成功！請先驗證您的電子郵件再登入。'), behavior: SnackBarBehavior.floating));
          }
        }
      }

      // 如果登入成功，通知並關閉對話框
      if (success && _operationType == AuthOperation.login && authProvider.currentUser != null) {
        widget.onSuccess?.call(authProvider.currentUser!);

        if (mounted) {
          await _animationController.reverse();
          if (mounted && context.mounted) {
            Navigator.of(context).pop(true);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getAuthErrorMessage(e);
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

  /// 處理 Google 登入
  Future<void> _handleGoogleSignIn() async {
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

        if (mounted) {
          await _animationController.reverse();
          if (mounted && context.mounted) {
            Navigator.of(context).pop(true);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getAuthErrorMessage(e);
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
  Future<void> _handleAppleSignIn() async {
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

        if (mounted) {
          await _animationController.reverse();
          if (mounted && context.mounted) {
            Navigator.of(context).pop(true);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getAuthErrorMessage(e);
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

  // 處理忘記密碼
  void _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = '請先輸入您的電子郵件地址';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 獲取授權提供者
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.resetPassword(email);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success && context.mounted) {
          // 顯示成功消息
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('重置密碼的電子郵件已發送，請檢查您的郵箱'), behavior: SnackBarBehavior.floating));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getAuthErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  // 獲取認證錯誤的友好消息
  String _getAuthErrorMessage(dynamic error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('user already registered') ||
        errorMessage.contains('email already in use') ||
        errorMessage.contains('email already registered')) {
      return '此電子郵件已被註冊';
    } else if (errorMessage.contains('invalid login credentials')) {
      return '電子郵件或密碼不正確';
    } else if (errorMessage.contains('email not confirmed')) {
      return '請先驗證您的電子郵件再登入';
    } else if (errorMessage.contains('network')) {
      return '網絡連接出現問題，請檢查您的網絡連接';
    } else if (errorMessage.contains('too many requests')) {
      return '嘗試次數過多，請稍後再試';
    } else if (errorMessage.contains('weak password')) {
      return '密碼太弱，請使用更強的密碼';
    } else if (errorMessage.contains('canceled') || errorMessage.contains('cancelled')) {
      return '登入已取消';
    } else {
      return '認證過程中發生錯誤: $errorMessage';
    }
  }
}
