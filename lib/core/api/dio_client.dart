import 'package:dio/dio.dart';

import '../auth/auth_service.dart';

/// Dio 工厂。
///
/// 拦截器职责：
///   1. onRequest: 自动注入 Authorization: Bearer <access_token>。
///      auth/login 与 auth/refresh 端点本身跳过（避免循环）。
///   2. onError 401: 调 AuthService.refresh()，拿到新 token 重放原请求。
///      refresh 也失败 → AuthService.logout() 清本地 token，让上层路由跳登录。
///
/// 注意：AuthService 内部的 dio 实例和这里的 dio 是同一个；
/// refresh 端点不会被加 token（refreshToken 在 body 里），但会经过本拦截器。
/// 由于 401 可能反复触发，用 _refreshing flag 单飞防止并发风暴。
class DioClient {
  DioClient._();

  static Dio create({
    required String baseUrl,
    required AuthService Function() authProvider,
  }) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );

    bool refreshing = false;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          // 登录 / refresh 自身不带旧 access_token。
          final String path = options.path;
          if (path.contains('/auth/login') ||
              path.contains('/auth/refresh')) {
            return handler.next(options);
          }
          final String? token = await authProvider().getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          final int? status = error.response?.statusCode;
          final String path = error.requestOptions.path;

          // 不对 refresh / login / logout 自身做 401-重试，避免死循环。
          final bool isAuthCall = path.contains('/auth/');

          if (status == 401 && !isAuthCall && !refreshing) {
            refreshing = true;
            try {
              await authProvider().refresh();
              final String? newToken = await authProvider().getAccessToken();
              if (newToken != null && newToken.isNotEmpty) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                final Response<dynamic> response =
                    await dio.fetch<dynamic>(error.requestOptions);
                refreshing = false;
                return handler.resolve(response);
              }
            } catch (_) {
              // refresh 也失败 → 强制 logout，由 UI 监听跳登录。
              await authProvider().logout();
            } finally {
              refreshing = false;
            }
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
