import 'package:biberon/core/onboarding_asset_list.dart';
import 'package:biberon/features/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:biberon/features/onboarding/widgets/onboarding_sign_up_button.dart';
import 'package:biberon/features/onboarding/widgets/onboarding_slide.dart';
import 'package:flutter/material.dart';

class OnboardingSliderMenu extends StatefulWidget {
  const OnboardingSliderMenu({required this.controller, super.key});
  final PageController controller;

  @override
  State<OnboardingSliderMenu> createState() => _OnboardingSliderMenuState();
}

class _OnboardingSliderMenuState extends State<OnboardingSliderMenu> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: PageView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => OnboardingSlide(
              imagetwo: onImages[index][0],
              title: onImages[index][1],
              subTitle: onImages[index][2],
            ),
            controller: widget.controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        OnboardingDotNavigation(
          controller: widget.controller,
        ),
        const SizedBox(height: 40),
        OnboardingSignUpButton(
          controller: widget.controller,
          currentPage: _currentPage,
        ),
      ],
    );
  }
}
