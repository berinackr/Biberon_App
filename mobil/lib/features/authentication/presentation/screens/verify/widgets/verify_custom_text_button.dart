import 'package:flutter/material.dart';

class VerifyCustomTextButton extends StatelessWidget {
  const VerifyCustomTextButton({
    required this.buttonText,
    super.key,
    this.onPressed,
    this.isLoading = false,
  });
  final String buttonText;
  final void Function()? onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: Text(
        buttonText,
      ),
    );
  }
}
