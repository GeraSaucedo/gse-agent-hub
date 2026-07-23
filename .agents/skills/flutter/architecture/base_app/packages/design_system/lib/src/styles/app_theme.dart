import 'package:flutter/material.dart';
import 'package:gse_design_system/src/colors/app_color_scheme.dart';
import 'package:gse_design_system/src/colors/dark_colors.dart';
import 'package:gse_design_system/src/colors/light_colors.dart';
import 'package:gse_design_system/src/config/ds_config.dart';
import 'package:gse_design_system/src/styles/app_theme_styles.dart';

export 'package:gse_design_system/src/colors/extensions/opacity_extension.dart';

/// Builds a complete [ThemeData] from an [AppColorScheme].
class AppTheme {
  /// Light [ThemeData] using the default palette.
  static ThemeData get light => build(
        colors: LightColors.colors,
        brightness: Brightness.light,
      );

  /// Dark [ThemeData] using the default palette.
  static ThemeData get dark => build(
        colors: DarkColors.colors,
        brightness: Brightness.dark,
      );

  /// Assembles a [ThemeData] with the given color scheme and brightness.
  static ThemeData build({
    required AppColorScheme colors,
    required Brightness brightness,
  }) {
    final colorScheme = colors.toColorScheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: [colors],
      scaffoldBackgroundColor: colors.scaffoldBackground,

      // Component styles
      appBarTheme: AppStyles.appBarTheme(colors),
      cardTheme: AppStyles.cardTheme(colors),
      navigationBarTheme: AppStyles.navigationBarTheme(colors),
      filledButtonTheme: AppStyles.filledButtonTheme(colors),
      outlinedButtonTheme: AppStyles.outlinedButtonTheme(colors),
      inputDecorationTheme: AppStyles.inputDecorationTheme(colors),

      // Typography
      fontFamily: DSConfig.fontPrimary,
      textTheme: AppStyles.textTheme(),

      // Extras
      dividerTheme: DividerThemeData(
        color: colors.onSurfaceLow,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surface,
        contentTextStyle: TextStyle(color: colors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
