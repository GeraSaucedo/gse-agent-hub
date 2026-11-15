import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'app_locale';

/// Controls the current [Locale] and persists it in [SharedPreferences].
///
/// It also keeps [Intl.defaultLocale] in sync, so `DateFormat` and
/// `NumberFormat` without an explicit locale follow the app language.
class LocaleController extends ChangeNotifier {
  /// Creates a [LocaleController] with the given [defaultLocale]
  /// and [supportedLocales].
  new({
    required this.supportedLocales,
    Locale defaultLocale = const Locale('es'),
  }) : _locale = defaultLocale {
    Intl.defaultLocale = defaultLocale.toLanguageTag();
    unawaited(_loadSavedLocale());
  }

  /// The list of locales supported by this controller.
  final List<Locale> supportedLocales;

  Locale _locale;

  /// The current locale.
  Locale get locale => _locale;

  /// Changes the current locale and persists the preference.
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale) || locale == _locale) return;
    _apply(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) {
      final match = supportedLocales.where((l) => l.languageCode == saved);
      if (match.isNotEmpty) _apply(match.first);
    }
  }

  void _apply(Locale locale) {
    _locale = locale;
    Intl.defaultLocale = locale.toLanguageTag();
    notifyListeners();
  }
}
