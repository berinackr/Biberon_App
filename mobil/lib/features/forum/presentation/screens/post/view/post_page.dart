// ignore_for_file: unused_local_variable, lines_longer_than_80_chars

import 'dart:convert';

import 'package:biberon/common/utils/snackbar.dart';
import 'package:biberon/features/forum/presentation/screens/post/post.dart';
import 'package:biberon/features/forum/presentation/screens/post/widgets/widgets.dart';
import 'package:biberon/features/rich_text/presentation/widgets/rendered_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final titleController = TextEditingController();
  final _controller = QuillController.basic();
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();
  final _scrollControllerView = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.document = Document();
    _editorFocusNode.addListener(() {
      setState(() {});
    });
    _controller.changes.listen((event) {
      setState(() {});
      context.read<PostBloc>().add(
            PlainTextChanged(
              plainText: _controller.document.toPlainText(),
            ),
          );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    _scrollControllerView.dispose();
    // dispose listener on focus node
    _editorFocusNode.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final editorInput = context.select(
      (PostBloc bloc) => bloc.state.plainText,
    );
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
            'Forum İçeriği Başarıyla Oluşturuldu.',
            ToastType.success,
          );
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              tooltip: 'Print to log',
              onPressed: () {
                context
                    .read<Talker>()
                    .log(jsonEncode(_controller.document.toDelta().toJson()));
              },
              icon: const Icon(Icons.print),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                controller: _scrollControllerView,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    TitleField(
                      titleController: titleController,
                    ),
                    const SizedBox(height: 8),
                    PostEditor(
                      editorFocusNode: _editorFocusNode,
                      controller: _controller,
                      editorScrollController: _editorScrollController,
                    ),
                    const SizedBox(height: 8),
                    const TagSelection(),
                    const SizedBox(height: 8),
                    SubmitButton(controller: _controller),
                    const SizedBox(
                      height: 50,
                    ),
                    RenderedRichText(
                      deltaJson:
                          jsonEncode(_controller.document.toDelta().toJson()),
                    ),
                  ],
                ),
              ),
            ),
            if (keyboardHeight > 0 && _editorFocusNode.hasFocus)
              PostToolbar(
                controller: _controller,
                editorFocusNode: _editorFocusNode,
              ),
          ],
        ),
      ),
    );
  }

  // Future<void> _addEditMention(BuildContext context) async {
  //   // Logic to choose a user to mention, e.g., open a dialog
  //   final selectedUser = await showMentionDialog(context);
  //   if (selectedUser == null) return;

  //   final mentionData = MentionData(selectedUser['id']!, selectedUser['name']!);

  //   final block = Embeddable(MentionBlockEmbed.mentionType, {
  //     'id': mentionData.id,
  //     'name': mentionData.name,
  //   });

  //   final controller = _controller;
  //   final index = controller.selection.baseOffset;
  //   final length = controller.selection.extentOffset - index;

  //   controller.replaceText(index, length, block, null);
  // }

  // Future<Map<String, String>?> showMentionDialog(BuildContext context) async {
  //   final searchController = TextEditingController();
  //   var users =
  //       <Map<String, String>>[]; // Replace with your user fetching logic
  //   var filteredUsers = <Map<String, String>>[];

  //   // Mock data for demonstration; replace with real user data fetching
  //   users = [
  //     {'id': '1', 'name': 'John Doe'},
  //     {'id': '2', 'name': 'Jane Smith'},
  //     {'id': '3', 'name': 'Sam Wilson'},
  //   ];

  //   void filterUsers(String query) {
  //     filteredUsers = users
  //         .where(
  //           (user) => user['name']!.toLowerCase().contains(query.toLowerCase()),
  //         )
  //         .toList();
  //   }

  //   filterUsers('');

  //   return showDialog<Map<String, String>?>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Mention a User'),
  //       content: SizedBox(
  //         width: double.maxFinite, // Makes the dialog adapt to the content
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: searchController,
  //               decoration: const InputDecoration(
  //                 hintText: 'Search for a user...',
  //               ),
  //               onChanged: (query) {
  //                 filterUsers(query);
  //                 (context as Element).markNeedsBuild(); // Rebuild the dialog
  //               },
  //             ),
  //             const SizedBox(height: 10),
  //             Flexible(
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: filteredUsers.length,
  //                 itemBuilder: (context, index) {
  //                   final user = filteredUsers[index];
  //                   return ListTile(
  //                     title: Text(user['name']!),
  //                     onTap: () => Navigator.of(context).pop(user),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Cancel'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
