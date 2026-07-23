import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_base_app/core/routes/app_auth_redirect.dart';
import 'package:gse_base_app/core/routes/auth_stream.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_repository.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:gse_base_app/presentation/blocs/login/login_bloc.dart';
import 'package:gse_base_app/presentation/blocs/register/register_bloc.dart';
import 'package:gse_base_app/presentation/blocs/verify_email/verify_email_bloc.dart';
import 'package:gse_base_app/presentation/screens/design_system_demo/design_system_demo_screen.dart';
import 'package:gse_base_app/presentation/screens/example_pagination/example_pagination_screen.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_bloc_listener.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_code.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_form.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_username.dart';
import 'package:gse_base_app/presentation/screens/home/home_screen.dart';
import 'package:gse_base_app/presentation/screens/language/language_screen.dart';
import 'package:gse_base_app/presentation/screens/login/login_screen.dart';
import 'package:gse_base_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:gse_base_app/presentation/screens/register/register_screen.dart';
import 'package:gse_base_app/presentation/screens/splash/splash_screen.dart';
import 'package:gse_base_app/presentation/screens/verify_email/verify_email_bloc_listener.dart';
import 'package:gse_base_app/presentation/screens/verify_email/verify_email_screen.dart';

final appRouter = GoRouter(
  initialLocation: SplashScreen.route,
  refreshListenable: GoRouterRefreshStream(
    sl<AuthRepository>().authStatusStream,
  ),
  redirect: authRedirect,
  routes: [
    GoRoute(
      path: '/',
      name: 'home-screen',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'pagination-example',
          name: 'pagination-example-screen',
          builder: (context, state) => const ExamplePaginationScreen(),
        ),
        GoRoute(
          path: 'design-system-demo',
          name: DesignSystemDemoScreen.name,
          builder: (context, state) => const DesignSystemDemoScreen(),
        ),
        GoRoute(
          path: 'language',
          name: LanguageScreen.name,
          builder: (context, state) => const LanguageScreen(),
        ),
      ],
    ),
    GoRoute(
      path: LoginScreen.route,
      name: LoginScreen.name,
      builder: (context, state) => BlocProvider<LoginBloc>(
        create: (_) => sl<LoginBloc>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: SplashScreen.route,
      name: SplashScreen.name,
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => BlocProvider<ForgotPasswordBloc>(
        create: (_) => sl<ForgotPasswordBloc>(),
        child: ForgotPasswordBlocListener(child: child),
      ),
      routes: [
        GoRoute(
          path: ForgotPasswordUsername.route,
          name: ForgotPasswordUsername.name,
          builder: (context, state) => ForgotPasswordUsername(
            email: state.uri.queryParameters['email'],
          ),
        ),
        GoRoute(
          path: ForgotPasswordCode.route,
          name: ForgotPasswordCode.name,
          builder: (context, state) => const ForgotPasswordCode(),
        ),
        GoRoute(
          path: ForgotPasswordForm.route,
          name: ForgotPasswordForm.name,
          builder: (context, state) => const ForgotPasswordForm(),
        ),
      ],
    ),
    GoRoute(
      path: VerifyEmailScreen.route,
      name: VerifyEmailScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final password = extra?['password'] as String?;
        return BlocProvider<VerifyEmailBloc>(
          create: (_) => VerifyEmailBloc(
            repository: sl<VerifyEmailRepository>(),
            authRepository: sl<AuthRepository>(),
            autoLoginPassword: password,
          ),
          child: VerifyEmailBlocListener(
            child: VerifyEmailScreen(
              email: state.uri.queryParameters['email'] ?? '',
              skipSend: state.uri.queryParameters['skipSend'] == 'true',
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: RegisterScreen.route,
      name: RegisterScreen.name,
      builder: (context, state) => BlocProvider<RegisterBloc>(
        create: (_) => sl<RegisterBloc>(),
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: OnboardingScreen.route,
      name: OnboardingScreen.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
