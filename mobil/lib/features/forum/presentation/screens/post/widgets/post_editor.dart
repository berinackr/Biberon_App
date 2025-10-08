import 'package:biberon/features/forum/forum.dart';
import 'package:biberon/features/rich_text/presentation/editor/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class PostEditor extends StatelessWidget {
  const PostEditor({
    required this.editorFocusNode,
    required this.controller,
    required this.editorScrollController,
    super.key,
  });

  final FocusNode editorFocusNode;
  final QuillController controller;
  final ScrollController editorScrollController;

  @override
  Widget build(BuildContext context) {
    final editorInput = context.watch<PostBloc>().state.plainText;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: editorInput.displayError != null
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary.withOpacity(0.7),
              width: editorFocusNode.hasFocus ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: MyQuillEditor(
            configurations: QuillEditorConfigurations(
              controller: controller,
            ),
            scrollController: editorScrollController,
            focusNode: editorFocusNode,
          ),
        ),
        if (editorInput.displayError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              editorInput.errorMessage!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
