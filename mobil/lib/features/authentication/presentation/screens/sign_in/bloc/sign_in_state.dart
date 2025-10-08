part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordVisibility = false,
    this.errorMessage,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final bool passwordVisibility;
  final String? errorMessage;
  bool get isValid => email.isValid && password.isValid;

  SignInState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    bool? passwordVisibility,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        passwordVisibility,
        errorMessage,
      ];
}
