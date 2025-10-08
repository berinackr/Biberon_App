import 'package:biberon/common/widgets/prefix_icon.dart';
import 'package:biberon/features/authentication/presentation/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordTextField extends StatelessWidget {
  const ForgetPasswordTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final email = context.select(
      (ForgetPasswordBloc bloc) => bloc.state.email,
    );
    return TextField(
      onChanged: (value) {
        context.read<ForgetPasswordBloc>().add(
              ForgetPasswordEmailChanged(value),
            );
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-posta',
        floatingLabelStyle:
            Theme.of(context).inputDecorationTheme.labelStyle!.copyWith(
                  height: 0.1,
                ),
        errorText: email.displayError == null ? null : email.errorMessage,
        prefixIcon: PrefixIcon(
          input: email,
          icon: Icons.email,
        ),
      ),
    );
  }
}
