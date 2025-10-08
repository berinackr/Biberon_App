// ignore_for_file: use_named_constants

import 'package:biberon/common/data/forum_tags.dart';
import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/common/widgets/spaced_container.dart';
import 'package:biberon/core/colors.dart';
import 'package:biberon/features/forum/forum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagSelectionPage extends StatefulWidget {
  const TagSelectionPage({super.key});

  @override
  State<TagSelectionPage> createState() => _TagSelectionPageState();
}

class _TagSelectionPageState extends State<TagSelectionPage> {
  void showHighThanTwoError() {
    Toast.showToast(
      context,
      'En fazla iki etiket seçebilirsiniz',
      ToastType.error,
    );
  }

  var _searchText = '';
  @override
  Widget build(BuildContext context) {
    final forumTags = context.watch<PostBloc>().state.tags;
    final filteredTags = ForumTags.filterTagsByName(_searchText);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etiketler'),
        centerTitle: true,
      ),
      body: SpacedContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Etiket ara',
                    isDense: true,
                    suffixIcon: Icon(
                      Icons.search,
                      size: 32,
                      color: CustomColors.iconColor.withOpacity(0.5),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      maxHeight: 48,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              ...filteredTags.map((tag) {
                return ListTileTheme(
                  horizontalTitleGap: 0,
                  dense: true,
                  child: CheckboxListTile(
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    side: const BorderSide(color: Colors.grey),
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      tag.name!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: forumTags.value.contains(tag.id),
                    onChanged: (bool? value) {
                      if ((value ?? false) && forumTags.value.length == 2) {
                        showHighThanTwoError();
                      } else {
                        context.read<PostBloc>().add(TagChanged(tag.id!));
                      }
                    },
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
