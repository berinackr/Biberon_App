import 'package:biberon/features/forum/presentation/screens/post/bloc/post_bloc.dart';
import 'package:biberon/features/forum/presentation/screens/post/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required this.controller,
    super.key,
  });

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        context.read<PostBloc>().add(
              PostContentRequested(
                plainText: controller.document.toPlainText(),
                content: controller.document.toDelta(),
              ),
            );
      },
      child: const Text('Paylaş'),
    );
  }
}
