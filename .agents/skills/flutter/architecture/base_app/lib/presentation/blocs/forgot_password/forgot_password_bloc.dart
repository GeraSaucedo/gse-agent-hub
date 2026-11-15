import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/inputs/field_confirm_password.dart';
import 'package:gse_base_app/data/inputs/field_email.dart';
import 'package:gse_base_app/data/inputs/field_password.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_failures.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_repository.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_bloc.freezed.dart';
part 'forgot_password_events.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  new({
    required this._repository,
  }) : super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<CodeChanged>(_onCodeChanged);
    on<FormSubmitted>(_onFormSubmitted, transformer: droppable());
    on<CodeRequested>(_onCodeRequested, transformer: droppable());
    on<CleanState>(_onCleanState);
  }

  final RecoveryCodeRepository _repository;

  Future<void> _onCodeRequested(
    CodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final email = state.email.value;

    if (email.isEmpty) {
      emit(state.copyWith(failure: RecoveryCodeFailure.emptyUsername));
      return;
    }

    emit(state.copyWith(requestingCode: true, failure: null));

    final result = await _repository.requestRecoveryCode(email: email);

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            requestingCode: false,
            codesSent: state.codesSent + 1,
          ),
        );
      case Failure(:final exception):
        emit(state.copyWith(requestingCode: false, failure: exception));
    }
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        failure: null,
      ),
    );

    if (!_isFormDataValid()) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: RecoveryCodeFailure.invalidForm,
        ),
      );
      return;
    }

    final result = await _repository.updatePassword(
      email: state.email.value,
      newPassword: state.newPassword.value,
      code: state.code,
    );

    switch (result) {
      case Success():
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      case Failure(:final exception):
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            failure: exception,
          ),
        );
    }
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final email = EmailInput.dirty(event.email.trim());
    emit(
      state.copyWith(email: email),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    final confirmed = state.confirmedNewPassword;
    emit(
      state.copyWith(
        newPassword: password,
        // Re-validate the confirmation against the new password, so a
        // "mismatch" error (or its absence) never refers to an old value.
        confirmedNewPassword: confirmed.isPure
            ? confirmed
            : ConfirmedPasswordInput.dirty(
                password: password.value,
                value: confirmed.value,
              ),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    // Not trimmed: the password isn't either, so trimming here made
    // "abc " vs "abc " a mismatch.
    final confirmedPassword = ConfirmedPasswordInput.dirty(
      password: state.newPassword.value,
      value: event.password,
    );
    emit(state.copyWith(confirmedNewPassword: confirmedPassword));
  }

  void _onCodeChanged(CodeChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(code: event.code));
  }

  void _onCleanState(CleanState event, Emitter<ForgotPasswordState> emit) {
    emit(const ForgotPasswordState());
  }

  /// The whole flow, not just the last step: email (step 1) and code
  /// (step 2) are sent with the new password.
  bool _isFormDataValid() =>
      Formz.validate([
        state.email,
        state.newPassword,
        state.confirmedNewPassword,
      ]) &&
      state.code.trim().isNotEmpty;
}
