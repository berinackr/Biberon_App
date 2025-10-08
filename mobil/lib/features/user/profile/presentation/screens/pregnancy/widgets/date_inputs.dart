import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateWidgets extends StatefulWidget {
  const DateWidgets({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  State<DateWidgets> createState() => _DateWidgetsState();
}

class _DateWidgetsState extends State<DateWidgets> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          if (widget.state.iKnowDueDate)
            Column(
              children: [
                HeaderText(
                  title: widget.state.isActive == null || widget.state.isActive!
                      ? 'Tahmini Doğum Tarihi :'
                      : 'Doğum Tarihi :',
                ),
                TextFormField(
                  enabled: widget.state.isActive,
                  controller: TextEditingController(
                    text: widget.state.dueDate!.value != null
                        ? widget.state.dueDate!.value!
                            .toIso8601String()
                            .split('T')[0]
                            .split('-')
                            .reversed
                            .join('.')
                        : ' ',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: widget.state.iKnowDueDate &&
                            widget.state.dueDate!.displayError != null
                        ? widget.state.dueDate!.errorMessage
                        : null,
                  ),
                  onTap: () async {
                    await showDatePicker(
                      helpText: 'Tahmini Doğum Tarihi Seçiniz',
                      currentDate: widget.state.dueDate?.value,
                      context: context,
                      initialDate: widget.state.dueDate?.value,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(
                        const Duration(days: 280),
                      ),
                      locale: const Locale('tr'),
                    ).then((value) {
                      if (value != null) {
                        context.read<PregnancyBloc>().add(
                              FieldChangedDueDate(value),
                            );
                      }
                    });
                  },
                ),
              ],
            ),
          if (!widget.state.iKnowDueDate)
            Column(
              children: [
                const HeaderText(
                  title: 'Son Adet Tarihi :',
                ),
                TextFormField(
                  controller: TextEditingController(
                    text: widget.state.lastPeriodDate == null
                        ? ' '
                        : widget.state.lastPeriodDate!.value != null
                            ? widget.state.lastPeriodDate!.value!
                                .toIso8601String()
                                .split('T')[0]
                                .split('-')
                                .reversed
                                .join('.')
                            : ' ',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    errorText: !widget.state.iKnowDueDate &&
                            widget.state.lastPeriodDate!.displayError != null
                        ? widget.state.lastPeriodDate!.errorMessage
                        : null,
                  ),
                  onTap: () async {
                    await showDatePicker(
                      helpText: 'Son Adet Tarihi Seçiniz',
                      currentDate: widget.state.lastPeriodDate?.value,
                      initialDate: widget.state.lastPeriodDate?.value,
                      context: context,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 280),
                      ),
                      locale: const Locale('tr'),
                      lastDate: DateTime.now(),
                    ).then(
                      (value) {
                        if (value != null) {
                          context.read<PregnancyBloc>().add(
                                FieldChangedLastPeriodDate(
                                  value,
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
