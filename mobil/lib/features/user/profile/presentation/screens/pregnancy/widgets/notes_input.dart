import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PregnancyNotes extends StatefulWidget {
  const PregnancyNotes({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  State<PregnancyNotes> createState() => _PregnancyNotesState();
}

class _PregnancyNotesState extends State<PregnancyNotes> {
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
    return BlocBuilder<PregnancyBloc, PregnancyState>(
      buildWhen: (previous, current) => previous.notes != current.notes,
      builder: (context, state) {
        if (_controller.text != state.notes) {
          _controller.text = state.notes ?? '';
        }
        return Column(
          children: [
            const HeaderText(title: 'Notlar : '),
            const SizedBox(height: 10),
            TextFormField(
              enabled: widget.state.isActive,
              controller: _controller,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Notlarınızı buraya yazabilirsiniz...',
              ),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
              onChanged: (value) {
                context
                    .read<PregnancyBloc>()
                    .add(FieldChangedNotes(value.isEmpty ? null : value));
              },
            ),
          ],
        );
      },
    );
  }
}
