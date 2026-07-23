import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gse_design_system/src/styles/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeModeKey = 'gse_ds_theme_mode';

/// Design System controller.
///
/// Manages the active [ThemeMode], persists it in [SharedPreferences],
/// and notifies listeners on change.
///
/// To avoid a theme flash on startup, use [DSController.preload]
/// before `runApp`:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final controller = await DSController.preload();
///   runApp(MyApp(dsController: controller));
/// }
/// ```
class DSController extends ValueNotifier<ThemeMode> {
  /// Creates a [DSController] with a default [ThemeMode].
  ///
  /// Loads saved preference asynchronously (may produce a brief flash).
  /// For flash-free pre-loading, use [preload].
  DSController({ThemeMode defaultTheme = ThemeMode.dark})
      : super(defaultTheme) {
    unawaited(_load());
  }

  /// Internal constructor that does not trigger [_load] automatically.
  DSController._internal({ThemeMode defaultTheme = ThemeMode.dark})
      : super(defaultTheme);

  SharedPreferences? _prefs;

  // Cached ThemeData — built once and reused.
  ThemeData? _lightCache;
  ThemeData? _darkCache;

  Future<SharedPreferences> get _sharedPrefs async =>
      _prefs ??= await SharedPreferences.getInstance();

  // ── Factory ──────────────────────────────────────────────────────────────

  /// Creates a [DSController] by loading saved preferences **before**
  /// returning, eliminating the theme flash on startup.
  static Future<DSController> preload({
    ThemeMode defaultTheme = ThemeMode.dark,
  }) async {
    final controller = DSController._internal(defaultTheme: defaultTheme);
    await controller._load();
    return controller;
  }

  // ── Getters ──────────────────────────────────────────────────────────────

  /// The active theme mode.
  ThemeMode get themeMode => value;

  /// `true` if the active theme is dark.
  bool get isDark => value == ThemeMode.dark;

  /// Light [ThemeData]. Cached after first access.
  ThemeData get lightTheme => _lightCache ??= AppTheme.light;

  /// Dark [ThemeData]. Cached after first access.
  ThemeData get darkTheme => _darkCache ??= AppTheme.dark;

  // ── Mutators ─────────────────────────────────────────────────────────────

  /// Changes the [ThemeMode] and persists the selection.
  Future<void> setThemeMode(ThemeMode mode) async {
    value = mode;
    final prefs = await _sharedPrefs;
    await prefs.setString(_kThemeModeKey, _themeModeToString(mode));
  }

  /// Toggles between light and dark. If system, switches to dark.
  Future<void> toggleTheme() async {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  // ── Internals ────────────────────────────────────────────────────────────

  Future<void> _load() async {
    final prefs = await _sharedPrefs;
    final saved = prefs.getString(_kThemeModeKey);
    if (saved != null) {
      value = _stringToThemeMode(saved);
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  static ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
