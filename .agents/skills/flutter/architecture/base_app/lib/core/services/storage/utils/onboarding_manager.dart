import 'package:gse_base_app/core/services/storage/implementations/local_storage_service.dart';

class OnboardingManager {
  OnboardingManager(this._storage);

  final LocalStorageService _storage;
  static const String _key = 'has_seen_onboarding';

  Future<bool> hasSeenOnboarding() async {
    return await _storage.read<bool>(key: _key) ?? false;
  }

  Future<void> completeOnboarding() async {
    await _storage.write<bool>(key: _key, value: true);
  }
}
