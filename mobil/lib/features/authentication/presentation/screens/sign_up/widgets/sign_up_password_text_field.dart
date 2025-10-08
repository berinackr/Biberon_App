import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/authentication/presentation/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPasswordTextField extends StatelessWidget {
  const SignUpPasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = context.select(
      (SignUpBloc bloc) => bloc.state.passwordVisibility,
    );

    final password = context.select(
      (SignUpBloc bloc) => bloc.state.password,
    );

    return SharedTextInput(
      input: password,
      prefixIcon: Icons.lock_outline,
      onChanged: (value) =>
          context.read<SignUpBloc>().add(SignUpPasswordChanged(value)),
      label: 'Şifre',
      keyboardType: TextInputType.visiblePassword,
      isPassword: true,
      isTextVisible: passwordVisibility,
      suffixOnPressed: () => context
          .read<SignUpBloc>()
          .add(SignUpPasswordVisibilityChanged(!passwordVisibility)),
    );
  }
}
