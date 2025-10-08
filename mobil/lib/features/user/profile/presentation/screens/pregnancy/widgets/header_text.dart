import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
