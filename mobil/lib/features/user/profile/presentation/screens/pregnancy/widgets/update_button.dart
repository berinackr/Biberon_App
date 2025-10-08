import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size(double.infinity, 60),
            ),
          ),
      onPressed: () {
        if (state.pregnancyId == null) {
          context.read<PregnancyBloc>().add(
                const AddPregnancy(),
              );
        } else {
          context.read<PregnancyBloc>().add(
                const UpdatePregnancy(),
              );
        }
        if (state.isValid) {
          context.pop(true);
        }
      },
      child: Text(
        state.pregnancyId == null ? 'Ekle' : 'Güncelle',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
