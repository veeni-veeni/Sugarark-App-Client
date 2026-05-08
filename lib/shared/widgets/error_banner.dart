import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 错误提示 banner——简洁红框 + 文案，不带 icon 闪烁等。
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.12),
        border: Border.all(color: AppColors.error, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.error, fontSize: 13),
      ),
    );
  }
}
