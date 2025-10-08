import 'package:biberon/features/forum/presentation/screens/feed/bloc/feed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagField extends StatelessWidget {
  const TagField({
    required this.state,
    super.key,
  });

  final FeedState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Konu Etiketi'),
        DropdownButton(
          value: state.tagId,
          items: EnumTags.values
              .map(
                (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            context.read<FeedBloc>().add(
                  FieldChangedTagId(tagId: value!),
                );
          },
        ),
      ],
    );
  }
}
