// ignore_for_file: unused_local_variable

import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/forum/domain/models/forum_post_model.dart';
import 'package:biberon/features/forum/presentation/screens/post/post.dart';
import 'package:biberon/features/forum/presentation/screens/post/widgets/widgets.dart';
import 'package:biberon/features/rich_text/presentation/editor/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:formz/formz.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({required this.selectedPost, super.key});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
  final Post selectedPost;
}

class _EditPostPageState extends State<EditPostPage> {
  final titleController = TextEditingController();
  final _controller = QuillController.basic();
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.document = Document();
    _controller.document.insert(0, widget.selectedPost.body);
    titleController.text = widget.selectedPost.title!;
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PostBloc>().state;
    final isLoading = context.select(
          (PostBloc bloc) => bloc.state.status,
        ) ==
        FormzSubmissionStatus.inProgress;
    return BlocListener<PostBloc, PostState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          Toast.showToast(
            context,
            state.errorMessage ?? 'Bir sorun oluştu. Lütfen tekrar deneyin.',
            ToastType.error,
          );
        } else if (state.status == FormzSubmissionStatus.success) {
          Toast.showToast(
            context,
            'Forum İçeriği Başarıyla Düzenlendi.',
            ToastType.success,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            MenuAnchor(
              builder: (context, controller, child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                      return;
                    }
                    controller.open();
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                );
              },
              menuChildren: [
                MenuItemButton(
                  onPressed: () {},
                  child: const Text('Load with HTML'),
                ),
              ],
            ),
            IconButton(
              tooltip: 'Print to log',
              onPressed: () {},
              icon: const Icon(Icons.print),
            ),
          ],
        ),
        body: Column(
          children: [
            TitleField(
              titleController: titleController,
            ),
            const SizedBox(height: 8),
            // EditPostTagSelection(tagsForEdit: widget.selectedPost.tags!),
            MyQuillToolbar(
              controller: _controller,
              focusNode: _editorFocusNode,
            ),
            Builder(
              builder: (context) {
                return Expanded(
                  child: MyQuillEditor(
                    configurations: QuillEditorConfigurations(
                      controller: _controller,
                    ),
                    scrollController: _editorScrollController,
                    focusNode: _editorFocusNode,
                  ),
                );
              },
            ),
            EditPostButton(
              controller: _controller,
              selectedPost: widget.selectedPost,
            ),
          ],
        ),
      ),
    );
  }
}
