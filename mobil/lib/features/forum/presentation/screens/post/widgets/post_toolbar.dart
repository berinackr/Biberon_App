import 'package:biberon/features/forum/forum.dart';
import 'package:biberon/features/rich_text/presentation/editor/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class PostToolbar extends StatelessWidget {
  const PostToolbar({
    required this.controller,
    required this.editorFocusNode,
    super.key,
  });

  final QuillController controller;
  final FocusNode editorFocusNode;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MyQuillToolbar(
                controller: controller,
                focusNode: editorFocusNode,
              ),
            ),
            FilledButton(
              onPressed: () {
                context.read<PostBloc>().add(
                      PostContentRequested(
                        plainText: controller.document.toPlainText(),
                        content: controller.document.toDelta(),
                      ),
                    );
              },
              child: const Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
