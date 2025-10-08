part of 'verify_bloc.dart';

class VerifyState extends Equatable {
  const VerifyState({
    this.status = FormzSubmissionStatus.initial,
    this.logoutStatus = FormzSubmissionStatus.initial,
    this.sendEmailStatus = FormzSubmissionStatus.initial,
    this.code = const Code.pure(),
    this.errorMessage,
    this.statusMessage,
  });

  final FormzSubmissionStatus status;
  final FormzSubmissionStatus logoutStatus;
  final FormzSubmissionStatus sendEmailStatus;
  final Code code;
  final String? errorMessage;
  final String? statusMessage;
  bool get isValid => code.isValid;

  VerifyState copyWith({
    Code? code,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? logoutStatus,
    FormzSubmissionStatus? sendEmailStatus,
    String? errorMessage,
    String? statusMessage,
  }) {
    return VerifyState(
      status: status ?? this.status,
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
      statusMessage: statusMessage ?? this.statusMessage,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      sendEmailStatus: sendEmailStatus ?? this.sendEmailStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        code,
        errorMessage,
        statusMessage,
        logoutStatus,
        sendEmailStatus,
      ];
}
