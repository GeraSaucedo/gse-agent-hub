import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/services/storage/utils/onboarding_manager.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:gse_base_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_loader.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_logo.dart';
import 'package:gse_design_system/gse_design_system.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const name = 'splash-screen';
  static const route = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    AppLogger.i('Splash._bootstrap: start');

    final hasSeenOnboarding =
        await sl<OnboardingManager>().hasSeenOnboarding();

    if (!hasSeenOnboarding && mounted) {
      context.go(OnboardingScreen.route);
      return;
    }

    if (mounted) {
      AppLogger.i('Splash._bootstrap: checkAuthStatus');
      await context.read<AuthCubit>().checkAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          SizedBox(
            width: context.sp(65),
            child: const AppLogo(),
          ),
          SizedBox(height: context.h(4)),
          const AppLoader(),
        ],
      ),
    );
  }
}
