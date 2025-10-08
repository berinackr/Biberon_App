import 'package:biberon/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class PrefixIcon extends StatelessWidget {
  const PrefixIcon({
    required this.icon,
    required this.input,
    super.key,
  });

  // ignore: strict_raw_type
  final FormzInput input;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      // ignore: avoid_dynamic_calls
      color: input.value == null || input.value == ''
          ? CustomColors.iconColor
          : input.displayError == null
              ? CustomColors.successIcon
              : CustomColors.errorIcon,
    );
  }
}
