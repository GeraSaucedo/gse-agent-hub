import 'dart:convert';
import 'package:gse_base_app/core/services/storage/contract/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends StorageService {
  LocalStorageService({required SharedPreferences storage})
    : _storage = storage;

  final SharedPreferences _storage;

  /// Clears all data from local storage.
  @override
  Future<void> clear() async {
    await _storage.clear();
  }

  /// Reads a value from local storage.
  ///
  /// [key] is the key to read from.
  /// Returns the value associated with [key], or null if not found.
  /// Throws [FormatException] if stored JSON is invalid.
  @override
  Future<T?> read<T>({required String key}) async {
    _validateKey(key);

    switch (T) {
      case const (int):
        return _storage.getInt(key) as T?;
      case const (double):
        return _storage.getDouble(key) as T?;
      case const (String):
        return _storage.getString(key) as T?;
      case const (bool):
        return _storage.getBool(key) as T?;
      case const (List):
      case const (Map):
        final jsonString = _storage.getString(key);
        if (jsonString == null) return null;
        try {
          return jsonDecode(jsonString) as T?;
        } on FormatException {
          throw FormatException('Invalid JSON in storage for key: $key');
        }
      default:
        throw UnimplementedError(
          'GET not implemented for type ${T.runtimeType}',
        );
    }
  }

  /// Deletes a value from local storage.
  ///
  /// [key] is the key to delete.
  /// Returns true if the value was successfully deleted, false otherwise.
  @override
  Future<bool> delete({required String key}) async {
    _validateKey(key);
    return _storage.remove(key);
  }

  /// Writes a value to local storage.
  ///
  /// [key] is the key to write to.
  /// [value] is the value to write.
  /// Throws [UnimplementedError] if the type of [value] is not supported.
  @override
  Future<void> write<T>({required String key, required T value}) async {
    _validateKey(key);

    switch (T) {
      case const (int):
        await _storage.setInt(key, value as int);
      case const (double):
        await _storage.setDouble(key, value as double);
      case const (String):
        await _storage.setString(key, value as String);
      case const (bool):
        await _storage.setBool(key, value as bool);
      case const (List):
      case const (Map):
        await _storage.setString(key, jsonEncode(value));
      default:
        throw UnimplementedError(
          'SET not implemented for type ${T.runtimeType}',
        );
    }
  }

  void _validateKey(String key) {
    if (key.isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }
  }
}
