part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.userAgreement = const UserAgreement.pure(),
    this.passwordVisibility = false,
    this.errorMessage,
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final Name name;
  final UserAgreement userAgreement;
  final bool passwordVisibility;
  final String? errorMessage;

  bool get isValid =>
      email.isValid &&
      password.isValid &&
      name.isValid &&
      userAgreement.isValid;

  SignUpState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    Name? name,
    UserAgreement? userAgreement,
    bool? passwordVisibility,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      userAgreement: userAgreement ?? this.userAgreement,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        name,
        userAgreement,
        passwordVisibility,
        errorMessage,
      ];
}
