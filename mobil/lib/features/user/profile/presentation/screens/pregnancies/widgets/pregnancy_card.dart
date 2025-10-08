import 'package:biberon/common/app/router/app_routes.dart';
import 'package:biberon/features/user/profile/domain/models/pregnancy_model.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancies/bloc/pregnancies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PregnancyCard extends StatelessWidget {
  const PregnancyCard({
    required this.result,
    required this.index,
    super.key,
  });

  final List<Pregnancy?> result;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              width: 15,
              color: result[index]!.isActive
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
            ),
            InkWell(
              onTap: () => context.pushNamed(
                AppRoutes.pregnancy,
                extra: {
                  () => context.read<PregnanciesBloc>().add(
                        const FetchPregnancies(),
                      ),
                },
                queryParameters: {
                  'pregnancyId': result[index]!.id.toString(),
                },
              ).then(
                (value) => value == true
                    ? context.read<PregnanciesBloc>().add(
                          const FetchPregnancies(),
                        )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text(
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          result[index]!.isActive
                              ?
                              // ignore: lines_longer_than_80_chars
                              '${(result[index]!.dueDate!.subtract(const Duration(days: 280)).difference(DateTime.now()).inDays.abs() / 7).floor()} hafta ${result[index]!.dueDate!.subtract(const Duration(days: 280)).difference(DateTime.now()).inDays.abs() % 7} günlük'
                              : '''Doğum Tarihi: \n${result[index]!.endDate!.toIso8601String().split('T')[0].split('-').reversed.join('.')}''',
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            result[index]!.isActive ? 'Aktif' : 'Tamamlanmış',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: result[index]!.isActive
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.secondary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons
                                // ignore: lines_longer_than_80_chars
                                .arrow_forward_ios_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
