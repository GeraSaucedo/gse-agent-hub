import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/auth/auth_repository.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_failures.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_repository.dart';

part 'verify_email_bloc.freezed.dart';
part 'verify_email_events.dart';
part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc({
    required this._repository,
    required this._authRepository,
    this.autoLoginPassword,
  }) : super(const VerifyEmailState()) {
    on<InitRequested>(_onInitRequested, transformer: droppable());
    on<EmailSet>(_onEmailSet);
    on<CodeChanged>(_onCodeChanged);
    on<ResendRequested>(_onResendRequested, transformer: droppable());
    on<FormSubmitted>(_onFormSubmitted, transformer: droppable());
    on<CleanState>(_onCleanState);
  }

  final VerifyEmailRepository _repository;
  final AuthRepository _authRepository;
  final String? autoLoginPassword;

  bool _autoLoginSucceeded = false;
  bool get autoLoginSucceeded => _autoLoginSucceeded;

  void _onEmailSet(EmailSet event, Emitter<VerifyEmailState> emit) {
    emit(state.copyWith(email: event.email, failure: null));
  }

  Future<void> _onInitRequested(
    InitRequested event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(state.copyWith(email: event.email, failure: null));

    final result = await _repository.sendVerificationCode(
      email: event.email,
    );

    if (result case Failure(:final exception)) {
      emit(state.copyWith(failure: exception));
    }
  }

  Future<void> _onResendRequested(
    ResendRequested event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(state.copyWith(failure: null));

    final result = await _repository.sendVerificationCode(
      email: state.email,
    );

    if (result case Failure(:final exception)) {
      emit(state.copyWith(failure: exception));
    }
  }

  void _onCodeChanged(
    CodeChanged event,
    Emitter<VerifyEmailState> emit,
  ) {
    emit(state.copyWith(code: event.code));
  }

  Future<void> _onFormSubmitted(
    FormSubmitted event,
    Emitter<VerifyEmailState> emit,
  ) async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      failure: null,
    ));

    final result = await _repository.verifyEmail(
      email: state.email,
      code: state.code,
    );

    switch (result) {
      case Success():
        if (autoLoginPassword != null) {
          final loginResult = await _authRepository.loginWithEmailAndPassword(
            email: state.email,
            password: autoLoginPassword!,
          );
          if (loginResult case Success()) {
            _autoLoginSucceeded = true;
          }
        }
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      case Failure(:final exception):
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          failure: exception,
        ));
    }
  }

  void _onCleanState(
    CleanState event,
    Emitter<VerifyEmailState> emit,
  ) {
    emit(const VerifyEmailState());
  }
}
