import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_base_app/amplifyconfiguration.dart';
import 'package:gse_base_app/core/constants/app_constants.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/main_app.dart';
import 'package:gse_base_app/main_injector.dart' as di;
import 'package:gse_base_app/presentation/blocs/app_blocs_provider.dart';
import 'package:gse_base_app/presentation/blocs/bloc_observer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  await _mainConfig();
  // Carga brand y themeMode antes de runApp → sin flash de tema.
  final dsController = await DSController.preload();
  runApp(
    AppBlocProvider(
      child: MainApp(dsController: dsController),
    ),
  );
}

Future<void> _mainConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureAmplify();

  await di.init();

  // Force vertical orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Cstatus bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //statusBarIconBrightness: Brightness.dark,
      //statusBarBrightness: Brightness.light,
    ),
  );

  await initializeDateFormatting('es_MX');

  Bloc.observer = MyBlocObserver();

  // Get app version
  final packageInfo = await PackageInfo.fromPlatform();
  AppConstants.version = packageInfo.version;
  AppConstants.build = packageInfo.buildNumber;
}

/// Adds the Cognito plugin and configures Amplify once at startup.
/// Safe against hot-restart double-configuration.
Future<void> _configureAmplify() async {
  if (Amplify.isConfigured) return;
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(buildAmplifyConfig());
  } on AmplifyAlreadyConfiguredException {
    // Already configured (e.g. hot restart) — safe to ignore.
    AppLogger.i('Amplify already configured');
  } on Object catch (e, stack) {
    AppLogger.e('Amplify configuration failed', error: e, stackTrace: stack);
  }
}
