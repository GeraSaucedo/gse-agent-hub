import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum EmailValidationError { empty, format }

/// Email field. Only validates: the UI turns [displayError] into text via l10n.
class EmailInput extends FormzInput<String, EmailValidationError> {
  const new pure() : super.pure('');
  const new dirty(super.value) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    final cleanedValue = value.trim();
    if (cleanedValue.isEmpty) return EmailValidationError.empty;
    // RFC 5322 check.
    if (!EmailValidator.validate(cleanedValue)) {
      return EmailValidationError.format;
    }
    return null;
  }
}
