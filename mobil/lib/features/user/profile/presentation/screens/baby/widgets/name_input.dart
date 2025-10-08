// ignore_for_file: unrelated_type_equality_checks

import 'package:biberon/features/user/profile/presentation/screens/baby/bloc/baby_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/baby/widgets/text_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameTextInput extends StatefulWidget {
  const NameTextInput({
    required this.state,
    super.key,
  });

  final BabyState state;

  @override
  // ignore: library_private_types_in_public_api
  _NameTextInputState createState() => _NameTextInputState();
}

class _NameTextInputState extends State<NameTextInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.state.name.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BabyBloc, BabyState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        if (_controller.text != state.name) {
          _controller.text = state.name.value;
        }
        return Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderText(title: 'İsim :'),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          context
                              .read<BabyBloc>()
                              .add(BabyEventNameChanged(value));
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorText: state.name.errorMessage,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
