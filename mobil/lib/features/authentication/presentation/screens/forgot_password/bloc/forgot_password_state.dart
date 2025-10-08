part of 'forgot_password_bloc.dart';

class ForgetPasswordState extends Equatable {
  const ForgetPasswordState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.errorMessage,
    this.statusMessage,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final String? errorMessage;
  final String? statusMessage;

  bool get isValid => email.isValid;

  ForgetPasswordState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    String? errorMessage,
    String? statusMessage,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        errorMessage,
        statusMessage,
      ];
}
