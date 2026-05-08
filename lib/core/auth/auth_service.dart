import 'package:dio/dio.dart';

import '../api/api_endpoints.dart';
import 'secure_token_storage.dart';
import 'user_model.dart';

/// auth 异常码（让上层 UI 区分）。
class AuthException implements Exception {
  const AuthException(this.code, [this.message]);

  /// invalid_credentials | network | no_refresh_token | refresh_failed | unknown
  final String code;
  final String? message;

  @override
  String toString() =>
      'AuthException($code${message != null ? ': $message' : ''})';
}

/// AuthService — 直调 sugarark 后端 /api/v1/auth/*。
///
/// 职责：
///   - login / refresh / logout HTTP 调用
///   - JWT token 双值持久化（access + refresh）到 secure storage
///   - getAccessToken/getRefreshToken 同步给 Dio 拦截器消费
///
/// 注意：跟 staff 仓的 AuthService 形状一样，差异只在端点（/auth/login 而非
/// /auth/advisor-login）+ 响应里的 user 而非 advisor。
///
/// 不持有任何 talkcore Internal JWT / app_secret（INVARIANTS 铁律）。
class AuthService {
  AuthService({
    required Dio dio,
    required TokenStorage storage,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final TokenStorage _storage;

  static const String accessTokenKey = 'sugarark_app_access_token';
  static const String refreshTokenKey = 'sugarark_app_refresh_token';

  Future<User> login(String email, String password) async {
    try {
      final Response<dynamic> r = await _dio.post<dynamic>(
        ApiEndpoints.login,
        data: <String, dynamic>{
          'email': email,
          'password': password,
        },
      );
      final Map<String, dynamic> data = _asMap(r.data);
      await _storage.write(accessTokenKey, data['access_token'] as String);
      await _storage.write(refreshTokenKey, data['refresh_token'] as String);
      return User.fromJson(_asMap(data['user']));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw const AuthException('invalid_credentials');
      }
      throw AuthException('network', e.message);
    } catch (e) {
      throw AuthException('unknown', e.toString());
    }
  }

  Future<String?> getAccessToken() => _storage.read(accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(refreshTokenKey);

  /// 用 refresh_token 换新的 access_token。
  /// 失败抛 AuthException，上层（dio interceptor）应触发 logout。
  Future<void> refresh() async {
    final String? refreshToken = await _storage.read(refreshTokenKey);
    if (refreshToken == null) {
      throw const AuthException('no_refresh_token');
    }
    try {
      final Response<dynamic> r = await _dio.post<dynamic>(
        ApiEndpoints.refresh,
        data: <String, dynamic>{'refresh_token': refreshToken},
      );
      final Map<String, dynamic> data = _asMap(r.data);
      await _storage.write(accessTokenKey, data['access_token'] as String);
      await _storage.write(refreshTokenKey, data['refresh_token'] as String);
    } on DioException catch (e) {
      throw AuthException('refresh_failed', e.message);
    }
  }

  /// 清本地 token；先 best-effort 通知后端 revoke。
  Future<void> logout() async {
    final String? refreshToken = await _storage.read(refreshTokenKey);
    if (refreshToken != null) {
      try {
        await _dio.post<dynamic>(
          ApiEndpoints.logout,
          data: <String, dynamic>{'refresh_token': refreshToken},
        );
      } catch (_) {
        // server-side logout best-effort，本地一定要清。
      }
    }
    await _storage.delete(accessTokenKey);
    await _storage.delete(refreshTokenKey);
  }

  /// 是否已登录（有 access_token 即视为已登录；过期由 401 + refresh 兜底）。
  Future<bool> isLoggedIn() async {
    final String? token = await _storage.read(accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw const AuthException('unknown', 'unexpected response shape');
  }
}
