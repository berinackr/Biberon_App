part of 'verify_bloc.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent();

  @override
  List<Object> get props => [];
}

class VerifyRequested extends VerifyEvent {
  const VerifyRequested();

  @override
  List<Object> get props => [];
}

class SendVerifyEmail extends VerifyEvent {
  const SendVerifyEmail();

  @override
  List<Object> get props => [];
}

class CodeChanged extends VerifyEvent {
  const CodeChanged(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class SignOutRequested extends VerifyEvent {
  const SignOutRequested();
}
