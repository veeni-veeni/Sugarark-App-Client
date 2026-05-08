import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sugarark_app_client/core/auth/auth_service.dart';
import 'package:sugarark_app_client/core/auth/auth_state.dart';
import 'package:sugarark_app_client/core/auth/secure_token_storage.dart';
import 'package:sugarark_app_client/core/auth/user_model.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AuthNotifier', () {
    late MockAuthService service;

    setUp(() {
      service = MockAuthService();
      when(() => service.isLoggedIn()).thenAnswer((_) async => false);
    });

    /// 用 ProviderContainer 隔离测试；override 替换真实 service。
    ProviderContainer makeContainer() {
      return ProviderContainer(
        overrides: <Override>[
          tokenStorageProvider.overrideWithValue(InMemoryTokenStorage()),
          authServiceProvider.overrideWithValue(service),
        ],
      );
    }

    test('bootstrap with no token → AuthUnauthed', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      // 触发首次构建。
      container.read(authStateProvider);
      // 让 _bootstrap 的 microtask 跑完。
      await Future<void>.delayed(Duration.zero);

      expect(container.read(authStateProvider), isA<AuthUnauthed>());
    });

    test('bootstrap with token → AuthAuthed (placeholder user)', () async {
      when(() => service.isLoggedIn()).thenAnswer((_) async => true);

      final container = makeContainer();
      addTearDown(container.dispose);

      container.read(authStateProvider);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(authStateProvider);
      expect(state, isA<AuthAuthed>());
    });

    test('login success transitions Loading → Authed', () async {
      const user = User(
        id: 'usr_1',
        email: 'tom@example.com',
        nickname: 'Tom',
        membership: 'premium',
        memberNo: 'M000123',
        imUserId: 'im_user_tom',
      );
      when(() => service.login(any(), any())).thenAnswer((_) async => user);

      final container = makeContainer();
      addTearDown(container.dispose);

      // 跑过 bootstrap。
      await Future<void>.delayed(Duration.zero);

      await container
          .read(authStateProvider.notifier)
          .login('tom@example.com', 'pw');

      final state = container.read(authStateProvider);
      expect(state, isA<AuthAuthed>());
      expect((state as AuthAuthed).user, user);
    });

    test('login failure transitions Loading → AuthError', () async {
      when(() => service.login(any(), any()))
          .thenThrow(const AuthException('invalid_credentials'));

      final container = makeContainer();
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);

      await container
          .read(authStateProvider.notifier)
          .login('a@b.com', 'wrong');

      final state = container.read(authStateProvider);
      expect(state, isA<AuthError>());
      expect((state as AuthError).code, 'invalid_credentials');
    });

    test('logout clears state to Unauthed', () async {
      when(() => service.logout()).thenAnswer((_) async {});

      final container = makeContainer();
      addTearDown(container.dispose);
      await Future<void>.delayed(Duration.zero);

      await container.read(authStateProvider.notifier).logout();

      expect(container.read(authStateProvider), isA<AuthUnauthed>());
    });
  });
}
