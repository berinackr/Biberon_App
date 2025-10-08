import 'package:biberon/common/app/router/app_routes.dart';
import 'package:biberon/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:biberon/features/onboarding/widgets/onboarding_guest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingSignUpButton extends StatelessWidget {
  const OnboardingSignUpButton({
    required this.controller,
    required this.currentPage,
    super.key,
  });

  final PageController controller;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Sağ ve sol boşluk
      child: Column(
        children: [
          // İlerle veya Kayıt Ol butonu
          FilledButton(
            onPressed: () => navigateOrAdvance(context),
            style: Theme.of(context).filledButtonTheme.style!.copyWith(
                  minimumSize: const MaterialStatePropertyAll(
                    Size.fromHeight(45),
                  ),
                ),
            child: Text(
              getButtonText(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color.fromARGB(255, 254, 254, 254),
                  ),
            ),
          ),

          // Eğer son sayfadaysak Misafir Girişi butonunu göster
          if (currentPage == 2) ...[
            const SizedBox(height: 12), // Araya boşluk ekle
            const OnboardingGuestButton(), // Misafir Girişi butonu
          ],
        ],
      ),
    );
  }

  // Butonun metnini güncelleyebilmek için ayrı bir metod
  String getButtonText() {
    return currentPage == 2 ? 'Kayıt Ol >' : 'İlerle >';
  }

  // Geçiş veya yönlendirme işlemini kontrol eden fonksiyon
  void navigateOrAdvance(BuildContext context) {
    if (currentPage == 2) {
      // Son slayttaysak, kayıt sayfasına yönlendirme yap.
      context
        ..read<OnboardingBloc>().add(
          const SetOnboardingShowed(),
        )
        ..pushReplacementNamed(AppRoutes.signUp);
    } else {
      // Diğer slaytlarda, bir sonraki sayfaya geçiş yap.
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
