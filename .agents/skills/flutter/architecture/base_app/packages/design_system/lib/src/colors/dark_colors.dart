import 'package:flutter/material.dart';
import 'package:gse_design_system/src/colors/app_color_scheme.dart';

/// Dark color palette for the Design System.
class DarkColors {
  /// Dark color tokens.
  static const AppColorScheme colors = AppColorScheme(
    // Surfaces
    scaffoldBackground: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    // On-Surface Hierarchy
    onSurfaceLow: Color(0xFF334155),
    onSurface: Color(0xFF475569),
    onSurfaceHigh: Color(0xFF64748B),
    // Typography
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textDisabled: Color(0xFF475569),
    // Brand
    primary: Color(0xFF38BDF8),
    onPrimary: Color(0xFF0C4A6E),
    secondary: Color(0xFF7DD3FC),
    onSecondary: Color(0xFF082F49),
    accent: Color(0xFFA78BFA),
    onAccent: Color(0xFF1E1B4B),
    // Disabled
    disabled: Color(0xFF1E293B),
    onDisabled: Color(0xFF64748B),
    // Semantic
    error: Color(0xFFF87171),
    onError: Color(0xFF450A0A),
    success: Color(0xFF4ADE80),
    onSuccess: Color(0xFF052E16),
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFF1C1917),
    info: Color(0xFF60A5FA),
    onInfo: Color(0xFF1E3A5F),
  );
}
