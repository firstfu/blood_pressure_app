/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:30:15
 * @ Description: 登入/註冊彈窗組件
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
  bool _obscurePassword = true; // 控制密碼顯示狀態

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
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
    final dialogHeight = height * 0.7; // 對話框高度佔屏幕高度的70%，增加了一點高度以容納更多內容

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              constraints: BoxConstraints(maxHeight: dialogHeight, minHeight: height * 0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 頂部藍色區域標題
                  _buildHeader(theme),

                  // 表單內容區域
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                        child: Column(
                          children: [
                            // 社交登入選項
                            _buildSocialLoginOptions(theme),

                            // 分隔線
                            _buildDivider(theme),

                            // 表單
                            _buildForm(theme),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 構建社交登入選項
  Widget _buildSocialLoginOptions(ThemeData theme) {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Google 登入按鈕
          _buildSocialLoginButton(
            onPressed: _handleGoogleSignIn,
            icon: 'assets/images/google_logo.png',
            text: '使用 Google 帳號繼續',
            backgroundColor: Colors.white,
            textColor: Colors.black87,
            borderColor: const Color(0xFFDDDDDD),
          ),

          const SizedBox(height: 12),

          // Apple 登入按鈕
          _buildSocialLoginButton(
            onPressed: _handleAppleSignIn,
            icon: 'assets/images/apple_logo.png',
            text: '使用 Apple 帳號繼續',
            backgroundColor: Colors.black,
            textColor: Colors.white,
            borderColor: Colors.black,
          ),
        ],
      ),
    );
  }

  // 構建社交登入按鈕
  Widget _buildSocialLoginButton({
    required VoidCallback onPressed,
    required String icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 使用 Flutter 內建圖標代替圖像資源
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: icon == 'assets/images/google_logo.png' ? const Icon(Icons.g_translate, size: 24) : const Icon(Icons.apple, size: 24),
                  ),
                ),
                Expanded(
                  child: Text(text, style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                ),
                const SizedBox(width: 24), // 保持按鈕文字居中
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 構建分隔線
  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: theme.brightness == Brightness.light ? Colors.grey.withValues(alpha: 0.3 * 255) : Colors.grey.withValues(alpha: 0.5 * 255),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('或', style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(150), fontSize: 14)),
          ),
          Expanded(
            child: Divider(
              color: theme.brightness == Brightness.light ? Colors.grey.withValues(alpha: 0.3 * 255) : Colors.grey.withValues(alpha: 0.5 * 255),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  // 構建頂部藍色標題區域
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor]),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_isLogin ? '歡迎回來' : '加入我們', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(context).pop(false), tooltip: '關閉'),
            ],
          ),
          const SizedBox(height: 8),
          Text(_isLogin ? '請登入您的帳戶以繼續' : '創建一個新帳戶以開始使用', style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  // 構建表單內容
  Widget _buildForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: FadeTransition(
        opacity: _animation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 操作相關說明
            if (widget.message != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light ? const Color(0xFFF5F9FF) : const Color(0xFF1E2A3A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.brightness == Brightness.light ? const Color(0xFFD4E4FF) : const Color(0xFF2A3A4F)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(widget.message!, style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(220), fontSize: 13))),
                  ],
                ),
              ),

            // 錯誤信息
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light ? const Color(0xFFFFF5F5) : const Color(0xFF3A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.brightness == Brightness.light ? const Color(0xFFFFD4D4) : const Color(0xFF4F2A2A)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppTheme.warningColor, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(_errorMessage!, style: TextStyle(color: AppTheme.warningColor, fontSize: 13))),
                  ],
                ),
              ),

            // 顯示名稱字段 (僅註冊時)
            if (!_isLogin)
              _buildInputField(
                controller: _nameController,
                label: '名稱',
                icon: Icons.person_outline,
                hintText: '請輸入您的名稱',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AuthConstants.emptyNameError;
                  }
                  return null;
                },
              ),

            // 電子郵件字段
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
                // 簡單的電子郵件格式驗證
                if (!value.contains('@') || !value.contains('.')) {
                  return AuthConstants.invalidEmailError;
                }
                return null;
              },
            ),

            // 密碼字段
            _buildInputField(
              controller: _passwordController,
              label: '密碼',
              icon: Icons.lock_outline,
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
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // 提交按鈕
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildGradientButton(text: _isLogin ? '登入' : '註冊', onPressed: _submitForm),

            const SizedBox(height: 16),

            // 切換登入/註冊
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_isLogin ? '還沒有帳號？' : '已有帳號？', style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(180), fontSize: 14)),
                TextButton(
                  onPressed: _toggleMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(_isLogin ? '立即註冊' : '立即登入', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
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
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.light ? AppTheme.lightTextPrimaryColor : AppTheme.darkTextPrimaryColor,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? const Color(0xFFE0E0E0) : const Color(0xFF424242)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
          ),
        ],
      ),
    );
  }

  // 構建漸變按鈕
  Widget _buildGradientButton({required String text, required VoidCallback onPressed}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3 * 255), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  void _toggleMode() {
    _animationController.reset();
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
    _animationController.forward();
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
}
