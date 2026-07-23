import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'app_locale';

/// Controls the current [Locale] and persists it in [SharedPreferences].
class LocaleController extends ChangeNotifier {
  /// Creates a [LocaleController] with the given [defaultLocale]
  /// and [supportedLocales].
  LocaleController({
    required this.supportedLocales,
    Locale defaultLocale = const Locale('es'),
  }) : _locale = defaultLocale {
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
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) {
      final match = supportedLocales.where(
        (l) => l.languageCode == saved,
      );
      if (match.isNotEmpty) {
        _locale = match.first;
        notifyListeners();
      }
    }
  }
}
