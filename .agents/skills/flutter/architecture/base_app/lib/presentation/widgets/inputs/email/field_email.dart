// Import required packages
import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

// Define validation errors for email field
enum EmailValidationError { empty, format }

/// Class to handle and validate an email field using Formz
/// Extends FormzInput with String as input type and
/// EmailValidationError as error type
class EmailInput extends FormzInput<String, EmailValidationError> {
  // Constructor for initial/pure state of input (unmodified)
  const EmailInput.pure() : super.pure('');

  // Constructor for modified/dirty state of input
  const EmailInput.dirty(super.value) : super.dirty();

  /// Returns corresponding error message based on validation state
  /// If input is valid, returns null (no error)
  String? get errorMessage {
    if (isValid) return null;

    // If empty or in pure state, show required field error
    if (displayError == EmailValidationError.empty) {
      return 'This field is required';
    }
    // If format is invalid, show format error
    if (displayError == EmailValidationError.format) {
      return 'Invalid email format';
    }

    return null;
  }

  /// Method that performs input value validation
  /// Returns EmailValidationError if there's an error, or null if valid
  @override
  EmailValidationError? validator(String value) {
    // Remove leading and trailing whitespace
    final cleanedValue = value.trim();

    // Check if field is empty
    if (cleanedValue.isEmpty) return EmailValidationError.empty;

    // Use email_validator to validate email format
    // This validation implements RFC 5322 standard
    if (!EmailValidator.validate(cleanedValue)) {
      return EmailValidationError.format;
    }

    // If passes all validations, return null (no error)
    return null;
  }
}
