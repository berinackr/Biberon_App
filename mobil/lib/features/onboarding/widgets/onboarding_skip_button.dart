import 'package:biberon/common/app/router/app_routes.dart';
import 'package:biberon/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: () => context
            ..read<OnboardingBloc>().add(
              const SetOnboardingShowed(),
            )
            ..pushReplacementNamed(AppRoutes.signIn),
          child: Text(
            'Atla',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color.fromARGB(255, 59, 86, 103),
                ),
          ),
        ),
      ),
    );
  }
}
