/// GSE Design System — single entry point.
///
/// Import this package in your app:
///   import 'package:gse_design_system/gse_design_system.dart';
///
/// ─── SETUP ───────────────────────────────────────────────────────────────
///
/// ```dart
/// final controller = await DSController.preload();
///
/// DSProvider(
///   controller: controller,
///   child: Builder(
///     builder: (context) {
///       final ds = DSProvider.of(context);
///       return MaterialApp(
///         theme:     ds.lightTheme,
///         darkTheme: ds.darkTheme,
///         themeMode: ds.themeMode,
///       );
///     },
///   ),
/// );
/// ```
///
/// ─── TOGGLE THEME ────────────────────────────────────────────────────────
///
/// ```dart
/// context.ds.toggleTheme();
/// context.ds.setThemeMode(ThemeMode.system);
/// ```
///
/// ─── TOKENS FROM CONTEXT ─────────────────────────────────────────────────
///
/// ```dart
/// context.colors.primary
/// context.colors.surface.o10
/// context.textStyles.bodyMed.bold
/// context.textStyles.headLarge.semibold.italic
/// context.spacing.md
/// context.radius.lg
/// context.sp(16)
/// context.w(50)
/// context.isTablet
/// ```
library;

// Colors
export 'src/colors/app_color_scheme.dart';
export 'src/colors/dark_colors.dart';
export 'src/colors/extensions/opacity_extension.dart';
export 'src/colors/light_colors.dart';

// Config
export 'src/config/ds_config.dart';

// Controller
export 'src/controller/ds_controller.dart';
export 'src/controller/ds_provider.dart';

// Sizes
export 'src/sizes/app_dimensions.dart';
export 'src/sizes/app_radius.dart';
export 'src/sizes/app_spacing.dart';

// Styles
export 'src/styles/app_theme.dart';

// Texts
export 'src/texts/app_texts_styles.dart';
export 'src/texts/weight_extension.dart';
