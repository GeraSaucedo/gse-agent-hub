import 'dart:async';

import 'package:gse_base_app/core/di/service_locator.dart';
import 'package:gse_base_app/core/services/services_injector.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/data/repositories/repositories_injector.dart';
import 'package:gse_base_app/presentation/blocs/blocs_injector.dart';

// Re-exported so existing `import 'main_injector.dart'` keep finding `sl`.
export 'package:gse_base_app/core/di/service_locator.dart';

Future<void> init() async {
  await servicesInjector(
    onSessionExpired: () => unawaited(sl<AuthRepository>().forceLogout()),
  );
  repositoriesInjector();
  blocInjector();
}
