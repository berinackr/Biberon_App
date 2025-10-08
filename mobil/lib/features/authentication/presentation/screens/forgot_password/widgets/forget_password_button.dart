import 'package:biberon/features/authentication/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
          (ForgetPasswordBloc bloc) => bloc.state.status,
        ) ==
        FormzSubmissionStatus.inProgress;
    return FilledButton(
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size(double.infinity, 60),
            ),
          ),
      onPressed: () => isLoading
          ? null
          : context
              .read<ForgetPasswordBloc>()
              .add(const SendForgetPasswordEmail()),
      child: const Text(
        'GÖNDER',
      ),
    );
  }
}
