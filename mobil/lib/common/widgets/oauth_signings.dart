import 'package:biberon/common/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OauthSignings extends StatelessWidget {
  const OauthSignings({
    required this.onPressedGoogle,
    required this.onPressedApple,
    super.key,
  });

  final void Function() onPressedGoogle;
  final void Function() onPressedApple;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OauthButton(
          imagePath: 'assets/sign-in/icon_google.png',
          onPressed: onPressedGoogle,
        ),
        const SizedBox(width: 16),
        OauthButton(
          imagePath: 'assets/sign-in/icon_apple.png',
          onPressed: onPressedApple,
        ),
      ],
    );
  }
}
