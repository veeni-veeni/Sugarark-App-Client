import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/api_endpoints.dart';
import '../../core/auth/auth_state.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/error_banner.dart';
import '../../shared/widgets/primary_button.dart';

/// User 登录页。
///
/// UI 风格遵循 ADR-0016 §1：App 端"私享会籍感"——黑底金字 + 大留白 + serif 标题，
/// 比姊妹仓 staff 的工具感更柔。
///
/// 跟 staff 仓登录页的差异：
///   - 副标题改为"会员登录"
///   - 多一个底部"还没账号? 前往网页注册" deep-link 按钮 (App ADR-0003 V1 注册走 Web)
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authStateProvider.notifier)
        .login(_emailCtrl.text.trim(), _passwordCtrl.text);
  }

  Future<void> _openWebRegister() async {
    final Uri uri = Uri.parse(ApiEndpoints.webRegisterUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法打开浏览器，请稍后再试')),
      );
    }
  }

  String? _errorMessage(AuthState state) {
    if (state is! AuthError) return null;
    return switch (state.code) {
      'invalid_credentials' => '邮箱或密码错误',
      'network' => '网络错误，请检查网络后重试',
      'no_refresh_token' => '会话已过期，请重新登录',
      'refresh_failed' => '会话刷新失败，请重新登录',
      _ => state.message ?? '未知错误',
    };
  }

  @override
  Widget build(BuildContext context) {
    final AuthState state = ref.watch(authStateProvider);
    final bool loading = state is AuthLoading;
    final String? error = _errorMessage(state);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'SUGARARK',
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppColors.gold,
                              letterSpacing: 8,
                            ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '会员登录',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: '邮箱',
                      hintText: 'you@example.com',
                    ),
                    validator: (String? v) {
                      if (v == null || v.trim().isEmpty) return '请输入邮箱';
                      if (!v.contains('@')) return '邮箱格式不对';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: '密码',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (String? v) {
                      if (v == null || v.isEmpty) return '请输入密码';
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),
                  if (error != null) ...<Widget>[
                    ErrorBanner(message: error),
                    const SizedBox(height: 16),
                  ],
                  PrimaryButton(
                    label: '登录',
                    onPressed: _submit,
                    loading: loading,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: loading ? null : _openWebRegister,
                    child: const Text('还没账号？前往网页注册'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '仅限 SugarArk 会员使用',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
