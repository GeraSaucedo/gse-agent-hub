import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';

class OnboardingManager {
  new(this._storage);

  final LocalStorageService _storage;
  static const String _key = 'has_seen_onboarding';

  Future<bool> hasSeenOnboarding() async {
    return await _storage.getBool(_key) ?? false;
  }

  Future<void> completeOnboarding() async {
    await _storage.setBool(_key, value: true);
  }
}
