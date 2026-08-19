import 'dart:convert';

import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';
import 'package:gse_base_app/domain/models/user.dart';

class UserManager {
  UserManager({required this._storage});

  static const _userKey = 'user_data';
  final LocalStorageService _storage;

  Future<void> saveUser(User user) async {
    final userMap = user.toMap();
    final userJson = jsonEncode(userMap);
    await _storage.write<String>(key: _userKey, value: userJson);
  }

  Future<User?> getUser() async {
    final userJson = await _storage.read<String>(key: _userKey);
    if (userJson == null) return null;

    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return User.fromMap(userMap);
  }

  Future<void> clearUserData() async {
    await _storage.delete(key: _userKey);
  }
}
