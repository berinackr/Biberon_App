import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/authentication/presentation/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpEmailTextField extends StatelessWidget {
  const SignUpEmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select(
      (SignUpBloc bloc) => bloc.state.email,
    );

    return SharedTextInput(
      input: email,
      prefixIcon: Icons.email_outlined,
      onChanged: (value) =>
          context.read<SignUpBloc>().add(SignUpEmailChanged(value)),
      label: 'E-posta',
      keyboardType: TextInputType.emailAddress,
    );
  }
}
