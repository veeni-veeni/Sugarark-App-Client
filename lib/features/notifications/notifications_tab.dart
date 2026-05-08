import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 通知 tab — V1 占位。
///
/// 目标 (Phase 2.5.8): 接公告频道（强制订阅，只读）+ 系统消息列表；
/// Phase 5.5 加日历 / 闹钟提醒 (主仓 ADR-0012)。
class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('通知'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.notifications_outlined,
                  size: 64, color: AppColors.gold),
              SizedBox(height: 16),
              Text(
                '通知',
                style: TextStyle(fontSize: 18, color: AppColors.text),
              ),
              SizedBox(height: 8),
              Text(
                'Phase 2.5.8 公告频道 + 系统消息上线',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
