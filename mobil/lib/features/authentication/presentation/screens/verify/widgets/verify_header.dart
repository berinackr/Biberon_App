import 'package:flutter/material.dart';

class VerifyHeader extends StatelessWidget {
  const VerifyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 70,
          top: 50,
          child: Image.asset(
            'assets/verify-mail/decorative_spray.png',
          ),
        ),
        Positioned(
          right: 40,
          top: 50,
          child: Image.asset(
            'assets/verify-mail/pink_star.png',
          ),
        ),
        Positioned(
          right: 0,
          top: 150,
          child: Image.asset(
            'assets/verify-mail/light_blue_star.png',
          ),
        ),
      ],
    );
  }
}
