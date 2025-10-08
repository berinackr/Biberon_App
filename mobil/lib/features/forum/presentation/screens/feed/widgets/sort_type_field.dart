import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortTypeField extends StatelessWidget {
  const SortTypeField({
    required this.state,
    super.key,
  });

  final FeedState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Sıralama Türü'),
        DropdownButton(
          value: state.sortType,
          items: SortType.values
              .map(
                (e) => DropdownMenuItem(
                  value: e.name,
                  child: Text(e.turkishName),
                ),
              )
              .toList(),
          onChanged: (value) {
            context.read<FeedBloc>().add(
                  FieldChangedSortType(sortType: value!),
                );
          },
        ),
      ],
    );
  }
}
