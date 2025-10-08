import 'package:biberon/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () =>
          context.read<SignInBloc>().add(const SignInWithGoogleRequested()),
      style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size(90, 60),
            ),
            side: MaterialStatePropertyAll(
              BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      child: Image.asset('assets/sign-in/icon_google.png', height: 32),
    );
  }
}
