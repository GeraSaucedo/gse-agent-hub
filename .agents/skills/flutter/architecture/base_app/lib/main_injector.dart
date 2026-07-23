import 'package:get_it/get_it.dart';
import 'package:gse_base_app/core/services/services_injector.dart';
import 'package:gse_base_app/data/repositories/repositories_injector.dart';
import 'package:gse_base_app/presentation/blocs/blocs_injector.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  await servicesInjector();
  repositoriesInjector();
  blocInjector();
}
