import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/inputs/field_email.dart';
import 'package:gse_base_app/data/inputs/field_password.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/data/repositories/register/register_failures.dart';
import 'package:gse_base_app/data/repositories/register/register_repository.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_bloc.freezed.dart';
part 'register_events.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  new({
    required this._repository,
    required this._authRepository,
  }) : super(const RegisterState()) {
    on<EmailChanged>(_onEmailChanged);
    on<NameChanged>(_onNameChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<FormSubmitted>(_onFormSubmitted, transformer: droppable());
    on<AutoLoginRequested>(_onAutoLoginRequested, transformer: droppable());
    on<CleanState>(_onCleanState);
  }

  final RegisterRepository _repository;
  final AuthRepository _authRepository;

  /// On success the auth status changes and the router redirects to home.
  /// The state is cleared either way, so the password does not stay in memory.
  Future<void> _onAutoLoginRequested(
    AutoLoginRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await _authRepository.loginWithEmailAndPassword(
      email: state.email.value,
      password: state.password.value,
    );

    switch (result) {
      case Success():
        emit(const RegisterState());
      case Failure():
        emit(
          const RegisterState(
            status: FormzSubmissionStatus.failure,
            failure: RegisterFailure.autoLoginFailed,
          ),
        );
    }
  }

  void _onEmailChanged(
    EmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(email: EmailInput.dirty(event.email.trim())));
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(name: event.name.trim()));
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(password: PasswordInput.dirty(event.password)));
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        failure: null,
      ),
    );

    final isFormValid =
        Formz.validate([state.email, state.password]) && state.name.isNotEmpty;

    if (!isFormValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: RegisterFailure.invalidData,
        ),
      );
      return;
    }

    final result = await _repository.register(
      email: state.email.value,
      name: state.name,
      password: state.password.value,
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

  void _onCleanState(
    CleanState event,
    Emitter<RegisterState> emit,
  ) {
    emit(const RegisterState());
  }
}
