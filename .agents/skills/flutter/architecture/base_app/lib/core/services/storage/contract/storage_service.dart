/// An abstract class representing a storage service for
/// storing and retrieving data.
abstract class StorageService {
  /// Writes a value of generic type [T] to the storage
  /// with the specified [key].
  ///
  /// - [key]: The key under which the value will be stored.
  /// - [value]: The value to be stored.
  Future<void> write<T>({
    required String key,
    required T value,
  });

  /// Reads a value of type [T] from the storage using the specified [key].
  ///
  /// - [key]: The key associated with the value to be retrieved.
  /// Returns: The value associated with the provided [key],
  /// or `null` if not found.
  Future<T?> read<T>({required String key});

  /// Deletes a value from the storage using the specified [key].
  ///
  /// - [key]: The key associated with the value to be deleted.
  Future<void> delete({required String key});

  /// Clears all data stored in the storage.
  Future<void> clear();
}
