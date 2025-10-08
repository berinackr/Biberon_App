import 'package:biberon/common/models/models.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/data/models/signup_post_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthenticationRepository authenticationRepository,
    required Talker logger,
  })  : _authenticationRepository = authenticationRepository,
        _logger = logger,
        super(const SignUpState()) {
    on<SignUpEmailChanged>(_onSignUpEmailChanged);
    on<SignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<SignUpPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignUpNameChanged>(_onSignUpNameChanged);
    on<SignUpUserAgreementChanged>(_onSignUpUserAgreementChanged);
    on<SignUpGooglePressed>(_onSignUpGooglePressed);
  }

  final AuthenticationRepository _authenticationRepository;
  final Talker _logger;

  void _onSignUpEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email.trim());
    emit(state.copyWith(email: email));
  }

  void _onSignUpNameChanged(
    SignUpNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    final name = Name.dirty(event.name.trim());
    emit(state.copyWith(name: name));
  }

  void _onSignUpPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password.trim());
    emit(state.copyWith(password: password));
  }

  void _onSignUpUserAgreementChanged(
    SignUpUserAgreementChanged event,
    Emitter<SignUpState> emit,
  ) {
    final userAgreement = UserAgreement.dirty(value: event.userAgreement);
    emit(state.copyWith(userAgreement: userAgreement));
  }

  void _onPasswordVisibilityChanged(
    SignUpPasswordVisibilityChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(passwordVisibility: event.passwordVisibility));
  }

  Future<void> _onSignUpGooglePressed(
    SignUpGooglePressed event,
    Emitter<SignUpState> emit,
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

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    _logger.info('Sign up requested');
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final result = await _authenticationRepository.signUp(
        SignupPostModel(
          email: state.email.value,
          password: state.password.value,
          username: state.name.value,
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
        (_) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        },
      );
    } else {
      if (state.email.displayError == null && state.email.value.isEmpty) {
        emit(
          state.copyWith(
            email: const Email.dirty(),
          ),
        );
      }
      if (state.password.displayError == null && state.password.value.isEmpty) {
        emit(
          state.copyWith(
            password: const Password.dirty(),
          ),
        );
      }
      if (state.name.displayError == null && state.name.value.isEmpty) {
        emit(
          state.copyWith(
            name: const Name.dirty(),
          ),
        );
      }
      if (state.userAgreement.displayError == null &&
          state.userAgreement.value == false) {
        emit(
          state.copyWith(
            userAgreement: const UserAgreement.dirty(),
          ),
        );
      }
    }
  }
}
