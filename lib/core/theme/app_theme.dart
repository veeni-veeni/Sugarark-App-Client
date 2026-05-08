import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 全局主题配置。
///
/// 字体：V1 用系统 serif/sans-serif fallback，V2 接 Google Fonts 或本地 ttf。
/// 文字 letter-spacing：标题 / 按钮 2.0 px tracking（主仓 CLAUDE.md §品牌）。
class AppTheme {
  const AppTheme._();

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        onPrimary: AppColors.black,
        onSurface: AppColors.text,
        error: AppColors.error,
      ),
      // V1：系统默认 sans-serif；V2 切 Montserrat。
      fontFamily: null,
      textTheme: const TextTheme(
        // 标题用 serif 对齐 Cormorant 设定，V2 替换为 Cormorant Garamond。
        headlineLarge: TextStyle(
          fontFamily: 'serif',
          color: AppColors.text,
          fontSize: 32,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'serif',
          color: AppColors.text,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
        ),
        bodyLarge: TextStyle(
          color: AppColors.text,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: AppColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.gold.withOpacity(0.16),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) {
            final bool selected = states.contains(WidgetState.selected);
            return TextStyle(
              color: selected ? AppColors.gold : AppColors.textMuted,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (Set<WidgetState> states) {
            final bool selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? AppColors.gold : AppColors.textMuted,
              size: 24,
            );
          },
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
