import 'package:biberon/common/models/models.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/data/models/login_post_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required AuthenticationRepository authenticationRepository,
    required Talker logger,
  })  : _authenticationRepository = authenticationRepository,
        _logger = logger,
        super(const SignInState()) {
    on<SignInEmailChanged>(_onSignInEmailChanged);
    on<SignInPasswordChanged>(_onSignInPasswordChanged);
    on<SignInPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<SignInRequested>(_onSignInRequested);
    on<SignInWithGoogleRequested>(_onGoogleSignInRequested);
  }

  final AuthenticationRepository _authenticationRepository;
  final Talker _logger;

  void _onSignInEmailChanged(
    SignInEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    final email = Email.dirty(event.email.trim());
    emit(state.copyWith(email: email));
  }

  void _onSignInPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    final password = Password.dirty(event.password.trim());
    emit(state.copyWith(password: password));
  }

  void _onPasswordVisibilityChanged(
    SignInPasswordVisibilityChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(passwordVisibility: event.passwordVisibility));
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<SignInState> emit,
  ) async {
    _logger.info('Sign in requested');
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final result = await _authenticationRepository.signIn(
        LoginPostModel(
          email: state.email.value,
          password: state.password.value,
        ),
      );
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
        },
        (_) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
      );
    } else {
      // activate auto validation for user to see the errors
      if (state.email.displayError == null && state.email.value.isEmpty) {
        _logger.info('Email is empty, setting it to dirty.');
        emit(
          state.copyWith(
            email: const Email.dirty(),
          ),
        );
      }
      if (state.password.value.isEmpty && state.password.displayError == null) {
        _logger.info('Password is empty, setting it to dirty.');
        emit(
          state.copyWith(
            password: const Password.dirty(),
          ),
        );
      }
    }

    _logger.info(state.status);
  }

  Future<void> _onGoogleSignInRequested(
    SignInWithGoogleRequested event,
    Emitter<SignInState> emit,
  ) async {
    _logger.info('Google sign in requested');
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _authenticationRepository.signInWithGoogle();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (_) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
    );
    _logger.info(state.status);
  }
}
