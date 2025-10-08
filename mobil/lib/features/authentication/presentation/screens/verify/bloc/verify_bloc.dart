import 'package:biberon/common/models/form_inputs/verify_code.dart';
import 'package:biberon/features/authentication/data/models/verify_post_model.dart';
import 'package:biberon/features/authentication/data/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  VerifyBloc({
    required AuthenticationRepository authenticationRepository,
    required Talker logger,
  })  : _authenticationRepository = authenticationRepository,
        _logger = logger,
        super(const VerifyState()) {
    on<SendVerifyEmail>(_onSendVerifyEmail);
    on<VerifyRequested>(_onVerifyRequested);
    on<CodeChanged>(_onCodeChanged);
    on<SignOutRequested>(_onSignOutRequested);
  }

  final AuthenticationRepository _authenticationRepository;
  final Talker _logger;

  void _onCodeChanged(
    CodeChanged event,
    Emitter<VerifyState> emit,
  ) {
    final code = Code.dirty(event.code.trim());
    emit(state.copyWith(code: code));
  }

  Future<void> _onSendVerifyEmail(
    SendVerifyEmail event,
    Emitter<VerifyState> emit,
  ) async {
    emit(
      state.copyWith(
        sendEmailStatus: FormzSubmissionStatus.inProgress,
        status: FormzSubmissionStatus.initial,
        logoutStatus: FormzSubmissionStatus.initial,
      ),
    );
    _logger.info('New verification email requested');

    final result = await _authenticationRepository.sendVerificationEmail();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            sendEmailStatus: FormzSubmissionStatus.failure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            sendEmailStatus: FormzSubmissionStatus.success,
            statusMessage: data.message,
          ),
        );
      },
    );
  }

  Future<void> _onVerifyRequested(
    VerifyRequested event,
    Emitter<VerifyState> emit,
  ) async {
    _logger.info('Verify email code check requested');
    if (state.isValid) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
          sendEmailStatus: FormzSubmissionStatus.initial,
          logoutStatus: FormzSubmissionStatus.initial,
        ),
      );
      final result = await _authenticationRepository.verifyEmail(
        VerifyPostModel(
          code: state.code.value,
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
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              statusMessage: 'Doğrulama başarılı',
            ),
          );
        },
      );
    } else {
      if (state.code.displayError == null && state.code.value.isEmpty) {
        emit(
          state.copyWith(
            code: const Code.dirty(),
          ),
        );
      }
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<VerifyState> emit,
  ) async {
    emit(
      state.copyWith(
        logoutStatus: FormzSubmissionStatus.inProgress,
        status: FormzSubmissionStatus.initial,
        sendEmailStatus: FormzSubmissionStatus.initial,
      ),
    );
    _logger.info('Sign out requested');

    final result = await _authenticationRepository.signOut();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            logoutStatus: FormzSubmissionStatus.failure,
            errorMessage: failure.toString(),
          ),
        );
      },
      (_) => emit(
        state.copyWith(
          logoutStatus: FormzSubmissionStatus.success,
        ),
      ),
    );
  }
}
