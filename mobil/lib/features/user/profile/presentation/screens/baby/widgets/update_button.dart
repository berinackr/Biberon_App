import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({
    required this.state,
    super.key,
  });

  final BabyState state;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size(double.infinity, 60),
            ),
          ),
      onPressed: () {
        if (state.babyId == null) {
          context.read<BabyBloc>().add(
                const BabyEventAddBaby(),
              );
        } else {
          context.read<BabyBloc>().add(
                const BabyEventUpdateBaby(),
              );
        }
        if (state.isValid) {
          context.pop(true);
        }
      },
      child: Text(
        state.babyId == null ? 'Ekle' : 'Güncelle',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
