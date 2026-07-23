import 'package:flutter/material.dart';
import 'package:gse_design_system/src/sizes/app_dimensions.dart';

/// Adaptive border radius tokens for the Design System.
/// Automatically scale ×1.25 on tablet.
class AppRadius {
  /// Creates an [AppRadius] with the given [BuildContext].
  const AppRadius(this._context);

  final BuildContext _context;

  /// Small: 4 (tablet: 5).
  double get sm => _context.adaptive(4);

  /// Medium: 8 (tablet: 10).
  double get md => _context.adaptive(8);

  /// Large: 12 (tablet: 15).
  double get lg => _context.adaptive(12);

  /// Extra large: 16 (tablet: 20).
  double get xl => _context.adaptive(16);

  /// Circular (pill/capsule): 999.
  double get circular => 999;
}

/// [BuildContext] extension for accessing border radius tokens.
extension RadiusExtension on BuildContext {
  /// Returns the Design System border radius tokens.
  AppRadius get radius => AppRadius(this);
}
