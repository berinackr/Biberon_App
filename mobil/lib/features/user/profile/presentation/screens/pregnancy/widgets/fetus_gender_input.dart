import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetusGender extends StatelessWidget {
  const FetusGender({
    required this.i,
    required this.state,
    super.key,
  });

  final int i;
  final PregnancyState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: HeaderText(
            title: '\t\t\t- ${i + 1}. Bebeğimin Cinsiyeti :',
          ),
        ),
        const SizedBox(width: 20),
        DropdownButton(
          value: state.fetuses![i].gender,
          items: lGender
              .map<DropdownMenuItem<String>>(
                (String gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender.toTurkishGender,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              )
              .toList(),
          onChanged: state.isActive == null || state.isActive!
              ? (String? gender) {
                  context.read<PregnancyBloc>().add(
                        FieldChangedGender(gender!, i),
                      );
                }
              : null,
        ),
      ],
    );
  }
}
