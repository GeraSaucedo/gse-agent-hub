import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive local storage (preferences, flags, cached JSON).
///
/// Managers depend on this class, never on [SharedPreferences] directly,
/// so switching the backend (e.g. to Hive) only changes this file.
/// Methods are async on purpose, so an async backend fits the same API.
///
/// To store objects, encode them as JSON and use [setString]/[getString].
class LocalStorageService {
  new({required this._storage});

  final SharedPreferences _storage;

  Future<bool?> getBool(String key) async => _storage.getBool(key);

  Future<void> setBool(String key, {required bool value}) =>
      _storage.setBool(key, value);

  Future<int?> getInt(String key) async => _storage.getInt(key);

  Future<void> setInt(String key, int value) => _storage.setInt(key, value);

  Future<double?> getDouble(String key) async => _storage.getDouble(key);

  Future<void> setDouble(String key, double value) =>
      _storage.setDouble(key, value);

  Future<String?> getString(String key) async => _storage.getString(key);

  Future<void> setString(String key, String value) =>
      _storage.setString(key, value);

  Future<List<String>?> getStringList(String key) async =>
      _storage.getStringList(key);

  Future<void> setStringList(String key, List<String> value) =>
      _storage.setStringList(key, value);

  Future<void> remove(String key) => _storage.remove(key);

  Future<void> clear() => _storage.clear();
}
