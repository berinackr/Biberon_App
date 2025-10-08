import 'package:biberon/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => context.read<SignInBloc>().add(const SignInRequested()),
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size.fromHeight(45),
            ),
          ),
      child: const Text(
        'Giriş Yap',
      ),
    );
  }
}
