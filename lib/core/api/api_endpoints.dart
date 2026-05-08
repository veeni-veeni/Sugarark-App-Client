/// 后端端点常量。
///
/// 修改 baseUrl 时改这里——dev 用 localhost，生产切到 sugarark 域名。
/// 端点定义对齐主仓 ADR-0014 (app-auth-existing-jwt) + ADR-0017
/// (talkcore-integration-schema-and-apis)。
///
/// 跟姊妹仓 sugarark-staff-client 的差异：
///   - 走 user-side 端点 (/api/v1/auth/login)，**不是** /auth/advisor-login
///   - 多一个 /users/me/push-tokens 推送注册端点
///   - 多一个 webRegisterUrl deep-link (App ADR-0003 V1 注册走 Web)
class ApiEndpoints {
  const ApiEndpoints._();

  /// sugarark 后端基地址。
  ///
  /// 用 --dart-define=API_BASE_URL=… 覆盖；不传时默认 dev 本地端口。
  /// prod 待主仓部署 ADR 定稿后切换默认值。
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );

  // Auth (主仓 ADR-0014, user-side endpoints)
  static const String login = '/api/v1/auth/login';
  static const String refresh = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';

  // Users
  static const String me = '/api/v1/users/me';
  /// 注销账号（Apple App Store 5.1.1 必需）。
  static const String deleteMe = '/api/v1/users/me';
  /// 推送 token 上报。
  static const String pushTokens = '/api/v1/users/me/push-tokens';

  // IM Token (主仓 ADR-0017 §4.2，跟 staff 同端点)
  static const String imToken = '/api/v1/im/token';

  // talkcore WS (Phase 3 接入用，由 imToken 响应里的 gateway_url 覆盖)
  static const String talkcoreWsFallback = 'wss://core.talksoo.com/ws/v1';

  /// V1 注册走 Web (App ADR-0003)。
  /// 登录页"还没账号?"按钮 deep-link 到这里，不在 App 内做注册 UI。
  static const String webRegisterUrl = 'https://sugarark.com/register';
}
