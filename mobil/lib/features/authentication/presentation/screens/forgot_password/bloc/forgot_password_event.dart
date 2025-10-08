part of 'forgot_password_bloc.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordEmailChanged extends ForgetPasswordEvent {
  const ForgetPasswordEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SendForgetPasswordEmail extends ForgetPasswordEvent {
  const SendForgetPasswordEmail();
}
