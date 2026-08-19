import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/register/register_failures.dart';

class RegisterRepository {
  RegisterRepository();

  Future<Result<void, RegisterFailure>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
            AuthUserAttributeKey.name: name,
          },
        ),
      );

      return const Success(null);
    } on UsernameExistsException {
      return const Failure(RegisterFailure.emailAlreadyExists);
    } on InvalidPasswordException {
      return const Failure(RegisterFailure.invalidData);
    } on InvalidParameterException {
      return const Failure(RegisterFailure.invalidData);
    } on AuthException catch (e, stack) {
      AppLogger.e('RegisterRepository.register', error: e, stackTrace: stack);
      return const Failure(RegisterFailure.unknownError);
    }
  }
}
