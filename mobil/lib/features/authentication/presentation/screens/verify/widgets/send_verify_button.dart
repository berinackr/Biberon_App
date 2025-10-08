import 'package:biberon/features/authentication/presentation/screens/verify/bloc/verify_bloc.dart';
import 'package:biberon/features/authentication/presentation/screens/verify/widgets/verify_custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendVerifyButton extends StatelessWidget {
  const SendVerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return VerifyCustomTextButton(
      buttonText: 'Tekrar Gönder',
      onPressed: () => context.read<VerifyBloc>().add(
            const SendVerifyEmail(),
          ),
    );
  }
}
