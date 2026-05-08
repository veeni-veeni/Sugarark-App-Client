import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_page.dart';
import '../../features/chat/chat_tab.dart';
import '../../features/home/main_tab_shell.dart';
import '../../features/notifications/notifications_tab.dart';
import '../../features/profile/profile_tab.dart';
import '../../features/recommendations/recommendations_tab.dart';
import '../../features/splash/splash_page.dart';
import '../auth/auth_state.dart';

/// 路由表。
///
/// V1：
///   /splash             启动决策页（auth bootstrap 期间显示）
///   /login              user 登录
///   /chat               已登录主壳第 1 tab（聊天，含与顾问 1v1）
///   /recommendations    第 2 tab（推荐流）
///   /profile            第 3 tab（我的档案）
///   /notifications      第 4 tab（通知）
///
/// 由 AuthState 自动重定向：loading → /splash; unauthed/error → /login;
/// authed 默认进 /chat。
///
/// 4-tab 底栏遵循 CRM ADR-0016 §3 (App 端栈式 + 底部 Tab)；
/// 跟姊妹仓 staff 仓的桌面三栏 shell 完全不同。
class AppRouter {
  const AppRouter._();

  static GoRouter build(Ref ref) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: _AuthListenable(ref),
      redirect: (BuildContext ctx, GoRouterState state) {
        final AuthState auth = ref.read(authStateProvider);
        final String loc = state.matchedLocation;

        if (auth is AuthLoading) {
          return loc == '/splash' ? null : '/splash';
        }
        if (auth is AuthUnauthed || auth is AuthError) {
          return loc == '/login' ? null : '/login';
        }
        if (auth is AuthAuthed) {
          if (loc == '/login' || loc == '/splash') return '/chat';
          return null;
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/splash',
          builder: (_, __) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (_, __) => const LoginPage(),
        ),
        // 主壳: 4-tab StatefulShellRoute
        StatefulShellRoute.indexedStack(
          builder: (BuildContext ctx, GoRouterState state,
                  StatefulNavigationShell navigationShell) =>
              MainTabShell(navigationShell: navigationShell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/chat',
                  builder: (_, __) => const ChatTab(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/recommendations',
                  builder: (_, __) => const RecommendationsTab(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/profile',
                  builder: (_, __) => const ProfileTab(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/notifications',
                  builder: (_, __) => const NotificationsTab(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// 把 Riverpod 的 AuthState 变化桥接到 GoRouter 的 Listenable。
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    _sub = ref.listen<AuthState>(
      authStateProvider,
      (AuthState? prev, AuthState next) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
