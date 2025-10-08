import 'package:biberon/core/colors.dart';
import 'package:flutter/material.dart';

class OauthButton extends StatelessWidget {
  const OauthButton({
    required this.imagePath,
    required this.onPressed,
    super.key,
  });

  final String imagePath;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
            side: const MaterialStatePropertyAll(
              BorderSide(
                color: CustomColors.outlineColor,
              ),
            ),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.zero,
            ),
            visualDensity: VisualDensity.compact,
            minimumSize: const MaterialStatePropertyAll(
              Size(50, 50),
            ),
          ),
      child: Image.asset(
        imagePath,
        height: 24,
      ),
    );
  }
}
