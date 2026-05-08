import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 启动页——只显示品牌字样 + 转圈，路由层根据 AuthState 自动跳走。
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'SUGARARK',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 8,
                  ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
