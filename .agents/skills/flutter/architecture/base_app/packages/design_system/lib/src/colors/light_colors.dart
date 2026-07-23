import 'package:flutter/material.dart';
import 'package:gse_design_system/src/colors/app_color_scheme.dart';

/// Light color palette for the Design System.
class LightColors {
  /// Light color tokens.
  static const AppColorScheme colors = AppColorScheme(
    // Surfaces
    scaffoldBackground: Color(0xFFFFFFFF),
    surface: Color(0xFFF1F5F9),
    // On-Surface Hierarchy
    onSurfaceLow: Color(0xFFE2E8F0),
    onSurface: Color(0xFFCBD5E1),
    onSurfaceHigh: Color(0xFF94A3B8),
    // Typography
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textDisabled: Color(0xFFCBD5E1),
    // Brand
    primary: Color(0xFF0284C7),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF0EA5E9),
    onSecondary: Color(0xFFFFFFFF),
    accent: Color(0xFF7C3AED),
    onAccent: Color(0xFFFFFFFF),
    // Disabled
    disabled: Color(0xFFE2E8F0),
    onDisabled: Color(0xFF94A3B8),
    // Semantic
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    success: Color(0xFF10B981),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFF59E0B),
    onWarning: Color(0xFF1C1917),
    info: Color(0xFF3B82F6),
    onInfo: Color(0xFFFFFFFF),
  );
}
