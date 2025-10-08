// import 'package:biberon/features/forum/domain/models/forum_tag_model.dart';
// import 'package:biberon/features/forum/presentation/screens/post/bloc/post_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EditPostTagSelection extends StatefulWidget {
//   const EditPostTagSelection({required this.tagsForEdit, super.key});
//   final List<Tag> tagsForEdit;
//   @override
//   State<EditPostTagSelection> createState() => _EditPostTagSelectionState();
// }

// class _EditPostTagSelectionState extends State<EditPostTagSelection> {
//   List<dynamic> _selectedTags = [];

//   @override
//   void initState() {
//     super.initState();
//     _selectedTags = widget.tagsForEdit.map((tag) => tag.name).toList();
//     _selectedTags = _selectedTags.toSet().toList();
//     context
//         .read<PostBloc>()
//         .add(Tag); // Remove duplicates
//   }

//   Future<void> _showMultiSelect() async {
//     final tags = forumTags.map((tag) => tag['name']).toList();
//     // ignore: cascade_invocations
//     tags.removeAt(0);

//     // ignore: inference_failure_on_function_invocation
//     final results = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return EditPostMultiSelect(
//           items: tags,
//           selectedTags: List.from(_selectedTags),
//           tagsForEdit: widget.tagsForEdit,
//         );
//       },
//     );

//     if (results != null) {
//       setState(() {
//         _selectedTags = results as List<dynamic>;
//       });
//       _selectedTags = _selectedTags.toSet().toList(); // Remove duplicates
//       // ignore: use_build_context_synchronously
//       context.read<PostBloc>().add(TagsChanged(tags: _selectedTags));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ElevatedButton(
//           onPressed: _showMultiSelect,
//           child: const Text('Etiket Seçiniz'),
//         ),
//         Wrap(
//           children: _selectedTags
//               .map((e) => Chip(label: Text(e.toString())))
//               .toList(),
//         ),
//         const Divider(
//           height: 30,
//         ),
//       ],
//     );
//   }
// }
