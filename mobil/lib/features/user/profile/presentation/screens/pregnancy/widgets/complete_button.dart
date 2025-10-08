import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        await showDatePicker(
          context: context,
          firstDate: state.lastPeriodDate!.value ??
              DateTime.now().subtract(
                const Duration(days: 280),
              ),
          lastDate: DateTime.now(),
          locale: const Locale('tr', 'TR'),
          helpText: 'Hamilelik Bitiş Tarihi :',
        ).then((value) {
          if (value != null) {
            context.read<PregnancyBloc>().add(
                  CompletePregnancy(
                    birthDate: value,
                  ),
                );
            context.pop(true);
          }
        });
      },
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            backgroundColor: MaterialStatePropertyAll(
              Colors.green.shade500,
            ),
            minimumSize: const MaterialStatePropertyAll(
              Size(double.infinity, 60),
            ),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hamileliği Bitir',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
