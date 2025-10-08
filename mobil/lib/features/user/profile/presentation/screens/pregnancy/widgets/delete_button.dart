import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Hamileliği Sil ❗️'),
              content: const Text(
                '''Bu hamileliği silmek istediğinize emin misiniz?\nBu işlem geri alınamaz!''',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Hayır'),
                ),
                TextButton(
                  onPressed: () async {
                    context.read<PregnancyBloc>().add(
                          DeletePregnancy(
                            state.pregnancyId!,
                          ),
                        );
                    context
                      ..pop()
                      ..pop(true);
                  },
                  child: const Text('Evet'),
                ),
              ],
            );
          },
        );
      },
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.error,
            ),
            minimumSize: const MaterialStatePropertyAll(
              Size(double.infinity, 60),
            ),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sil',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
