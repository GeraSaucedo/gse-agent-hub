import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypted storage for sensitive values (tokens, API keys).
///
/// Only stores [String]. Managers depend on this class, never on
/// [FlutterSecureStorage] directly, which also makes it easy to fake in tests.
class SecureStorageService {
  new({required this._secureStorage});

  final FlutterSecureStorage _secureStorage;

  /// Returns the value for [key], or `null` if it does not exist.
  Future<String?> read(String key) => _secureStorage.read(key: key);

  /// Saves [value] under [key], replacing any previous value.
  Future<void> write(String key, String value) =>
      _secureStorage.write(key: key, value: value);

  /// Deletes [key]. Does nothing if it does not exist.
  Future<void> delete(String key) => _secureStorage.delete(key: key);

  /// Deletes every stored value.
  Future<void> clear() => _secureStorage.deleteAll();
}
