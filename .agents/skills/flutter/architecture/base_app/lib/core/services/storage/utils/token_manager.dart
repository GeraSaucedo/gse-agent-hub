import 'package:gse_base_app/core/services/storage/implementations/secure_storage_service.dart';

/// Manages the storage and retrieval of authentication tokens
/// using a secure storage service.
///
/// This class handles access tokens, refresh tokens, and API keys,
/// providing methods to get, save, and clear these tokens as needed.
class TokenManager {
  /// Constructor that initializes the TokenManager
  /// with a secure storage service.
  TokenManager(this._storageService /* , this._localStorage */);

  final SecureStorageService _storageService;
  //final LocalStorageService _localStorage;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userSub = 'user_sub';

  /// Retrieves the access token from secure storage.
  /// Returns the token as a String if it exists, or null if not.
  Future<String?> getAccessToken() {
    return _storageService.read(key: _accessTokenKey);
  }

  /// Retrieves the refresh token from secure storage.
  /// Returns the token as a String if it exists, or null if not.
  Future<String?> getRefreshToken() {
    return _storageService.read(key: _refreshTokenKey);
  }

  Future<String?> getUserSub() {
    return _storageService.read(key: _userSub);
  }

  /// Saves the access token to secure storage.
  ///
  /// If the provided token is empty, it does not perform any action.
  Future<void> saveAccessToken(String token) async {
    if (token.isEmpty) return; // Prevent saving empty tokens
    await _storageService.write<String>(key: _accessTokenKey, value: token);
  }

  /// Saves the refresh token to secure storage.
  ///
  /// If the provided token is empty, it does not perform any action.
  Future<void> saveRefreshToken(String token) async {
    if (token.isEmpty) return; // Prevent saving empty tokens
    await _storageService.write<String>(key: _refreshTokenKey, value: token);
  }

  Future<void> saveUserSub(String value) async {
    if (value.isEmpty) return; // Prevent saving empty tokens
    await _storageService.write<String>(key: _userSub, value: value);
  }

  /// Clears all stored tokens from secure storage.
  Future<void> clearTokens() async {
    await _storageService.delete(key: _accessTokenKey);
    await _storageService.delete(key: _refreshTokenKey);
    await _storageService.delete(key: _userSub);
  }
}
