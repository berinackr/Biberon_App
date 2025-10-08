import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPasswordTextField extends StatelessWidget {
  const SignInPasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = context.select(
      (SignInBloc bloc) => bloc.state.passwordVisibility,
    );

    final password = context.select(
      (SignInBloc bloc) => bloc.state.password,
    );

    return SharedTextInput(
      input: password,
      prefixIcon: Icons.lock,
      onChanged: (value) =>
          context.read<SignInBloc>().add(SignInPasswordChanged(value)),
      label: 'Şifre',
      keyboardType: TextInputType.visiblePassword,
      isPassword: true,
      isTextVisible: passwordVisibility,
      suffixOnPressed: () => context
          .read<SignInBloc>()
          .add(SignInPasswordVisibilityChanged(!passwordVisibility)),
    );
  }
}
