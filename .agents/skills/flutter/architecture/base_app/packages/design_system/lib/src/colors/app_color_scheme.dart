import 'package:flutter/material.dart';

/// Semantic color scheme for the Design System.
/// Injected as a ThemeExtension and accessed via `context.colors`.
///
/// ## Token types
///
/// ### Material-mapped
/// Published to the native [ColorScheme] via [toColorScheme]. Material 3
/// widgets (`FilledButton`, `TextField`, `NavigationBar`, etc.) consume them
/// automatically when the theme or brand changes.
///
/// ### Custom
/// Have no equivalent in [ColorScheme]. They change with the theme just like
/// the rest, but must be used **explicitly** in custom components:
/// ```dart
/// Text('Label', style: TextStyle(color: context.colors.textDisabled))
/// ```
/// Custom tokens: [onSurfaceHigh], [textDisabled], [accent], [onAccent],
/// [disabled], [onDisabled], [onSuccess], [onWarning], [onInfo].
@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  /// Creates an [AppColorScheme] with all required color tokens.
  const AppColorScheme({
    // --- SURFACES ---
    required this.scaffoldBackground,
    required this.surface,
    // --- ON-SURFACE HIERARCHY ---
    required this.onSurfaceLow,
    required this.onSurface,
    required this.onSurfaceHigh,
    // --- TYPOGRAPHY ---
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    // --- BRAND ---
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.accent,
    required this.onAccent,
    // --- DISABLED STATE ---
    required this.disabled,
    required this.onDisabled,
    // --- SEMANTIC ---
    required this.error,
    required this.onError,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
  });

  // ── 1. Surfaces & Backgrounds ─────────────────────────────────────────────

  /// [Material-mapped → ColorScheme.surface]
  /// Base background of the application (Scaffold, AppBar).
  final Color scaffoldBackground;

  /// [Material-mapped → ColorScheme.surfaceContainerLow]
  /// Background for containers, cards, bottom sheets, and modals.
  final Color surface;

  // ── 2. On-Surface Hierarchy (Borders & Icons) ─────────────────────────────

  /// [Material-mapped → ColorScheme.outlineVariant]
  /// Subtle borders, dividers, and placeholder text.
  final Color onSurfaceLow;

  /// [Material-mapped → ColorScheme.outline]
  /// Standard borders and secondary icons or inactive elements.
  final Color onSurface;

  /// [Custom]
  /// Focus borders, hover state, and active icons.
  final Color onSurfaceHigh;

  // ── 3. Typography ─────────────────────────────────────────────────────────

  /// [Material-mapped → ColorScheme.onSurface]
  /// Headings and high-contrast primary body text.
  final Color textPrimary;

  /// [Material-mapped → ColorScheme.onSurfaceVariant]
  /// Subtitles, supporting text, and labels.
  final Color textSecondary;

  /// [Custom]
  /// Text for disabled elements (non-interactive).
  final Color textDisabled;

  // ── 4. Brand & Identity ───────────────────────────────────────────────────

  /// [Material-mapped → ColorScheme.primary]
  /// Primary brand color for primary actions (CTA, FAB, active states).
  final Color primary;

  /// [Material-mapped → ColorScheme.onPrimary]
  /// Content color (text/icons) on top of [primary].
  final Color onPrimary;

  /// [Material-mapped → ColorScheme.secondary]
  /// Secondary brand color for accents and secondary actions.
  final Color secondary;

  /// [Material-mapped → ColorScheme.onSecondary]
  /// Content color (text/icons) on top of [secondary].
  final Color onSecondary;

  /// [Material-mapped → ColorScheme.tertiary]
  /// Color for special Call to Action (CTA) or promotional use.
  final Color accent;

  /// [Material-mapped → ColorScheme.onTertiary]
  /// Content color (text/icons) on top of [accent].
  final Color onAccent;

  // ── 5. Disabled State ─────────────────────────────────────────────────────

  /// [Custom]
  /// Background color for disabled components.
  final Color disabled;

  /// [Custom]
  /// Content color (text/icons) on top of a [disabled] background.
  final Color onDisabled;

  // ── 6. Semantic (System Status) ───────────────────────────────────────────

  /// [Material-mapped → ColorScheme.error]
  /// Errors and critical validations.
  final Color error;

  /// [Material-mapped → ColorScheme.onError]
  /// Content color on top of [error].
  final Color onError;

  /// [Custom]
  /// Confirmations and positive states.
  final Color success;

  /// [Custom]
  /// Content color on top of [success].
  final Color onSuccess;

  /// [Custom]
  /// Warnings and cautions.
  final Color warning;

  /// [Custom]
  /// Content color on top of [warning].
  final Color onWarning;

  /// [Custom]
  /// Neutral information and announcements.
  final Color info;

  /// [Custom]
  /// Content color on top of [info].
  final Color onInfo;

  // ── ThemeExtension ────────────────────────────────────────────────────────

  @override
  AppColorScheme copyWith({
    Color? scaffoldBackground,
    Color? surface,
    Color? onSurfaceLow,
    Color? onSurface,
    Color? onSurfaceHigh,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? accent,
    Color? onAccent,
    Color? disabled,
    Color? onDisabled,
    Color? error,
    Color? onError,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) {
    return AppColorScheme(
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      surface: surface ?? this.surface,
      onSurfaceLow: onSurfaceLow ?? this.onSurfaceLow,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceHigh: onSurfaceHigh ?? this.onSurfaceHigh,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
    );
  }

  @override
  AppColorScheme lerp(covariant AppColorScheme? other, double t) {
    if (other == null) return this;
    return AppColorScheme(
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurfaceLow: Color.lerp(onSurfaceLow, other.onSurfaceLow, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceHigh: Color.lerp(onSurfaceHigh, other.onSurfaceHigh, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      onDisabled: Color.lerp(onDisabled, other.onDisabled, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
    );
  }

  /// Publishes the Material-mapped tokens to Flutter's native [ColorScheme].
  /// [Custom] tokens are not mapped here — use them via `context.colors`.
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      // Surfaces
      surface: scaffoldBackground,
      surfaceContainerLow: surface,
      // Text
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      // Borders
      outline: onSurface,
      outlineVariant: onSurfaceLow,
      // Brand
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      tertiary: accent,
      onTertiary: onAccent,
      // Semantic
      error: error,
      onError: onError,
    );
  }
}

/// [BuildContext] extension for accessing the active [AppColorScheme].
extension AppColorSchemeX on BuildContext {
  /// Returns the [AppColorScheme] from the active theme.
  ///
  /// Throws an [AssertionError] if the theme does not contain [AppColorScheme].
  /// Make sure `DSProvider` is present in the widget tree.
  AppColorScheme get colors {
    final scheme = Theme.of(this).extension<AppColorScheme>();
    assert(
      scheme != null,
      'AppColorScheme not found in theme. '
      'Wrap your app with DSProvider or use AppTheme.build() '
      'to construct your ThemeData.',
    );
    return scheme!;
  }
}
