import 'package:biberon/features/authentication/presentation/screens/verify/bloc/verify_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((VerifyBloc bloc) => bloc.state.status);
    return FilledButton(
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size.fromHeight(45),
            ),
          ),
      onPressed: () => context.read<VerifyBloc>().add(const VerifyRequested()),
      child: status == FormzSubmissionStatus.inProgress
          ? SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 3,
              ),
            )
          : const Text(
              'DOĞRULA',
            ),
    );
  }
}
