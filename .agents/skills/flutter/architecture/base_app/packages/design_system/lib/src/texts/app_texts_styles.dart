import 'package:flutter/material.dart';
import 'package:gse_design_system/src/config/ds_config.dart';
import 'package:gse_design_system/src/sizes/app_dimensions.dart';

export 'package:gse_design_system/src/texts/weight_extension.dart';

/// Semantic and responsive text styles for the Design System.
///
/// Each token encapsulates **size + canonical weight + line-height**.
/// Extensions (`.bold`, `.italic`, `.c(color)`) are optional and chainable.
///
/// ```dart
/// context.textStyles.bodyMed
/// context.textStyles.bodyMed.bold
/// context.textStyles.headLarge.semibold.italic
/// context.textStyles.titleSmall.c(context.colors.primary)
/// ```
class TextStyles {
  /// Creates [TextStyles] bound to [context] for responsive scaling.
  TextStyles(this.context);

  /// Build context used to scale font sizes via `sp()`.
  final BuildContext context;

  static const String _font = DSConfig.fontPrimary;

  TextStyle _base(double size, FontWeight weight, double height) => TextStyle(
        fontFamily: _font,
        fontSize: size,
        fontWeight: weight,
        height: height,
      );

  // ── Head ──────────────────────────────────────────────────────────────────

  /// 28sp · w700 · 1.2
  TextStyle get headLarge => _base(context.sp(28), FontWeight.w700, 1.2);

  /// 24sp · w700 · 1.2
  TextStyle get headMed => _base(context.sp(24), FontWeight.w700, 1.2);

  /// 20sp · w600 · 1.3
  TextStyle get headSmall => _base(context.sp(20), FontWeight.w600, 1.3);

  // ── Title ─────────────────────────────────────────────────────────────────

  /// 18sp · w600 · 1.3
  TextStyle get titleLarge => _base(context.sp(18), FontWeight.w600, 1.3);

  /// 16sp · w600 · 1.3
  TextStyle get titleMed => _base(context.sp(16), FontWeight.w600, 1.3);

  /// 14sp · w600 · 1.4
  TextStyle get titleSmall => _base(context.sp(14), FontWeight.w600, 1.4);

  // ── Body ──────────────────────────────────────────────────────────────────

  /// 16sp · w400 · 1.6
  TextStyle get bodyLarge => _base(context.sp(16), FontWeight.w400, 1.6);

  /// 14sp · w400 · 1.5
  TextStyle get bodyMed => _base(context.sp(14), FontWeight.w400, 1.5);

  /// 12sp · w400 · 1.5
  TextStyle get bodySmall => _base(context.sp(12), FontWeight.w400, 1.5);

  // ── Label ─────────────────────────────────────────────────────────────────

  /// 14sp · w500 · 1.4
  TextStyle get labelLarge => _base(context.sp(14), FontWeight.w500, 1.4);

  /// 12sp · w500 · 1.4
  TextStyle get labelMed => _base(context.sp(12), FontWeight.w500, 1.4);

  /// 11sp · w500 · 1.3
  TextStyle get labelSmall => _base(context.sp(11), FontWeight.w500, 1.3);

  // ── Caption ───────────────────────────────────────────────────────────────

  /// 12sp · w400 · 1.4
  TextStyle get captionMed => _base(context.sp(12), FontWeight.w400, 1.4);

  /// 10sp · w400 · 1.3
  TextStyle get captionSmall => _base(context.sp(10), FontWeight.w400, 1.3);
}

/// [BuildContext] extension for accessing text styles.
extension TextStyleExtension on BuildContext {
  /// Returns the Design System text styles.
  TextStyles get textStyles => TextStyles(this);
}
