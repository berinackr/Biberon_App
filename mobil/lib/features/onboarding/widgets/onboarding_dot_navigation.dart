import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({required this.controller, super.key});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      count: 3,
      controller: controller,
      onDotClicked: controller.jumpToPage,
      effect: const ExpandingDotsEffect(
        activeDotColor: Color.fromARGB(255, 59, 86, 103),
        dotColor: Color.fromARGB(255, 229, 229, 229),
        dotHeight: 10,
        dotWidth: 10,
      ),
    );
  }
}
