import 'package:biberon/common/app/app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingRedirection extends StatelessWidget {
  const OnboardingRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Kayıtlı mısınız? ',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color.fromARGB(255, 59, 86, 103),
              ),
          textAlign: TextAlign.center,
        ),
        InkWell(
          onTap: () => context.goNamed(AppRoutes.signIn),
          child: Text(
            'Giriş için Tıklayın',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color.fromARGB(255, 59, 86, 103),
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
