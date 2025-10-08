import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/authentication/presentation/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpNameTextField extends StatelessWidget {
  const SignUpNameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.select(
      (SignUpBloc bloc) => bloc.state.name,
    );
    return SharedTextInput(
      input: name,
      prefixIcon: Icons.person_outline,
      onChanged: (value) =>
          context.read<SignUpBloc>().add(SignUpNameChanged(value)),
      label: 'Kullanıcı Adı',
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
      ],
    );
  }
}
