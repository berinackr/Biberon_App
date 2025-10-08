// ignore_for_file: unnecessary_null_comparison

import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/text_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateOfBirthWidget extends StatefulWidget {
  const DateOfBirthWidget({
    required this.state,
    super.key,
  });

  final BabyState state;

  @override
  State<DateOfBirthWidget> createState() => _DateOfBirthWidgetState();
}

class _DateOfBirthWidgetState extends State<DateOfBirthWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.state.dateOfBirth != null
          ? widget.state.dateOfBirth.value
              ?.toIso8601String()
              .split('T')[0]
              .split('-')
              .reversed
              .join('.')
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          const HeaderText(title: 'Doğum Tarihi :'),
          TextFormField(
            controller: _controller,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            readOnly: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              errorText: widget.state.dateOfBirth.getErrorMessage,
            ),
            onTap: () async {
              await showDatePicker(
                helpText: 'Doğum Tarihini Seçiniz',
                context: context,
                initialDate: widget.state.dateOfBirth.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                //locale: const Locale('tr'),
              ).then((value) {
                if (value != null) {
                  context.read<BabyBloc>().add(
                        BabyEventDateOfBirthChanged(value),
                      );
                  setState(() {
                    _controller.text = value
                        .toIso8601String()
                        .split('T')[0]
                        .split('-')
                        .reversed
                        .join('.');
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
