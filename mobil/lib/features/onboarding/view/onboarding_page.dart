import 'package:biberon/features/onboarding/widgets/onboarding_redirection.dart';
import 'package:biberon/features/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OnboardingSliderMenu(
                controller: _controller,
              ),
              const OnboardingRedirection(),
              const SizedBox(height: 12),
            ],
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: OnboardingSkipButton(),
          ),
        ],
      ),
    );
  }
}
