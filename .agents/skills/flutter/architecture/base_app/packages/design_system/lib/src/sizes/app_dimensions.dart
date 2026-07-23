import 'package:flutter/material.dart';

/// Responsive dimension utilities based on screen size.
class AppDimensions {
  /// Creates an [AppDimensions] with the given [BuildContext].
  const AppDimensions(this.context);

  /// Build context used to access screen size.
  final BuildContext context;

  // Base design constant (frame width in Figma)
  static const double _designWidth = 375;

  // Centralized scale factors
  static const double _tabletScaleFactor = 1.25;
  static const double _spMaxMobile = 1.15;
  static const double _spMaxTablet = 1.25;
  static const double _spMin = 0.85;

  /// Current screen size.
  Size get screenSize => MediaQuery.sizeOf(context);

  /// Current screen width.
  double get screenWidth => screenSize.width;

  /// Current screen height.
  double get screenHeight => screenSize.height;

  // Device flags
  /// `true` if the device is a TV (shortestSide >= 1800).
  bool get isTv => screenSize.shortestSide >= 1800;

  /// `true` if the device is a Desktop (shortestSide >= 1200).
  bool get isDesktop => !isTv && screenSize.shortestSide >= 1200;

  /// `true` if the device is a Tablet (shortestSide >= 600).
  bool get isTablet => !isDesktop && !isTv && screenSize.shortestSide >= 600;

  /// `true` if the device is a Mobile.
  bool get isMobile => !isTablet && !isDesktop && !isTv;

  // Orientation
  /// Current device orientation.
  Orientation get orientation => MediaQuery.orientationOf(context);

  /// `true` if the orientation is landscape.
  bool get isLandscape => orientation == Orientation.landscape;

  /// `true` if the orientation is portrait.
  bool get isPortrait => !isLandscape;

  // Safe area
  /// View padding (notch, navigation bar, etc.).
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(context);

  /// View insets (keyboard, etc.).
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(context);

  // Proportional units
  /// Returns [perc]% of the screen height.
  double h(num perc) => screenHeight * (perc / 100);

  /// Returns [perc]% of the screen width.
  double w(num perc) => screenWidth * (perc / 100);

  /// Scales [baseSize] according to screen width with min/max clamps.
  double sp(num baseSize) {
    final scaleFactor = screenWidth / _designWidth;
    final scaled = baseSize * scaleFactor;
    final maxFactor = isTablet ? _spMaxTablet : _spMaxMobile;
    return scaled.clamp(baseSize * _spMin, baseSize * maxFactor);
  }

  /// Scales [size] ×1.25 on tablet, unchanged on mobile.
  double a(num size) {
    if (isTablet) return size * _tabletScaleFactor;
    return size.toDouble();
  }
}

/// [BuildContext] extension for accessing dimension utilities.
extension AppDimensionsExtension on BuildContext {
  AppDimensions get _dim => AppDimensions(this);

  /// Returns [perc]% of the screen width.
  double w(num perc) => _dim.w(perc);

  /// Returns [perc]% of the screen height.
  double h(num perc) => _dim.h(perc);

  /// Scales a font size according to screen width.
  double sp(num size) => _dim.sp(size);

  /// Scales [size] adaptively (×1.25 on tablet).
  double adaptive(num size) => _dim.a(size);

  /// `true` if the device is a TV.
  bool get isTv => _dim.isTv;

  /// `true` if the device is a Desktop.
  bool get isDesktop => _dim.isDesktop;

  /// `true` if the device is a Tablet.
  bool get isTablet => _dim.isTablet;

  /// `true` if the device is a Mobile.
  bool get isMobile => _dim.isMobile;

  /// `true` if the orientation is landscape.
  bool get isLandscape => _dim.isLandscape;

  /// `true` if the orientation is portrait.
  bool get isPortrait => _dim.isPortrait;

  /// View padding (notch, navigation bar, etc.).
  EdgeInsets get viewPadding => _dim.viewPadding;

  /// View insets (keyboard, etc.).
  EdgeInsets get viewInsets => _dim.viewInsets;
}
