import 'package:biberon/common/models/form_inputs/email.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/authentication/data/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc({
    required AuthenticationRepository authenticationRepository,
    required Talker logger,
  })  : _authenticationRepository = authenticationRepository,
        _logger = logger,
        super(const ForgetPasswordState()) {
    on<ForgetPasswordEmailChanged>(_onForgetPasswordEmailChanged);
    on<SendForgetPasswordEmail>(_onSendForgetPasswordEmail);
  }

  final AuthenticationRepository _authenticationRepository;
  final Talker _logger;

  void _onForgetPasswordEmailChanged(
    ForgetPasswordEmailChanged event,
    Emitter<ForgetPasswordState> emit,
  ) {
    final email = Email.dirty(event.email.trim());
    emit(state.copyWith(email: email));
  }

  Future<void> _onSendForgetPasswordEmail(
    SendForgetPasswordEmail event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    _logger.info('Send forget password email requested');
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final result = await _authenticationRepository.sendForgotPasswordEmail(
        ForgotPasswordPostModel(email: state.email.value),
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
        (data) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              statusMessage: data.message,
            ),
          );
        },
      );
    } else {
      _logger.info('Corrupt email syntax. Request did not send.');
      if (state.email.displayError == null && state.email.value.isEmpty) {
        emit(
          state.copyWith(
            email: const Email.dirty(),
          ),
        );
      }
    }
  }
}
