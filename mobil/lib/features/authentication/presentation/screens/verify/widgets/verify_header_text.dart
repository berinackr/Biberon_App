import 'package:flutter/material.dart';

class VerifyHeaderText extends StatefulWidget {
  const VerifyHeaderText({super.key});

  @override
  State<VerifyHeaderText> createState() => _VerifyHeaderTextState();
}

class _VerifyHeaderTextState extends State<VerifyHeaderText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 170),
      child: Center(
        child: Column(
          children: [
            FittedBox(
              child: Text(
                'E-posta Doğrulaması',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'E-postanıza gelen 6 haneli kodu giriniz',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
