import 'package:flutter/widgets.dart';

class SpacedContainer extends StatelessWidget {
  const SpacedContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: child,
    );
  }
}
