import 'package:biberon/features/authentication/presentation/screens/verify/verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class CodeInput extends StatelessWidget {
  const CodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.select(
      (VerifyBloc bloc) => bloc.state.code,
    );
    return Column(
      children: [
        const SizedBox(height: 10),
        VerificationCode(
          underlineColor: Theme.of(context).colorScheme.primary,
          length: 6,
          itemSize: 45,
          onCompleted: (value) =>
              context.read<VerifyBloc>().add(CodeChanged(value)),
          onEditing: (value) {
            context.read<VerifyBloc>().add(CodeChanged(code.toString()));
          },
          textStyle: Theme.of(context).textTheme.headlineSmall!,
          digitsOnly: true,
          fullBorder: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 2),
        ),
        const SizedBox(height: 8),
        if (code.displayError == null)
          const SizedBox()
        else
          Text(
            code.errorMessage!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
