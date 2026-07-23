import 'package:flutter/material.dart';

/// Extensions for fluent Color manipulation.
/// Intended usage: context.appcolors.surface.o10
extension ColorOpacityExtension on Color {
  /// 10% opacity.
  Color get o10 => withValues(alpha: 0.1);

  /// 20% opacity.
  Color get o20 => withValues(alpha: 0.2);

  /// 50% opacity.
  Color get o50 => withValues(alpha: 0.5);

  /// 80% opacity.
  Color get o80 => withValues(alpha: 0.8);
}
