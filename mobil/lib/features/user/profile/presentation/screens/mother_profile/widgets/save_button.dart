import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FilledButton(
        onPressed: () {
          context.read<MotherProfileBloc>().add(const UpdateUserProfile());
        },
        style: Theme.of(context).filledButtonTheme.style!.copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(45),
              ),
            ),
        child: const Text(
          'KAYDET',
        ),
      ),
    );
  }
}
