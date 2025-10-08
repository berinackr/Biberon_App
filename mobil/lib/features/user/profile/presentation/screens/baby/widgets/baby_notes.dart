// ignore_for_file: unrelated_type_equality_checks

import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BabyNotes extends StatefulWidget {
  const BabyNotes({
    required this.state,
    super.key,
  });

  final BabyState state;

  @override
  State<BabyNotes> createState() => _BabyNotesState();
}

class _BabyNotesState extends State<BabyNotes> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BabyBloc, BabyState>(
      buildWhen: (previous, current) => previous.notes != current.notes,
      builder: (context, state) {
        if (_controller.text != state.notes) {
          _controller.text = state.notes?.value ?? '';
        }
        return Column(
          children: [
            const HeaderText(title: 'Notlar : '),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                errorText: state.notes?.errorMessage,
                hintText: 'Notlarınızı buraya yazabilirsiniz...',
              ),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
              onChanged: (value) {
                context
                    .read<BabyBloc>()
                    .add(BabyEventNotesChanged(value.isEmpty ? null : value));
              },
            ),
          ],
        );
      },
    );
  }
}
