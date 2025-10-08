import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:biberon/features/forum/forum.dart';
import 'package:biberon/features/forum/presentation/screens/post/bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditPostButton extends StatelessWidget {
  const EditPostButton({
    required this.controller,
    required this.selectedPost,
    super.key,
  });
  final Post selectedPost;
  final QuillController controller;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        context.read<PostBloc>().add(
              EditPostRequested(
                id: selectedPost.id,
                plainText: controller.document.toPlainText(),
              ),
            );
      },
      child: const Text('Düzenle'),
    );
  }
}
