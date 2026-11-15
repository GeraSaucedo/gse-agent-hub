import 'package:gse_base_app/presentation/routes/app_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:material_ui/material_ui.dart';

class MainApp extends StatelessWidget {
  const new({required this.dsController, super.key});

  /// Controlador pre-cargado desde [main] para evitar flash de tema.
  final DSController dsController;

  @override
  Widget build(BuildContext context) {
    return LocaleSwitcherProvider(
      child: DSProvider(
        controller: dsController,
        child: Builder(
          builder: (context) {
            final ds = DSProvider.of(context);
            final localeCtrl = LocaleSwitcherProvider.of(context);
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter,
              theme: ds.lightTheme,
              darkTheme: ds.darkTheme,
              themeMode: ds.themeMode,
              localizationsDelegates: appLocalizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: localeCtrl.locale,
            );
          },
        ),
      ),
    );
  }
}
