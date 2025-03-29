/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-12 17:57:30
 * @ Description: 登入/註冊彈窗組件 - 美化版
 */

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../services/auth_service.dart';
import '../../constants/auth_constants.dart';
import '../../themes/app_theme.dart';

/// 登入/註冊彈窗組件
class LoginDialog extends StatefulWidget {
  final String? message;
  final OperationType operationType;
  final Function? onSuccess;

  const LoginDialog({super.key, this.message, required this.operationType, this.onSuccess});

  @override
  LoginDialogState createState() => LoginDialogState();
}

class LoginDialogState extends State<LoginDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true; // 切換登入/註冊模式
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _slideAnimation;
  bool _obscurePassword = true; // 控制密碼顯示狀態

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint);
    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint));
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: FadeTransition(
            opacity: _animation,
            child: Container(
              constraints: BoxConstraints(maxHeight: dialogHeight, maxWidth: width * 0.9),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 頂部漸變區域標題
                    _buildHeader(theme),

                    // 表單內容區域
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(padding: const EdgeInsets.fromLTRB(24, 16, 24, 24), child: _buildContent(theme)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 構建頂部漸變標題區域
  Widget _buildHeader(ThemeData theme) {
    // 創建符合專案風格的漸變背景
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor],
          stops: const [0.0, 1.0],
        ),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(offset: Offset(0, _slideAnimation.value), child: child);
                },
                child: Text(
                  _isLogin ? '歡迎回來' : '加入我們',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(false),
                  tooltip: '關閉',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(offset: Offset(0, _slideAnimation.value * 0.8), child: child);
            },
            child: Text(
              _isLogin ? '請登入您的帳戶以繼續使用所有功能' : '創建一個新帳戶以開始享受完整體驗',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400, height: 1.3),
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
          color: theme.brightness == Brightness.light ? AppTheme.primaryLightColor.withOpacity(0.5) : AppTheme.primaryDarkColor.withOpacity(0.5),
          width: 1.0,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1))],
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
          color: theme.brightness == Brightness.light ? AppTheme.warningLightColor.withOpacity(0.5) : AppTheme.warningColor.withOpacity(0.4),
          width: 1.0,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1))],
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

  // 構建輸入欄位區域
  Widget _buildInputFields(ThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation), child: child),
        );
      },
      child: Column(
        key: ValueKey<bool>(_isLogin),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 註冊模式顯示名稱欄位
          if (!_isLogin)
            _buildInputField(
              controller: _nameController,
              label: '名稱',
              icon: Icons.person_outline_rounded,
              hintText: '請輸入您的名稱',
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AuthConstants.emptyNameError;
                }
                return null;
              },
              bottomPadding: 20,
            ),

          // 電子郵件欄位
          _buildInputField(
            controller: _emailController,
            label: '電子郵件',
            icon: Icons.email_outlined,
            hintText: 'your@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AuthConstants.emptyEmailError;
              }
              if (!value.contains('@') || !value.contains('.')) {
                return AuthConstants.invalidEmailError;
              }
              return null;
            },
            bottomPadding: 20,
          ),

          // 密碼欄位
          _buildInputField(
            controller: _passwordController,
            label: '密碼',
            icon: Icons.lock_outline_rounded,
            hintText: '請輸入密碼',
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AuthConstants.emptyPasswordError;
              }
              if (value.length < 6) {
                return AuthConstants.shortPasswordError;
              }
              return null;
            },
            bottomPadding: 20,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: theme.brightness == Brightness.light ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              splashRadius: 20,
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // 構建輸入欄位
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscureText = false,
    Widget? suffixIcon,
    double bottomPadding = 24,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      // 可調整輸入欄位間的間距
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            // 調整標籤的間距
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                // 增加標籤字體大小
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.light ? AppTheme.lightTextPrimaryColor : AppTheme.darkTextPrimaryColor,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade500 : Colors.grey.shade600,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                icon,
                color: Theme.of(context).brightness == Brightness.light ? AppTheme.primaryColor : AppTheme.primaryLightColor,
                // 增加圖標大小
                size: 24,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
              ),
              // 增加內部填充空間
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              errorStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            style: TextStyle(
              // 增加輸入文字大小
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.light ? AppTheme.lightTextPrimaryColor : AppTheme.darkTextPrimaryColor,
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            cursorColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  // 構建登入按鈕
  Widget _buildSubmitButton(ThemeData theme) {
    return Container(
      // 調整按鈕高度
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // 調整為與頂部區域一致的漸變方向
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor],
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _submitForm,
          borderRadius: BorderRadius.circular(16),
          highlightColor: Colors.white.withOpacity(0.1),
          splashColor: Colors.white.withOpacity(0.1),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? '登入' : '註冊',
                  // 增加按鈕文字大小
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 構建切換登入/註冊模式
  Widget _buildToggleMode(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? '還沒有帳號？' : '已有帳號？',
          style: TextStyle(
            color: theme.brightness == Brightness.light ? AppTheme.lightTextSecondaryColor : AppTheme.darkTextSecondaryColor,
            // 調整文字大小
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: _toggleMode,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            foregroundColor: AppTheme.primaryColor,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(_isLogin ? '立即註冊' : '立即登入', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ],
    );
  }

  // 切換登入/註冊模式
  void _toggleMode() {
    _animationController.reset();
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
    _animationController.forward();
  }

  // 提交表單
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authService = GetIt.instance<AuthService>();

        if (_isLogin) {
          // 處理登入
          await authService.loginUser(_emailController.text, _passwordController.text);
        } else {
          // 處理註冊
          await authService.registerUser(_emailController.text, _passwordController.text, _nameController.text);
        }

        // 登入/註冊成功
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        // 處理錯誤
        setState(() {
          _errorMessage = '${_isLogin ? '登入' : '註冊'}失敗: ${e.toString()}';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // 構建分隔線
  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: theme.brightness == Brightness.light ? Colors.grey.withOpacity(0.3) : Colors.grey.withOpacity(0.4), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '或使用電子郵件',
              style: TextStyle(
                color: theme.brightness == Brightness.light ? AppTheme.lightTextSecondaryColor : AppTheme.darkTextSecondaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: theme.brightness == Brightness.light ? Colors.grey.withOpacity(0.3) : Colors.grey.withOpacity(0.4), thickness: 1),
          ),
        ],
      ),
    );
  }

  // 構建社交登入選項
  Widget _buildSocialLoginOptions(ThemeData theme) {
    return Column(
      children: [
        // Google 登入按鈕
        _buildSocialLoginButton(
          onPressed: _handleGoogleSignIn,
          icon: Icons.g_translate_rounded, // Google 圖標
          text: '使用 Google 帳號繼續',
          backgroundColor: theme.brightness == Brightness.light ? Colors.white : const Color(0xFF2A2A2A),
          textColor: theme.brightness == Brightness.light ? AppTheme.lightTextPrimaryColor : AppTheme.darkTextPrimaryColor,
          borderColor: theme.brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade800,
          theme: theme,
        ),

        const SizedBox(height: 12),

        // Apple 登入按鈕
        _buildSocialLoginButton(
          onPressed: _handleAppleSignIn,
          icon: Icons.apple, // Apple 圖標
          text: '使用 Apple 帳號繼續',
          backgroundColor: theme.brightness == Brightness.light ? Colors.black : Colors.white,
          textColor: theme.brightness == Brightness.light ? Colors.white : Colors.black,
          borderColor: theme.brightness == Brightness.light ? Colors.black : Colors.white,
          theme: theme,
        ),
      ],
    );
  }

  // 構建社交登入按鈕
  Widget _buildSocialLoginButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    required ThemeData theme,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: textColor, size: 26),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(text, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ),
                SizedBox(width: 26), // 讓文字居中
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 處理 Google 登入
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 獲取 AuthService 實例
      final authService = GetIt.instance<AuthService>();

      // 調用 Google 登入方法
      final user = await authService.signInWithGoogle();

      // 登入成功，執行回調
      if (user != null && widget.onSuccess != null) {
        widget.onSuccess!();
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Google 登入失敗: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 處理 Apple 登入
  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 獲取 AuthService 實例
      final authService = GetIt.instance<AuthService>();

      // 調用 Apple 登入方法
      final user = await authService.signInWithApple();

      // 登入成功，執行回調
      if (user != null && widget.onSuccess != null) {
        widget.onSuccess!();
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Apple 登入失敗: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
