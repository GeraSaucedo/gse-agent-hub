import 'package:flutter/material.dart';
import 'package:gse_design_system/src/sizes/app_dimensions.dart';

/// Adaptive spacing tokens for the Design System.
/// Automatically scale ×1.25 on tablet.
class AppSpacing {
  /// Creates an [AppSpacing] with the given [BuildContext].
  const AppSpacing(this._context);

  final BuildContext _context;

  /// Extra small: 4 (tablet: 5).
  double get xs => _context.adaptive(4.0);

  /// Small: 8 (tablet: 10).
  double get sm => _context.adaptive(8.0);

  /// Medium: 16 (tablet: 20).
  double get md => _context.adaptive(16.0);

  /// Large: 24 (tablet: 30).
  double get lg => _context.adaptive(24.0);

  /// Extra large: 32 (tablet: 40).
  double get xl => _context.adaptive(32.0);

  /// Extra extra large: 48 (tablet: 60).
  double get xxl => _context.adaptive(48.0);
}

/// [BuildContext] extension for accessing spacing tokens.
extension SpacingExtension on BuildContext {
  /// Returns the Design System spacing tokens.
  AppSpacing get spacing => AppSpacing(this);
}
