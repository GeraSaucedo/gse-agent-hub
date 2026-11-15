import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/inputs/field_email.dart';
import 'package:gse_base_app/data/inputs/field_password.dart';
import 'package:gse_base_app/data/repositories/auth/auth_failures.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_bloc.freezed.dart';
part 'login_events.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  new({
    required this._repository,
  }) : super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<FormSubmitted>(_onFormSubmitted, transformer: droppable());
    on<CleanState>(_onCleanState);
  }

  final AuthRepository _repository;

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Reset `unverifiedEmail` too: if the account is still unverified, it is
    // set again and the listener reopens VerifyEmail on every attempt.
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        failure: null,
        unverifiedEmail: '',
      ),
    );

    if (!_isFormDataValid()) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: AuthFailure.invalidForm,
        ),
      );
      return;
    }

    final result = await _repository.loginWithEmailAndPassword(
      email: state.email.value,
      password: state.password.value,
    );

    switch (result) {
      case Success():
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      case Failure(:final exception):
        if (exception == AuthFailure.forbidden) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              unverifiedEmail: state.email.value,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            failure: exception,
          ),
        );
    }
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final email = EmailInput.dirty(event.email.trim());
    emit(state.copyWith(email: email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password = PasswordInput.dirty(
      event.password,
      onlyEmptyValidation: true,
    );
    emit(state.copyWith(password: password));
  }

  bool _isFormDataValid() {
    final fields = <FormzInput<dynamic, dynamic>>[
      state.password,
      state.email,
    ];

    return Formz.validate(fields) && !fields.any((input) => input.isPure);
  }

  void _onCleanState(CleanState event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
