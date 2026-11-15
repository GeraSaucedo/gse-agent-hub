import 'package:get_it/get_it.dart';

/// Global service locator. Each layer registers its dependencies in its
/// own injector (`services_injector`, `repositories_injector`,
/// `blocs_injector`), wired together by `main_injector.dart`.
///
/// It lives in `core` so `core` never has to import `main_injector.dart`.
final GetIt sl = GetIt.instance;
