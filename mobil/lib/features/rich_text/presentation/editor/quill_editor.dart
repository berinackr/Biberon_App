import 'package:biberon/features/rich_text/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MyQuillEditor extends StatelessWidget {
  const MyQuillEditor({
    required this.configurations,
    required this.scrollController,
    required this.focusNode,
    super.key,
  });

  final QuillEditorConfigurations configurations;
  final ScrollController scrollController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      scrollController: scrollController,
      focusNode: focusNode,
      configurations: configurations.copyWith(
        customStyles: DefaultStyles(
          placeHolder: DefaultTextBlockStyle(
            Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  // make italic
                  fontStyle: FontStyle.italic,
                ),
            const VerticalSpacing(10, 10),
            const VerticalSpacing(10, 10),
            const BoxDecoration(),
          ),
          lists: DefaultListBlockStyle(
            Theme.of(context).textTheme.bodyLarge!,
            const VerticalSpacing(5, 0),
            const VerticalSpacing(5, 0),
            null,
            null,
          ),
          paragraph: DefaultListBlockStyle(
            Theme.of(context).textTheme.bodyLarge!,
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            null,
            null,
          ),
          leading: DefaultTextBlockStyle(
            Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            const BoxDecoration(),
          ),
          link: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
          quote: DefaultTextBlockStyle(
            Theme.of(context).textTheme.bodyMedium!,
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
              ),
            ),
          ),
        ),
        expands: false,
        scrollable: true,
        minHeight: 200,
        maxHeight: 200,
        autoFocus: true,
        placeholder: 'Sorunuzu buraya yazınız...',
        embedBuilders: [
          MentionEmbedBuilder(
            onMentionTap: (context, mentionData) => {},
          ),
        ],
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
