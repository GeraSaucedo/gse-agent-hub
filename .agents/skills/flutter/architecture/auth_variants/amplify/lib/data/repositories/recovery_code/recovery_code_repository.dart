import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_failures.dart';

class RecoveryCodeRepository {
  RecoveryCodeRepository();

  /// Inicia el flujo de recuperación: Cognito envía un código al email.
  Future<Result<void, RecoveryCodeFailure>> requestRecoveryCode({
    required String email,
  }) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
      return const Success(null);
    } on UserNotFoundException {
      return const Failure(RecoveryCodeFailure.userNotFound);
    } on LimitExceededException {
      return const Failure(RecoveryCodeFailure.serverError);
    } on AuthException catch (e, stack) {
      AppLogger.e('RecoveryCodeRepository error', error: e, stackTrace: stack);
      return const Failure(RecoveryCodeFailure.unknownError);
    }
  }

  /// Confirma la nueva contraseña con el código recibido por email.
  Future<Result<void, RecoveryCodeFailure>> updatePassword({
    required String email,
    required String newPassword,
    required String code,
  }) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: code,
      );
      return const Success(null);
    } on CodeMismatchException {
      // Código incorrecto/expirado → se reutiliza invalidForm (dato inválido).
      return const Failure(RecoveryCodeFailure.invalidForm);
    } on ExpiredCodeException {
      return const Failure(RecoveryCodeFailure.invalidForm);
    } on InvalidPasswordException {
      return const Failure(RecoveryCodeFailure.invalidForm);
    } on UserNotFoundException {
      return const Failure(RecoveryCodeFailure.userNotFound);
    } on AuthException catch (e, stack) {
      AppLogger.e('RecoveryCodeRepository error', error: e, stackTrace: stack);
      return const Failure(RecoveryCodeFailure.unknownError);
    }
  }
}
