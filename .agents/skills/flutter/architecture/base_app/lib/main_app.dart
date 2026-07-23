import 'package:flutter/material.dart';
import 'package:gse_base_app/core/routes/app_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class MainApp extends StatefulWidget {
  const MainApp({required this.dsController, super.key});

  /// Controlador pre-cargado desde [main] para evitar flash de tema.
  final DSController dsController;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleSwitcherProvider(
      child: DSProvider(
        controller: widget.dsController,
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
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: localeCtrl.locale,
            );
          },
        ),
      ),
    );
  }
}
