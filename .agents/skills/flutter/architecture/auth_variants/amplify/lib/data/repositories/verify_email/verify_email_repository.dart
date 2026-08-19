import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_failures.dart';

class VerifyEmailRepository {
  VerifyEmailRepository();

  /// Reenvía el código de confirmación de registro al email del usuario.
  Future<Result<void, VerifyEmailFailure>> sendVerificationCode({
    required String email,
  }) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      return const Success(null);
    } on LimitExceededException {
      return const Failure(VerifyEmailFailure.serverError);
    } on AuthException catch (e, stack) {
      AppLogger.e(
        'VerifyEmailRepository.sendVerificationCode',
        error: e,
        stackTrace: stack,
      );
      return const Failure(VerifyEmailFailure.unknownError);
    }
  }

  /// Confirma el registro con el código recibido por email.
  Future<Result<void, VerifyEmailFailure>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );
      return const Success(null);
    } on CodeMismatchException {
      return const Failure(VerifyEmailFailure.invalidCode);
    } on ExpiredCodeException {
      return const Failure(VerifyEmailFailure.invalidCode);
    } on AuthException catch (e, stack) {
      AppLogger.e(
        'VerifyEmailRepository.verifyEmail',
        error: e,
        stackTrace: stack,
      );
      return const Failure(VerifyEmailFailure.unknownError);
    }
  }
}
