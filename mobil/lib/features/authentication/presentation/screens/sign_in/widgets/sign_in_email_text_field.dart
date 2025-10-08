import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInEmailTextField extends StatelessWidget {
  const SignInEmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select(
      (SignInBloc bloc) => bloc.state.email,
    );

    return SharedTextInput(
      input: email,
      prefixIcon: Icons.email_outlined,
      onChanged: (value) =>
          context.read<SignInBloc>().add(SignInEmailChanged(value)),
      label: 'E-posta',
      keyboardType: TextInputType.emailAddress,
    );
  }
}
