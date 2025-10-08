import 'package:biberon/features/authentication/presentation/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => context.read<SignUpBloc>().add(const SignUpRequested()),
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size.fromHeight(45),
            ),
          ),
      child: const Text(
        'Kayıt Ol',
      ),
    );
  }
}
