import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_endpoints.dart';
import '../api/dio_client.dart';
import 'auth_service.dart';
import 'secure_token_storage.dart';
import 'user_model.dart';

/// 认证状态机（简化）：
///   loading   启动时检查本地 token
///   unauthed  无 token / 已登出
///   authed    有 token + user 信息已加载
///   error     登录 / refresh 失败
///
/// 选用手写 StateNotifier 而非 riverpod_generator，避免本仓首次启动还没跑过
/// build_runner 时拿不到 .g.dart——交付后 Phase 2.5.2 可以重构成 @riverpod。
sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthed extends AuthState {
  const AuthUnauthed();
}

class AuthAuthed extends AuthState {
  const AuthAuthed(this.user);
  final User user;
}

class AuthError extends AuthState {
  const AuthError(this.code, [this.message]);
  final String code;
  final String? message;
}

// ------- providers -------

final Provider<TokenStorage> tokenStorageProvider = Provider<TokenStorage>(
  (Ref ref) => SecureTokenStorage(),
);

/// AuthService 的 provider。
/// Dio 拦截器需要 AuthService 来拿/刷 token，AuthService 又用 dio 调后端——
/// 用 lazy 闭包 (`() => ref.read(authServiceProvider)`) 打破构造环。
final Provider<AuthService> authServiceProvider = Provider<AuthService>(
  (Ref ref) {
    final TokenStorage storage = ref.watch(tokenStorageProvider);
    final Dio dio = DioClient.create(
      baseUrl: ApiEndpoints.baseUrl,
      authProvider: () => ref.read(authServiceProvider),
    );
    return AuthService(dio: dio, storage: storage);
  },
);

final StateNotifierProvider<AuthNotifier, AuthState> authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>(
  (Ref ref) => AuthNotifier(ref.watch(authServiceProvider)),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._service) : super(const AuthLoading()) {
    _bootstrap();
  }

  final AuthService _service;

  /// 启动时检查本地 token 是否存在；不验证有效性，让首个真实请求触发 401-refresh。
  ///
  /// V1：有 token 即视作已登录，user 字段用占位。
  /// TODO(phase-2.5.2): 后端 /api/v1/users/me 落地后，这里拉一次拿真实 user。
  Future<void> _bootstrap() async {
    final bool logged = await _service.isLoggedIn();
    if (!mounted) return;
    if (logged) {
      state = const AuthAuthed(
        User(
          id: '_bootstrap_',
          email: '',
          membership: 'free',
        ),
      );
    } else {
      state = const AuthUnauthed();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final User user = await _service.login(email, password);
      if (!mounted) return;
      state = AuthAuthed(user);
    } on AuthException catch (e) {
      if (!mounted) return;
      state = AuthError(e.code, e.message);
    } catch (e) {
      if (!mounted) return;
      state = AuthError('unknown', e.toString());
    }
  }

  Future<void> logout() async {
    await _service.logout();
    if (!mounted) return;
    state = const AuthUnauthed();
  }
}
