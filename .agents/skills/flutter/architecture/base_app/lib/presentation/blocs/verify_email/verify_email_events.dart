part of 'verify_email_bloc.dart';

@freezed
abstract class VerifyEmailEvent with _$VerifyEmailEvent {
  const factory initRequested(String email) = InitRequested;
  const factory emailSet(String email) = EmailSet;
  const factory codeChanged(String code) = CodeChanged;
  const factory resendRequested() = ResendRequested;
  const factory formSubmitted() = FormSubmitted;
  const factory cleanState() = CleanState;
}
