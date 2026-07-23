import 'package:flutter/material.dart';
import 'package:gse_design_system/src/colors/app_color_scheme.dart';
import 'package:gse_design_system/src/config/ds_config.dart';

// Radius tokens for component themes (no context available here).
// In widgets, use context.radius.lg, etc.
const double _rLg = 12;
const double _rXl = 16;

/// Material component styles for the Design System.
/// Uses [AppColorScheme] to generate the theme for each component.
class AppStyles {
  // --- CARDS ---
  /// Theme for [Card].
  static CardThemeData cardTheme(AppColorScheme colors) {
    return CardThemeData(
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_rXl),
        side: BorderSide(color: colors.onSurfaceLow),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  // --- INPUTS (TextFields) ---
  /// Theme for [TextField] and [InputDecoration].
  static InputDecorationTheme inputDecorationTheme(AppColorScheme colors) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.scaffoldBackground,
      border: _buildOutlineBorder(colors.onSurface),
      enabledBorder: _buildOutlineBorder(colors.onSurface),
      focusedBorder: _buildOutlineBorder(colors.primary, width: 2),
      errorBorder: _buildOutlineBorder(colors.error),
      focusedErrorBorder: _buildOutlineBorder(colors.error, width: 2),
      labelStyle: TextStyle(color: colors.textSecondary),
      hintStyle: TextStyle(color: colors.onSurfaceLow),
    );
  }

  // --- BUTTONS ---
  /// Theme for [FilledButton].
  static FilledButtonThemeData filledButtonTheme(AppColorScheme colors) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_rLg),
        ),
        textStyle: const TextStyle(
          fontFamily: DSConfig.fontPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Theme for [OutlinedButton].
  static OutlinedButtonThemeData outlinedButtonTheme(AppColorScheme colors) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.onSurface),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_rLg),
        ),
        textStyle: const TextStyle(
          fontFamily: DSConfig.fontPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  // --- NAVIGATION ---
  /// Theme for [NavigationBar].
  static NavigationBarThemeData navigationBarTheme(AppColorScheme colors) {
    return NavigationBarThemeData(
      backgroundColor: colors.scaffoldBackground,
      indicatorColor: colors.primary.withValues(alpha: 0.12),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors.primary);
        }
        return IconThemeData(color: colors.textSecondary);
      }),
    );
  }

  // --- APPBAR ---
  /// Theme for [AppBar].
  static AppBarTheme appBarTheme(AppColorScheme colors) {
    return AppBarTheme(
      backgroundColor: colors.scaffoldBackground,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: colors.textPrimary),
    );
  }

  // --- TYPOGRAPHY ---
  /// Base [TextTheme] with fixed sizes (no sp()).
  /// `context.textStyles` overrides these values with sp() at runtime.
  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: _t(32),
      displayMedium: _t(28),
      displaySmall: _t(24),
      headlineLarge: _t(22),
      headlineMedium: _t(20),
      headlineSmall: _t(18),
      titleLarge: _t(18),
      titleMedium: _t(16),
      titleSmall: _t(14),
      labelLarge: _t(14),
      labelMedium: _t(12),
      labelSmall: _t(11),
      bodyLarge: _t(16, height: 1.6),
      bodyMedium: _t(14),
      bodySmall: _t(12),
    );
  }

  static TextStyle _t(double size, {double? height}) => TextStyle(
    fontFamily: DSConfig.fontPrimary,
    fontSize: size,
    height: height,
  );

  // --- HELPER METHODS ---
  static OutlineInputBorder _buildOutlineBorder(
    Color color, {
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_rLg),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
