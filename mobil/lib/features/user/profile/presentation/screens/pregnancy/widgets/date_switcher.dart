import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateSwitcher extends StatelessWidget {
  const DateSwitcher({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            '''Bebeğinizin tahmini doğum tarihini biliyor musunuz?''',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Switch(
          value: state.iKnowDueDate,
          onChanged: (value) {
            context.read<PregnancyBloc>().add(
                  FieldChangedIKnowDueDate(
                    iKnowDueDate: value,
                  ),
                );
          },
        ),
      ],
    );
  }
}
