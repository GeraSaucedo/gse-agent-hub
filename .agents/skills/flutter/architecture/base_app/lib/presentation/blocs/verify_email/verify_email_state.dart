part of 'verify_email_bloc.dart';

@freezed
abstract class VerifyEmailState with _$VerifyEmailState {
  const factory({
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default('') String email,
    @Default('') String code,
    VerifyEmailFailure? failure,
  }) = _VerifyEmailState;
}
