import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    required this.imagetwo,
    required this.title,
    required this.subTitle,
    super.key,
  });

  final String imagetwo;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Image(
              image: AssetImage(imagetwo),
            ),
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color.fromARGB(255, 59, 86, 103),
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color.fromARGB(255, 59, 86, 103),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
