// ignore_for_file: unnecessary_null_comparison

import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/text_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeOfBirthWidget extends StatefulWidget {
  const TimeOfBirthWidget({
    required this.state,
    super.key,
  });

  final BabyState state;

  @override
  State<TimeOfBirthWidget> createState() => _TimeOfBirthWidgetState();
}

class _TimeOfBirthWidgetState extends State<TimeOfBirthWidget> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dateController.text = widget.state.dateOfBirth != null
          ? widget.state.dateOfBirth.value!
              .toIso8601String()
              .split('T')[0]
              .split('-')
              .reversed
              .join('.')
          : '';
      _timeController.text = widget.state.birthTime != null
          ? TimeOfDay.fromDateTime(widget.state.birthTime!).format(context)
          : '';
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          const HeaderText(title: 'Doğum Saati :'),
          TextFormField(
            controller: _timeController,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            readOnly: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onTap: () async {
              final initialTime = widget.state.birthTime != null
                  ? TimeOfDay.fromDateTime(widget.state.birthTime!)
                  : TimeOfDay.now();
              await showTimePicker(
                helpText: 'Doğum Saatini Seçiniz',
                context: context,
                initialTime: initialTime,
              ).then((value) {
                if (value != null) {
                  final now = DateTime.now();
                  final selectedTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    value.hour,
                    value.minute,
                  );
                  context.read<BabyBloc>().add(
                        BabyEventBirthTimeChanged(selectedTime),
                      );
                  setState(() {
                    _timeController.text = value.format(context);
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
