import 'package:einspect/core/theme/app_colors.dart';
import 'package:einspect/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(AppColors.light, Brightness.light);

  static ThemeData get dark => _buildTheme(AppColors.dark, Brightness.dark);

  static ThemeData _buildTheme(AppColorPalette colors, Brightness brightness) {
    final colorScheme = brightness == Brightness.dark
        ? ColorScheme.dark(
            primary: colors.primary,
            onPrimary: colors.background,
            secondary: colors.primary,
            onSecondary: colors.background,
            surface: colors.surface,
            onSurface: colors.text,
            error: colors.danger,
            onError: colors.background,
            outline: colors.border,
            outlineVariant: colors.border,
            surfaceContainerHighest: colors.background,
          )
        : ColorScheme.light(
            primary: colors.primary,
            onPrimary: colors.surface,
            secondary: colors.navy,
            onSecondary: colors.surface,
            surface: colors.surface,
            onSurface: colors.text,
            error: colors.danger,
            onError: colors.surface,
            outline: colors.border,
            outlineVariant: colors.border,
            surfaceContainerHighest: colors.background,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: colors.navy,
        foregroundColor: colors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colors.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.minTapTarget),
          backgroundColor: colors.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colors.neutral.withValues(alpha: .35),
          disabledForegroundColor: colors.text.withValues(alpha: .55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.minTapTarget),
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: _inputBorder(colors.border),
        enabledBorder: _inputBorder(colors.border),
        focusedBorder: _inputBorder(colors.primary, width: 2),
        errorBorder: _inputBorder(colors.danger),
        focusedErrorBorder: _inputBorder(colors.danger, width: 2),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          side: BorderSide(color: colors.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
