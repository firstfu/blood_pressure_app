// @ Author: firstfu
// @ Create Time: 2024-05-11 17:42:30
// @ Description: 認證測試頁面

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth/login_status_widget.dart';

/// 認證測試頁面
///
/// 用於測試各種登入方式
class AuthTestPage extends StatefulWidget {
  const AuthTestPage({super.key});

  @override
  State<AuthTestPage> createState() => _AuthTestPageState();
}

class _AuthTestPageState extends State<AuthTestPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _authService = GetIt.instance<AuthService>();
  String _errorMessage = '';
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = '請輸入電子郵件和密碼';
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      await _authService.signInWithEmailAndPassword(_emailController.text.trim(), _passwordController.text);

      if (mounted) {
        setState(() {
          _errorMessage = '';
        });
        _showSuccessMessage('登入成功！');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '登入失敗: ${e.toString()}';
        });
        _showErrorMessage('登入失敗: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      await _authService.signInWithGoogle();

      if (mounted) {
        _showSuccessMessage('Google 登入成功！');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Google 登入失敗: ${e.toString()}';
        });
        _showErrorMessage('Google 登入失敗: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      await _authService.signInWithApple();

      if (mounted) {
        _showSuccessMessage('Apple 登入成功！');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Apple 登入失敗: ${e.toString()}';
        });
        _showErrorMessage('Apple 登入失敗: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // 顯示成功訊息
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  // 顯示錯誤訊息
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    // 獲取 AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('認證測試')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顯示登入狀態
            const LoginStatusWidget(),
            const SizedBox(height: 20),

            // 顯示用戶基本信息
            if (user != null) ...[
              Text('用戶 ID: ${user.id}'),
              Text('電子郵件: ${user.email ?? '無電子郵件'}'),
              Text('電話: ${user.phone ?? '無電話'}'),
              Text('上次登入: ${user.lastSignInAt != null ? user.lastSignInAt.toString() : '未知'}'),
              Text('已確認電子郵件: ${user.emailConfirmedAt != null ? '是' : '否'}'),
            ],

            const Divider(height: 30),

            // 錯誤信息
            if (_errorMessage.isNotEmpty)
              Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Text(_errorMessage, style: const TextStyle(color: Colors.red))),

            // 電子郵件密碼登入表單
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '電子郵件', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              enabled: !_loading,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '密碼', border: OutlineInputBorder()),
              obscureText: true,
              enabled: !_loading,
            ),
            const SizedBox(height: 16),

            // 登入按鈕
            ElevatedButton(
              onPressed: _loading ? null : _signInWithEmailPassword,
              child: _loading ? const CircularProgressIndicator() : const Text('使用電子郵件登入'),
            ),
            const SizedBox(height: 16),

            // 第三方登入按鈕
            ElevatedButton(
              onPressed: _loading ? null : _signInWithGoogle,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/icons/google_logo.png', height: 24), const SizedBox(width: 8), const Text('使用 Google 登入')],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loading ? null : _signInWithApple,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('assets/icons/apple_logo.png', height: 24), const SizedBox(width: 8), const Text('使用 Apple 登入')],
              ),
            ),
            const SizedBox(height: 16),

            // 登出按鈕
            ElevatedButton(
              onPressed:
                  _loading || user == null
                      ? null
                      : () async {
                        setState(() {
                          _loading = true;
                        });
                        try {
                          await _authService.signOut();
                          if (mounted) {
                            setState(() {
                              _loading = false;
                            });
                            _showSuccessMessage('登出成功');
                          }
                        } catch (e) {
                          if (mounted) {
                            setState(() {
                              _loading = false;
                            });
                            _showErrorMessage('登出失敗: $e');
                          }
                        }
                      },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('登出'),
            ),
          ],
        ),
      ),
    );
  }
}
