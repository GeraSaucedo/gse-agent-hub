import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_code.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_form.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_username.dart';
import 'package:gse_base_app/presentation/screens/login/login_screen.dart';
import 'package:gse_base_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:gse_base_app/presentation/screens/register/register_screen.dart';
import 'package:gse_base_app/presentation/screens/splash/splash_screen.dart';
import 'package:gse_base_app/presentation/screens/verify_email/verify_email_screen.dart';

final Set<String> _publicRoutes = {
  LoginScreen.route,
  SplashScreen.route,
  ForgotPasswordUsername.route,
  ForgotPasswordCode.route,
  ForgotPasswordForm.route,
  VerifyEmailScreen.route,
  RegisterScreen.route,
  OnboardingScreen.route,
};

FutureOr<String?> authRedirect(
  BuildContext context,
  GoRouterState state,
) {
  final authStatus = sl<AuthRepository>().currentStatus;
  final isGoingTo = state.matchedLocation;
  final isGoingToSplash = isGoingTo == SplashScreen.route;

  return switch (authStatus) {
    AuthStatus.unknown => null,
    // If going to a public route that is not splash, stay.
    // Otherwise, go to login.
    AuthStatus.unauthenticated || AuthStatus.sessionExpired =>
      (_publicRoutes.contains(isGoingTo) && !isGoingToSplash)
          ? null
          : LoginScreen.route,
    AuthStatus.authenticated => _publicRoutes.contains(isGoingTo) ? '/' : null,
  };
}
