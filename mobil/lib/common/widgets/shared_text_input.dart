import 'package:biberon/common/models/models.dart';
import 'package:biberon/common/widgets/prefix_icon.dart';
import 'package:biberon/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharedTextInput extends StatelessWidget {
  const SharedTextInput({
    required this.input,
    required this.prefixIcon,
    required this.label,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.isTextVisible = true,
    this.initialValue,
    this.suffixOnPressed,
    this.controller,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.inputFormatters = const [],
    this.maxLength,
    super.key,
  }) : assert(
          !isPassword || (isPassword && suffixOnPressed != null),
          'If isPassword is true, suffixOnPressed must be provided',
        );

  final FormzInputWithErrorMessage<dynamic, dynamic> input;
  final IconData prefixIcon;
  final void Function()? suffixOnPressed;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isTextVisible;
  final String label;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextEditingController? controller;
  final bool readOnly;
  final IconButton? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: !isPassword,
      controller: controller,
      obscureText: !isTextVisible,
      initialValue: initialValue,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.top,
      inputFormatters: inputFormatters,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        errorText: input.displayError == null ? null : input.errorMessage,
        prefixIcon: PrefixIcon(icon: prefixIcon, input: input),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 36, maxHeight: 36),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isTextVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: input.displayError == null
                      ? CustomColors.iconColor
                      : CustomColors.errorIcon,
                ),
                onPressed: suffixOnPressed,
              )
            : suffixIcon,
      ),
    );
  }
}
