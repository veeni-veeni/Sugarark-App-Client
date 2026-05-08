import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 推荐 tab — V1 占位。
///
/// 目标 (Phase 5): 接收顾问推送的 baby 富消息卡片流（schema_version=1，
/// 跟 staff 仓共用 schema, 主仓 Q-006 框架）。
class RecommendationsTab extends StatelessWidget {
  const RecommendationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('推荐'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.favorite_outline, size: 64, color: AppColors.gold),
              SizedBox(height: 16),
              Text(
                '推荐给我的人',
                style: TextStyle(fontSize: 18, color: AppColors.text),
              ),
              SizedBox(height: 8),
              Text(
                'Phase 5 baby 卡片流上线',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
