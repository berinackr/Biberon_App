import 'package:biberon/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:biberon/features/authentication/presentation/screens/sign_in/widgets/forgot_password_redirection.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SignInEmailTextField(),
        SizedBox(height: 10),
        SignInPasswordTextField(),
        SizedBox(height: 20),
        ForgotPasswordRedirection(),
        SizedBox(height: 5),
        SignInRedirection(),
        SizedBox(height: 30),
        SignInButton(),
      ],
    );
  }
}
