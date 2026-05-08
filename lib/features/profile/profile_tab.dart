import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';
import '../../core/theme/app_colors.dart';

/// 档案 tab — V1 占位。
///
/// 目标 (Phase 2.5.5): 我的档案查看 + 编辑；
/// Phase 2.5.7 接视频认证流程入口。
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState state = ref.watch(authStateProvider);
    final String email = state is AuthAuthed ? state.user.email : '';
    final String membership =
        state is AuthAuthed ? state.user.membership : 'free';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('档案'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.person_outline,
                  size: 64, color: AppColors.gold),
              const SizedBox(height: 16),
              const Text(
                '我的档案',
                style: TextStyle(fontSize: 18, color: AppColors.text),
              ),
              const SizedBox(height: 8),
              if (email.isNotEmpty)
                Text(
                  email,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 13),
                ),
              const SizedBox(height: 4),
              Text(
                '会员等级: $membership',
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text(
                'Phase 2.5.5 档案查看 + 编辑上线',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
