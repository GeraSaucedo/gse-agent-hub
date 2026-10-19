import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:gse_base_app/core/routes/app_router.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/widgets/dialogs/session_expired_dialog.dart';

class MainApp extends StatefulWidget {
  const MainApp({required this.dsController, super.key});

  /// Controlador pre-cargado desde [main] para evitar flash de tema.
  final DSController dsController;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  StreamSubscription<AuthStatus>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = sl<AuthRepository>().authStatusStream.listen((status) {
      if (status != AuthStatus.sessionExpired) return;
      if (!mounted) return;
      final navContext = rootNavigatorKey.currentContext;
      // The context comes from the root navigator key, not a stale widget.
      // ignore: use_build_context_synchronously
      if (navContext != null) unawaited(SessionExpiredDialog.show(navContext));
    });
  }

  @override
  void dispose() {
    unawaited(_authSub?.cancel());
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
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: localeCtrl.locale,
            );
          },
        ),
      ),
    );
  }
}
