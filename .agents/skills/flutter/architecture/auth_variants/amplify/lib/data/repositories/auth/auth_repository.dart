import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/auth/auth_failures.dart';

const String _repositoryName = 'AuthRepository';

enum AuthStatus { authenticated, unauthenticated, unknown }

/// Auth backed by Amazon Cognito via AWS Amplify.
///
/// Keeps the public shape the app relies on ([AuthStatus] + [authStatusStream]
/// + [currentStatus]) so the router redirect is unchanged. Session persistence
/// and token refresh are owned by Amplify; this repo never stores tokens.
class AuthRepository {
  AuthRepository() {
    _listenToHubEvents();
  }

  final _authStatusController = StreamController<AuthStatus>.broadcast();

  AuthStatus _currentStatus = AuthStatus.unknown;

  StreamSubscription<AuthHubEvent>? _hubSubscription;

  /// Último estado de autenticación conocido. Usado por el router para
  /// evaluar redirects sin leer el BLoC.
  AuthStatus get currentStatus => _currentStatus;

  /// Stream del estado de autenticación. El router escucha este stream para
  /// re-evaluar redirects solo cuando cambia el estado.
  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;

  void _emitStatus(AuthStatus status) {
    _currentStatus = status;
    _authStatusController.add(status);
  }

  /// Escucha los eventos de Amplify (login/logout/sesión expirada) para
  /// mantener el estado sincronizado aunque cambie fuera de este repo.
  void _listenToHubEvents() {
    _hubSubscription = Amplify.Hub.listen(HubChannel.Auth, (event) {
      switch (event.type) {
        case AuthHubEventType.signedIn:
          _emitStatus(AuthStatus.authenticated);
        case AuthHubEventType.signedOut:
        case AuthHubEventType.sessionExpired:
        case AuthHubEventType.userDeleted:
          _emitStatus(AuthStatus.unauthenticated);
      }
    });
  }

  /// Forzar el estado no autenticado (p. ej. desde un 401 no recuperable).
  void forceLogout() => _emitStatus(AuthStatus.unauthenticated);

  void dispose() {
    unawaited(_hubSubscription?.cancel());
    unawaited(_authStatusController.close());
  }

  Future<Result<void, AuthFailure>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        _emitStatus(AuthStatus.authenticated);
        return const Success(null);
      }

      // No quedó firmado → hace falta un paso extra (típicamente confirmar
      // el registro). Se reporta para que la UI enrute a verificación.
      if (result.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
        return const Failure(AuthFailure.userNotConfirmed);
      }
      return const Failure(AuthFailure.unknown);
    } on AuthException catch (e, stack) {
      AppLogger.e(_repositoryName, error: e, stackTrace: stack);
      return Failure(_mapAuthException(e));
    }
  }

  Future<Result<void, AuthFailure>> loginWithGoogle() =>
      _signInWithProvider(AuthProvider.google);

  Future<Result<void, AuthFailure>> loginWithApple() =>
      _signInWithProvider(AuthProvider.apple);

  Future<Result<void, AuthFailure>> _signInWithProvider(
    AuthProvider provider,
  ) async {
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      if (result.isSignedIn) {
        _emitStatus(AuthStatus.authenticated);
        return const Success(null);
      }
      return const Failure(AuthFailure.unknown);
    } on UserCancelledException {
      return const Failure(AuthFailure.cancelled);
    } on AuthException catch (e, stack) {
      AppLogger.e(_repositoryName, error: e, stackTrace: stack);
      return Failure(_mapAuthException(e));
    }
  }

  /// Verifica si hay una sesión activa y emite el resultado al stream.
  Future<void> isUserLogged() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      _emitStatus(
        session.isSignedIn
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      );
    } on AuthException catch (e, stack) {
      AppLogger.e(
        '$_repositoryName.isUserLogged',
        error: e,
        stackTrace: stack,
      );
      _emitStatus(AuthStatus.unauthenticated);
    }
  }

  /// Cierra la sesión de Amplify (revoca tokens y limpia el store local).
  Future<Result<void, AuthFailure>> logout() async {
    try {
      await Amplify.Auth.signOut();
      _emitStatus(AuthStatus.unauthenticated);
      return const Success(null);
    } on AuthException catch (e, stack) {
      AppLogger.e('$_repositoryName.logout', error: e, stackTrace: stack);
      return const Failure(AuthFailure.unknown);
    }
  }

  AuthFailure _mapAuthException(AuthException e) {
    return switch (e) {
      UserNotConfirmedException() => AuthFailure.userNotConfirmed,
      UserNotFoundException() => AuthFailure.unauthorized,
      NotAuthorizedServiceException() => AuthFailure.unauthorized,
      AuthNotAuthorizedException() => AuthFailure.unauthorized,
      InvalidPasswordException() => AuthFailure.client,
      InvalidParameterException() => AuthFailure.client,
      LimitExceededException() => AuthFailure.server,
      TooManyRequestsException() => AuthFailure.server,
      UserCancelledException() => AuthFailure.cancelled,
      SessionExpiredException() => AuthFailure.unauthorized,
      _ => AuthFailure.unknown,
    };
  }
}
