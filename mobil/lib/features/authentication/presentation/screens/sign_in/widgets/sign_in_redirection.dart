import 'package:biberon/common/app/app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInRedirection extends StatelessWidget {
  const SignInRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Hesabınız yok mu? ',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        InkWell(
          onTap: () => context.pushNamed(AppRoutes.signUp),
          child: Text(
            'Kayıt Ol',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
