import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sugarark_app_client/core/api/api_endpoints.dart';
import 'package:sugarark_app_client/core/auth/auth_service.dart';
import 'package:sugarark_app_client/core/auth/secure_token_storage.dart';

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  group('AuthService.login', () {
    late MockDio dio;
    late InMemoryTokenStorage storage;
    late AuthService service;

    setUp(() {
      dio = MockDio();
      storage = InMemoryTokenStorage();
      service = AuthService(dio: dio, storage: storage);
    });

    test('success: stores tokens and returns user', () async {
      when(() => dio.post<dynamic>(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<dynamic>(
            requestOptions: RequestOptions(path: ApiEndpoints.login),
            statusCode: 200,
            data: <String, dynamic>{
              'access_token': 'AT_1',
              'refresh_token': 'RT_1',
              'user': <String, dynamic>{
                'id': 'usr_1',
                'email': 'tom@example.com',
                'nickname': 'Tom',
                'membership': 'premium',
                'member_no': 'M000123',
                'im_user_id': 'im_user_tom',
              },
            },
          ));

      final user = await service.login('tom@example.com', 'pw');

      expect(user.id, 'usr_1');
      expect(user.email, 'tom@example.com');
      expect(user.nickname, 'Tom');
      expect(user.membership, 'premium');
      expect(user.memberNo, 'M000123');
      expect(user.imUserId, 'im_user_tom');
      expect(await storage.read(AuthService.accessTokenKey), 'AT_1');
      expect(await storage.read(AuthService.refreshTokenKey), 'RT_1');
    });

    test('success: defaults membership to free when omitted', () async {
      when(() => dio.post<dynamic>(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<dynamic>(
            requestOptions: RequestOptions(path: ApiEndpoints.login),
            statusCode: 200,
            data: <String, dynamic>{
              'access_token': 'AT_1',
              'refresh_token': 'RT_1',
              'user': <String, dynamic>{
                'id': 'usr_2',
                'email': 'new@example.com',
              },
            },
          ));

      final user = await service.login('new@example.com', 'pw');

      expect(user.membership, 'free');
      expect(user.nickname, isNull);
      expect(user.memberNo, isNull);
    });

    test('401 throws invalid_credentials AuthException', () async {
      when(() => dio.post<dynamic>(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.login),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          statusCode: 401,
        ),
      ));

      expect(
        () => service.login('a@b.com', 'wrong'),
        throwsA(isA<AuthException>()
            .having((e) => e.code, 'code', 'invalid_credentials')),
      );
      expect(await storage.read(AuthService.accessTokenKey), isNull);
    });

    test('network error throws AuthException(network)', () async {
      when(() => dio.post<dynamic>(
            ApiEndpoints.login,
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.login),
        type: DioExceptionType.connectionTimeout,
        message: 'timeout',
      ));

      expect(
        () => service.login('a@b.com', 'pw'),
        throwsA(
            isA<AuthException>().having((e) => e.code, 'code', 'network')),
      );
    });
  });

  group('AuthService.refresh', () {
    late MockDio dio;
    late InMemoryTokenStorage storage;
    late AuthService service;

    setUp(() {
      dio = MockDio();
      storage = InMemoryTokenStorage();
      service = AuthService(dio: dio, storage: storage);
    });

    test('no refresh_token throws no_refresh_token', () async {
      expect(
        () => service.refresh(),
        throwsA(isA<AuthException>()
            .having((e) => e.code, 'code', 'no_refresh_token')),
      );
    });

    test('success: rotates both tokens', () async {
      await storage.write(AuthService.refreshTokenKey, 'RT_OLD');

      when(() => dio.post<dynamic>(
            ApiEndpoints.refresh,
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<dynamic>(
            requestOptions: RequestOptions(path: ApiEndpoints.refresh),
            statusCode: 200,
            data: <String, dynamic>{
              'access_token': 'AT_NEW',
              'refresh_token': 'RT_NEW',
            },
          ));

      await service.refresh();

      expect(await storage.read(AuthService.accessTokenKey), 'AT_NEW');
      expect(await storage.read(AuthService.refreshTokenKey), 'RT_NEW');
    });

    test('failure throws refresh_failed', () async {
      await storage.write(AuthService.refreshTokenKey, 'RT_OLD');

      when(() => dio.post<dynamic>(
            ApiEndpoints.refresh,
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.refresh),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: ApiEndpoints.refresh),
          statusCode: 401,
        ),
      ));

      expect(
        () => service.refresh(),
        throwsA(isA<AuthException>()
            .having((e) => e.code, 'code', 'refresh_failed')),
      );
    });
  });

  group('AuthService.logout', () {
    late MockDio dio;
    late InMemoryTokenStorage storage;
    late AuthService service;

    setUp(() {
      dio = MockDio();
      storage = InMemoryTokenStorage();
      service = AuthService(dio: dio, storage: storage);
    });

    test('clears local tokens even if server call fails', () async {
      await storage.write(AuthService.accessTokenKey, 'AT');
      await storage.write(AuthService.refreshTokenKey, 'RT');

      when(() => dio.post<dynamic>(
            ApiEndpoints.logout,
            data: any(named: 'data'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.logout),
        message: 'boom',
      ));

      await service.logout();

      expect(await storage.read(AuthService.accessTokenKey), isNull);
      expect(await storage.read(AuthService.refreshTokenKey), isNull);
    });

    test('no refresh_token: just clears local (no server call)', () async {
      await storage.write(AuthService.accessTokenKey, 'AT');

      await service.logout();

      expect(await storage.read(AuthService.accessTokenKey), isNull);
      verifyNever(() => dio.post<dynamic>(
            ApiEndpoints.logout,
            data: any(named: 'data'),
          ));
    });
  });

  group('AuthService.isLoggedIn', () {
    test('true when access_token present', () async {
      final storage = InMemoryTokenStorage();
      await storage.write(AuthService.accessTokenKey, 'AT');
      final service = AuthService(dio: MockDio(), storage: storage);
      expect(await service.isLoggedIn(), isTrue);
    });

    test('false when storage empty', () async {
      final service =
          AuthService(dio: MockDio(), storage: InMemoryTokenStorage());
      expect(await service.isLoggedIn(), isFalse);
    });
  });
}
