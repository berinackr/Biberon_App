import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Kayıt Ol',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}
