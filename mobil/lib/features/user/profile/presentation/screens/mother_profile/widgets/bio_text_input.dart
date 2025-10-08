// ignore_for_file: require_trailing_commas

import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BioTextInput extends StatelessWidget {
  const BioTextInput({super.key});

  @override
  Widget build(BuildContext context) {
    final input = context.read<MotherProfileBloc>().state.bio;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        children: [
          SharedTextInput(
            input: input,
            prefixIcon: Icons.person_pin_circle_rounded,
            label: 'Hakkımda',
            maxLines: 3,
            maxLength: 255,
            initialValue: input.value,
            onChanged: (value) {
              context.read<MotherProfileBloc>().add(
                    UpdateUserBio(value),
                  );
            },
          )
        ],
      ),
    );
  }
}
