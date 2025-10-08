import 'package:flutter/material.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text(
            'Endişelenmeyin! E-postanızı yazın,',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        FittedBox(
          child: Text(
            'biz size sıfırlama linki gönderelim.',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
