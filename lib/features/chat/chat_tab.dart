import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';
import '../../core/theme/app_colors.dart';

/// 聊天 tab — V1 占位。
///
/// 目标 (Phase 2.5.6): 跟分配顾问 1v1 聊天 + 接收 baby 卡片富消息；
/// Phase 2.5.8 加 mutual match 三人引荐群入口。
///
/// 当前: 仅显示"我的顾问会在这里与您沟通"，配登出按钮（debug 期暂留 AppBar 上）。
class ChatTab extends ConsumerWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('聊天'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textMuted),
            tooltip: '登出',
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.gold),
              SizedBox(height: 16),
              Text(
                '我的顾问会在这里与您沟通',
                style: TextStyle(fontSize: 18, color: AppColors.text),
              ),
              SizedBox(height: 8),
              Text(
                'Phase 2.5.6 talkcore 集成上线',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
