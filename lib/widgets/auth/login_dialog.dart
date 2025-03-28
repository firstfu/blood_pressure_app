/*
 * @ Author: firstfu
 * @ Create Time: 2024-03-28 20:30:15
 * @ Description: 登入/註冊彈窗組件
 */

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../services/auth_service.dart';
import '../../constants/auth_constants.dart';

/// 登入/註冊彈窗組件
class LoginDialog extends StatefulWidget {
  final String? message;
  final OperationType operationType;
  final Function? onSuccess;

  const LoginDialog({super.key, this.message, required this.operationType, this.onSuccess});

  @override
  LoginDialogState createState() => LoginDialogState();
}

class LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true; // 切換登入/註冊模式
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(_isLogin ? '登入' : '註冊'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 自定義信息
              if (widget.message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(widget.message!, style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(178))),
                ),

              // 操作信息
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('您需要${_isLogin ? '登入' : '註冊'}才能${widget.operationType.description}', style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              // 錯誤信息
              if (_errorMessage != null)
                Padding(padding: const EdgeInsets.only(bottom: 16), child: Text(_errorMessage!, style: TextStyle(color: theme.colorScheme.error))),

              // 顯示名稱字段 (僅註冊時)
              if (!_isLogin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: '名稱', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AuthConstants.emptyNameError;
                      }
                      return null;
                    },
                  ),
                ),

              // 電子郵件字段
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: '電子郵件', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
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
              ),

              // 密碼字段
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: '密碼', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AuthConstants.emptyPasswordError;
                    }
                    if (value.length < 6) {
                      return AuthConstants.shortPasswordError;
                    }
                    return null;
                  },
                ),
              ),

              // 提交按鈕
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _submitForm,
                    child: Text(_isLogin ? '登入' : '註冊'),
                  ),

              // 切換登入/註冊
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton(onPressed: _toggleMode, child: Text(_isLogin ? '沒有帳號？註冊' : '已有帳號？登入')),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('取消'),
        ),
      ],
    );
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
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
