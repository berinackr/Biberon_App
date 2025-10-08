import 'package:biberon/common/app/router/app_routes.dart';
import 'package:biberon/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingGuestButton extends StatelessWidget {
  const OnboardingGuestButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Misafir Giriş'e yönlendirme işlemi
        context
          ..read<OnboardingBloc>().add(
            const SetOnboardingShowed(),
          )
          ..pushReplacementNamed(AppRoutes.signIn);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Beyaz arkaplan
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: Color.fromARGB(255, 233, 233, 233), // Kenarlık rengi
            width: 1,
          ),
        ),
        minimumSize:
            const Size.fromHeight(45), // Boyutu "Kayıt Ol" butonuyla aynı
      ),
      child: Text(
        'Misafir Girişi ile Devam Et',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color.fromARGB(255, 95, 95, 95), // Metin rengi
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
