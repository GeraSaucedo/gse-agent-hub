import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gse_base_app/core/services/storage/contract/storage_service.dart';

/// Service for saving confidential things as ApiKeys, Tokens, etc
class SecureStorageService extends StorageService {
  SecureStorageService({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage,
      super();

  final FlutterSecureStorage _secureStorage;

  /// Encrypts and saves the [key] with the given [value].
  ///
  /// If the key was already in the storage, its associated value is changed.
  /// If the value is null, deletes associated value for the given [key].
  @override
  Future<void> write<T>({required String key, required T value}) async {
    await _secureStorage.write(key: key, value: value as String);
  }

  /// Decrypts and returns the value for the given [key] or
  /// null if [key] is not in the storage.
  ///
  /// [key] shouldn't be null.
  @override
  Future<T?> read<T>({required String key}) async {
    final dynamic result = await _secureStorage.read(key: key);
    return result as T?;
  }

  /// Deletes all keys with associated values.
  @override
  Future<void> clear() => _secureStorage.deleteAll();

  /// Deletes associated value for the given [key].
  ///
  /// If the given [key] does not exist, nothing will happen.
  @override
  Future<void> delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }
}
