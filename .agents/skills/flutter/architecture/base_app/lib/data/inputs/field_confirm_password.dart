import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { empty, mismatch }

/// Confirmation field: must match the password. Only validates; the UI turns
/// [displayError] into text via l10n.
class ConfirmedPasswordInput
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const new pure() : _password = '', super.pure('');

  const new dirty({
    required this._password,
    required String value,
  }) : super.dirty(value);

  final String _password;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.trim().isEmpty) return ConfirmedPasswordValidationError.empty;
    if (value != _password) return ConfirmedPasswordValidationError.mismatch;
    return null;
  }
}
