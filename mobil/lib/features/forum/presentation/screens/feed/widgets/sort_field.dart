import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortField extends StatelessWidget {
  const SortField({
    required this.state,
    super.key,
  });

  final FeedState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Sıralama'),
        Row(
          children: [
            const Text('Artan'),
            Switch(
              value: state.sortDesc,
              onChanged: (value) {
                context.read<FeedBloc>().add(
                      FieldChangedSortDesc(sort: value),
                    );
              },
            ),
            const Text('Azalan'),
          ],
        ),
      ],
    );
  }
}
