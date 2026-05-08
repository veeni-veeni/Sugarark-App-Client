import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 品牌主按钮：金底黑字，2px tracking，工具感（不发光不渐变）。
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final Widget button = ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
              ),
            )
          : Text(label.toUpperCase()),
    );
    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
