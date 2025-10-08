import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PregnancyType extends StatelessWidget {
  const PregnancyType({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(
          child: HeaderText(title: 'Hamilelik Tipi :'),
        ),
        DropdownButton(
          value: state.type,
          items: lType
              .map<DropdownMenuItem<String>>(
                (String type) => DropdownMenuItem(
                  value: type,
                  child: Text(
                    type.toTurkishType,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              )
              .toList(),
          onChanged: state.isActive == null || state.isActive!
              ? (String? value) {
                  context.read<PregnancyBloc>().add(
                        FieldChangedType(value),
                      );
                }
              : null,
        ),
      ],
    );
  }
}
