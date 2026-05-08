import 'package:dio/dio.dart';

import '../api/api_endpoints.dart';

/// talkcore IM Token 缓存项。
class ImTokenInfo {
  const ImTokenInfo({
    required this.token,
    required this.gatewayUrl,
    required this.imUserId,
    required this.expiresAt,
  });

  final String token;
  final String gatewayUrl;
  final String imUserId;
  final DateTime expiresAt;

  bool get isExpired =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
}

/// talkcore IM Token 服务。
///
/// 主仓 ADR-0017 §4.2：
///   POST /api/v1/im/token  (Bearer user_jwt)
///   → { token, gateway_url, expires_at, im_user_id }
///
/// 跟 staff 仓完全一样（端点 + 缓存策略 + 5 分钟提前刷新）；
/// 唯一差异是鉴权用 user JWT 而不是 advisor JWT，由 Bearer token 自身决定。
///
/// V1 范围：
///   - 拉 token + 内存缓存（不持久化，因为 talkcore Internal JWT 衍生品本就不该落盘）。
///   - 5 分钟提前刷新窗口。
///   - WS 客户端实现是 Phase 3 范围，本类仅供登录后预热使用。
class TalkcoreTokenService {
  TalkcoreTokenService(this._dio);

  final Dio _dio;
  ImTokenInfo? _cached;

  /// 拿 token；命中缓存则直接返回，否则重新请求。
  Future<ImTokenInfo> getToken({bool forceRefresh = false}) async {
    final ImTokenInfo? cached = _cached;
    if (!forceRefresh && cached != null && !cached.isExpired) {
      return cached;
    }
    final Response<dynamic> r = await _dio.post<dynamic>(ApiEndpoints.imToken);
    final Map<String, dynamic> data = _asMap(r.data);
    final ImTokenInfo info = ImTokenInfo(
      token: data['token'] as String,
      gatewayUrl: data['gateway_url'] as String,
      imUserId: data['im_user_id'] as String,
      expiresAt: DateTime.parse(data['expires_at'] as String),
    );
    _cached = info;
    return info;
  }

  /// 登出时手动清理。
  void clear() {
    _cached = null;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw StateError('unexpected /im/token response shape');
  }
}
