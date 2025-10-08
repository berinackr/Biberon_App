import 'package:biberon/common/app/app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpRedirection extends StatelessWidget {
  const SignUpRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Zaten bir hesabın var mı? ',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        InkWell(
          onTap: () => context.goNamed(AppRoutes.signIn),
          child: Text(
            'Giriş Yap',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
