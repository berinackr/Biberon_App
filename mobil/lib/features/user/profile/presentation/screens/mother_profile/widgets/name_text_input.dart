// ignore_for_file: require_trailing_commas

import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameTextInput extends StatelessWidget {
  const NameTextInput({super.key});
  @override
  Widget build(BuildContext context) {
    final nameInput = context.watch<MotherProfileBloc>().state.name;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SharedTextInput(
        input: nameInput,
        initialValue: nameInput.value,
        label: 'Kullanıcı Adı',
        onChanged: (value) =>
            context.read<MotherProfileBloc>().add(UpdateUserName(value)),
        prefixIcon: Icons.person,
        keyboardType: TextInputType.name,
      ),
    );
  }
}
