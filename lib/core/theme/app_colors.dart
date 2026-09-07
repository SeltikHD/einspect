import 'package:flutter/material.dart';

class AppColorPalette {
  final Color primary;
  final Color navy;
  final Color background;
  final Color surface;
  final Color border;
  final Color text;
  final Color mutedText;
  final Color success;
  final Color warning;
  final Color danger;
  final Color neutral;

  const AppColorPalette({
    required this.primary,
    required this.navy,
    required this.background,
    required this.surface,
    required this.border,
    required this.text,
    required this.mutedText,
    required this.success,
    required this.warning,
    required this.danger,
    required this.neutral,
  });
}

abstract final class AppColors {
  static const light = AppColorPalette(
    primary: Color(0xFF0056B3),
    navy: Color(0xFF0A192F),
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE2E8F0),
    text: Color(0xFF0F172A),
    mutedText: Color(0xFF475569),
    success: Color(0xFF1B8755),
    warning: Color(0xFFD97706),
    danger: Color(0xFFDC2626),
    neutral: Color(0xFF64748B),
  );

  static const dark = AppColorPalette(
    primary: Color(0xFF4DA3FF),
    navy: Color(0xFF1E293B),
    background: Color(0xFF121824),
    surface: Color(0xFF1E293B),
    border: Color(0xFF334155),
    text: Color(0xFFF8FAFC),
    mutedText: Color(0xFFCBD5E1),
    success: Color(0xFF22C55E),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFEF4444),
    neutral: Color(0xFF94A3B8),
  );

  static AppColorPalette of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}
