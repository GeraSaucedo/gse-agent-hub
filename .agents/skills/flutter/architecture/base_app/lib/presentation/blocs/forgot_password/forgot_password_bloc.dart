import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/inputs/field_confirm_password.dart';
import 'package:gse_base_app/data/inputs/field_password.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_failures.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_repository.dart';
import 'package:gse_base_app/presentation/widgets/inputs/email/field_email.dart';

part 'forgot_password_bloc.freezed.dart';
part 'forgot_password_events.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
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
    emit(
      state.copyWith(failure: null),
    );

    final email = state.email.value;

    if (email.isEmpty) {
      emit(
        state.copyWith(
          failure: RecoveryCodeFailure.emptyUsername,
        ),
      );
      return;
    }

    final result = await _repository.requestRecoveryCode(email: email);

    if (result case Failure(:final exception)) {
      emit(state.copyWith(failure: exception));
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
    emit(state.copyWith(newPassword: password));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final confirmedPassword = ConfirmedPasswordInput.dirty(
      password: state.newPassword.value,
      value: event.password.trim(),
    );
    emit(state.copyWith(confirmedNewPassword: confirmedPassword));
  }

  void _onCodeChanged(CodeChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(code: event.code));
  }

  void _onCleanState(CleanState event, Emitter<ForgotPasswordState> emit) {
    emit(const ForgotPasswordState());
  }

  bool _isFormDataValid() {
    final result = Formz.validate([
      state.newPassword,
      state.confirmedNewPassword,
    ]);

    return result;
  }
}
