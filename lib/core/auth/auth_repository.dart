import 'auth_service.dart';
import 'user_model.dart';

/// AuthRepository — 给业务层用的薄壳。
///
/// V1 直接转发 AuthService；V2+ 这层放：
///   - user profile 缓存
///   - 多端登录态合并（用户在 App / Web / TG Mini App 多端独立登录但共享 IM 状态）
///
/// 现在没必要分两层，但保留 file 以匹配 spec 清单 + 防止 UI 直接 import service。
class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Future<User> login(String email, String password) =>
      _service.login(email, password);

  Future<void> logout() => _service.logout();

  Future<bool> isLoggedIn() => _service.isLoggedIn();

  Future<String?> currentAccessToken() => _service.getAccessToken();
}
