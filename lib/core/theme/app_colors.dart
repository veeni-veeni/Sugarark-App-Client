import 'package:flutter/material.dart';

/// 品牌色彩 token，对齐主仓 sugarark/CLAUDE.md §品牌设计规范。
///
/// 色板：金 #C9A84C / 黑 #080808 / Cormorant + Montserrat。
/// 黑底金字 + 留白；面向客户的端 App 比 staff 更强调"私享会籍感"
/// (CRM ADR-0016 §1)，但色彩 token 跟 staff 仓共用，差异在版式 + 留白。
class AppColors {
  const AppColors._();

  /// 主品牌色（金）。
  static const Color gold = Color(0xFFC9A84C);

  /// 主背景（黑）。
  static const Color black = Color(0xFF080808);

  /// 次级表面（卡片 / 输入框背景）。
  static const Color surface = Color(0xFF111111);

  /// 主文字。
  static const Color text = Color(0xFFF5F0E8);

  /// 次级文字（0.6 alpha）。
  static const Color textMuted = Color(0x99F5F0E8);

  /// 边框（金色 0.15 alpha）。
  static const Color border = Color(0x26C9A84C);

  /// 错误色。
  static const Color error = Color(0xFFE57373);
}
