// ignore_for_file: prefer_single_quotes

import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');

    return BlocBuilder<MotherProfileBloc, MotherProfileState>(
      builder: (context, state) {
        final dateInput = state.dateOfBirth;

        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SharedTextInput(
            input: dateInput,
            prefixIcon: Icons.calendar_today,
            label: "Doğum Tarihi",
            onTap: () => _selectDate(context),
            readOnly: true,
            controller: TextEditingController(
              text: dateInput.value != null
                  ? formatter.format(dateInput.value!)
                  : "",
            ),
            suffixIcon: dateInput.isPure
                ? null
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => context.read<MotherProfileBloc>().add(
                          const DeleteUserDateOfBirth(),
                        ),
                  ),
          ),
          // TextFormField(
          //   readOnly: true,
          //   decoration: InputDecoration(
          //     labelText: 'Doğum Tarihi',
          //     prefixIcon: Icon(
          //       Icons.date_range,
          //       color: dateInput.value == null
          //           ? Colors.grey
          //           : dateInput.displayError == null
          //               ? CustomColors.successIcon
          //               : CustomColors.errorIcon,
          //     ),
          //     prefixIconConstraints:
          //         const BoxConstraints(minWidth: 36, maxHeight: 36),
          //     isDense: true,
          //     errorText: dateInput.displayError == null
          //         ? null
          //         : dateInput.errorMessage,
          //     contentPadding:
          //         const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          //     suffixIcon: dateInput.isPure
          //         ? null
          //         : IconButton(
          //             icon: Icon(
          //               Icons.delete,
          //               color: Theme.of(context).colorScheme.error,
          //             ),
          //             onPressed: () => context.read<MotherProfileBloc>().add(
          //                   const DeleteUserDateOfBirth(),
          //                 ),
          //           ),
          //   ),
          //   controller: TextEditingController(
          //     text: dateInput.value != null
          //         ? formatter.format(dateInput.value!)
          //         : '',
          //   ),
          //   onTap: () => _selectDate(context),
          // ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final bloc = context.read<MotherProfileBloc>();

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(
        DateTime.now().year - 18,
        DateTime.now().month,
        DateTime.now().day,
      ),
      initialDate: DateTime(
        DateTime.now().year - 18,
        DateTime.now().month,
        DateTime.now().day,
      ),
      locale: const Locale("tr"),
    );

    if (picked != null) {
      bloc.add(UpdateUserDateOfBirth(picked));
    }
  }
}
