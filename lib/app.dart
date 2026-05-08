import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

/// MaterialApp.router 入口；ProviderScope 在 main.dart 包外层。
class SugarArkApp extends ConsumerWidget {
  const SugarArkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(_routerProvider);
    return MaterialApp.router(
      title: 'SugarArk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}

final Provider<GoRouter> _routerProvider =
    Provider<GoRouter>((Ref ref) => AppRouter.build(ref));
