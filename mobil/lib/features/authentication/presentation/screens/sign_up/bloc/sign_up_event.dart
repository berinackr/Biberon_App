part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignUpGooglePressed extends SignUpEvent {
  const SignUpGooglePressed();
}

class SignUpApplePressed extends SignUpEvent {
  const SignUpApplePressed();
}

class SignUpNameChanged extends SignUpEvent {
  const SignUpNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class SignUpUserAgreementChanged extends SignUpEvent {
  const SignUpUserAgreementChanged({required this.userAgreement});

  final bool userAgreement;

  @override
  List<Object?> get props => [userAgreement];
}

class SignUpPasswordVisibilityChanged extends SignUpEvent {
  // ignore: avoid_positional_boolean_parameters
  const SignUpPasswordVisibilityChanged(this.passwordVisibility);

  final bool passwordVisibility;

  @override
  List<Object?> get props => [passwordVisibility];
}

class SignUpRequested extends SignUpEvent {
  const SignUpRequested();
}
