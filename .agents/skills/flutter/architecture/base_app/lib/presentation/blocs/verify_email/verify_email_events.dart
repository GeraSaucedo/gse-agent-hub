part of 'verify_email_bloc.dart';

@freezed
abstract class VerifyEmailEvent with _$VerifyEmailEvent {
  const factory VerifyEmailEvent.initRequested(String email) = InitRequested;
  const factory VerifyEmailEvent.emailSet(String email) = EmailSet;
  const factory VerifyEmailEvent.codeChanged(String code) = CodeChanged;
  const factory VerifyEmailEvent.resendRequested() = ResendRequested;
  const factory VerifyEmailEvent.formSubmitted() = FormSubmitted;
  const factory VerifyEmailEvent.cleanState() = CleanState;
}
