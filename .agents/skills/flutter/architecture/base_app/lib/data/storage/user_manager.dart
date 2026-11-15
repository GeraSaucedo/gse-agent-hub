import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';
import 'package:gse_base_app/domain/models/user.dart';

/// Single place for the logged-in user.
///
/// Read it anywhere, without the service locator:
/// ```dart
/// final name = UserManager.current?.name;
/// ```
///
/// [current] is kept up to date by this class:
/// - [getUser] loads the copy saved on disk (`ConfigRepository` calls it
///   before showing the home).
/// - [saveUser] sets it after loading the profile.
/// - [clearUserData] empties it; `AuthRepository` calls it when the session
///   ends.
///
/// [current] does not notify the UI when it changes. If the user can change
/// while a screen is open (e.g. editing the profile), expose it via a cubit.
class UserManager {
  new({required this._storage});

  static const _userKey = 'user_data';
  final LocalStorageService _storage;

  static User? _current;

  /// Logged-in user, or `null` if there is no session or it is not loaded.
  static User? get current => _current;

  /// Resets [current] between tests.
  @visibleForTesting
  static void resetCurrent() => _current = null;

  /// [current] if loaded; otherwise reads the copy saved on disk.
  Future<User?> getUser() async {
    if (_current != null) return _current;

    final userJson = await _storage.getString(_userKey);
    if (userJson == null) return null;

    try {
      return _current = User.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
    } catch (e, stack) {
      // Corrupt or outdated copy: drop it, the profile is loaded again.
      AppLogger.e('UserManager.getUser', error: e, stackTrace: stack);
      await _storage.remove(_userKey);
      return null;
    }
  }

  Future<void> saveUser(User user) async {
    _current = user;
    await _storage.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> clearUserData() async {
    _current = null;
    await _storage.remove(_userKey);
  }
}
