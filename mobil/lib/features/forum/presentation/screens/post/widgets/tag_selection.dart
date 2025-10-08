// ignore: lines_longer_than_80_chars
// ignore_for_file: avoid_positional_boolean_parameters, avoid_void_async, omit_, omit_local_variable_types, use_build_context_synchronously
//local_variable_types, use_build_context_synchronously

import 'package:biberon/common/app/app.dart';
import 'package:biberon/common/data/forum_tags.dart';
import 'package:biberon/core/colors.dart';
import 'package:biberon/features/forum/presentation/screens/post/bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TagSelection extends StatefulWidget {
  const TagSelection({super.key});

  @override
  State<TagSelection> createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {
  @override
  Widget build(BuildContext context) {
    final selectedTags = context.watch<PostBloc>().state.tags;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            context.pushNamed(AppRoutes.selectTag);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedTags.displayError != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.tag,
                  size: 20,
                  color: CustomColors.iconColor,
                ),
                const SizedBox(width: 8),
                if (selectedTags.value.isEmpty)
                  Text(
                    'Etiket seçimi',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                else
                  Wrap(
                    spacing: 4,
                    children: selectedTags.value
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: CustomColors.successIcon.withOpacity(0.8),
                            ),
                            child: Text(
                              '#${ForumTags.getTagNameById(e)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: CustomColors.tagColor,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
        if (selectedTags.displayError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              selectedTags.errorMessage ?? '',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     ElevatedButton(
    //       onPressed: _showMultiSelect,
    //       child: const Text('Etiket Seçiniz'),
    //     ),
    //     Wrap(
    //       children: _selectedTags
    //           .map((e) => Chip(label: Text(e.toString())))
    //           .toList(),
    //     ),
    //     const Divider(
    //       height: 30,
    //     ),
    //   ],
    // );
  }
}
