import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';
import 'package:gse_base_app/core/services/storage/implementations/secure_storage_service.dart';

/// Stores the session values (access token, refresh token and user sub)
/// in secure storage.
class TokenManager {
  new(this._storageService);

  final SecureStorageService _storageService;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userSubKey = 'user_sub';

  /// Flag in local storage that marks this install as already started.
  static const String _installedKey = 'app_installed';

  /// Returns the access token, or `null` if there is none.
  Future<String?> getAccessToken() => _storageService.read(_accessTokenKey);

  /// Returns the refresh token, or `null` if there is none.
  Future<String?> getRefreshToken() => _storageService.read(_refreshTokenKey);

  /// Returns the user sub, or `null` if there is none.
  Future<String?> getUserSub() => _storageService.read(_userSubKey);

  /// Saves the access token. Empty values are ignored.
  Future<void> saveAccessToken(String token) async {
    if (token.isEmpty) return;
    await _storageService.write(_accessTokenKey, token);
  }

  /// Saves the refresh token. Empty values are ignored.
  Future<void> saveRefreshToken(String token) async {
    if (token.isEmpty) return;
    await _storageService.write(_refreshTokenKey, token);
  }

  /// Saves the user sub. Empty values are ignored.
  Future<void> saveUserSub(String value) async {
    if (value.isEmpty) return;
    await _storageService.write(_userSubKey, value);
  }

  /// Removes every session value.
  Future<void> clearTokens() async {
    await _storageService.delete(_accessTokenKey);
    await _storageService.delete(_refreshTokenKey);
    await _storageService.delete(_userSubKey);
  }

  /// Removes the session left by a previous install. Call it once at startup.
  ///
  /// On iOS the Keychain (secure storage) keeps its values after the app is
  /// uninstalled, while [localStorage] is wiped. Without this, a reinstalled
  /// app would start logged in with an old session.
  ///
  /// Note: the first start after adding this to an existing app also counts
  /// as a fresh install, so current users log in once more.
  Future<void> clearTokensIfFreshInstall(
    LocalStorageService localStorage,
  ) async {
    final isFreshInstall = await localStorage.getBool(_installedKey) != true;
    if (!isFreshInstall) return;

    await clearTokens();
    await localStorage.setBool(_installedKey, value: true);
  }
}
