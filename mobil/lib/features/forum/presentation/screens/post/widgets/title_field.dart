import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/forum/forum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TitleField extends StatelessWidget {
  const TitleField({required this.titleController, super.key});
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    final input = context.select((PostBloc bloc) => bloc.state.title);
    return SharedTextInput(
      input: input,
      prefixIcon: Icons.title_rounded,
      onChanged: (value) =>
          context.read<PostBloc>().add(TitleChanged(title: value)),
      label: 'Başlık',
    );
    // return TextField(
    //   onChanged: (value) {
    //     context.read<PostBloc>().add(TitleChanged(title: value));
    //   },
    //   controller: titleController,
    //   decoration: const InputDecoration(
    //     labelText: 'Başlık',
    //   ),
    // );
  }
}
