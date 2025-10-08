import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BabyGender extends StatelessWidget {
  const BabyGender({
    required this.state,
    super.key,
  });

  final BabyState state;

  @override
  Widget build(BuildContext context) {
    // Ensure the gender list and state gender value are properly initialized
    final genderList = lGender;
    final selectedGender = state.gender.value;

    // Check if the selected gender is in the list, otherwise set it to null
    final dropdownValue =
        genderList.contains(selectedGender) ? selectedGender : null;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: HeaderText(
                title: 'Bebeğimin Cinsiyeti :',
              ),
            ),
            const SizedBox(width: 25),
            DropdownButton<String>(
              value: dropdownValue,
              items: genderList
                  .map<DropdownMenuItem<String>>(
                    (String gender) => DropdownMenuItem<String>(
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
              onChanged: (String? gender) {
                if (gender != null) {
                  context.read<BabyBloc>().add(
                        BabyEventGenderChanged(gender),
                      );
                }
              },
            ),
          ],
        ),
        if (state.gender.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              state.gender.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
