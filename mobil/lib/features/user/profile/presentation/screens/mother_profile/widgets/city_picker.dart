import 'package:biberon/common/data/cities_of_turkey.dart';
import 'package:biberon/common/widgets/shared_text_input.dart';
import 'package:biberon/features/user/profile/presentation/screens/mother_profile/bloc/mother_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CityPicker extends StatelessWidget {
  const CityPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotherProfileBloc, MotherProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SharedTextInput(
            input: state.city,
            prefixIcon: Icons.location_city,
            label: 'Şehir',
            onTap: () => _showCityDropdown(context),
            readOnly: true,
            controller: TextEditingController(text: state.city.value),
            suffixIcon: state.city.isPure
                ? null
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => context.read<MotherProfileBloc>().add(
                          const DeleteUserCity(),
                        ),
                  ),
          ),
        );
      },
    );
  }

  void _showCityDropdown(BuildContext context) {
    final bloc = context.read<MotherProfileBloc>();

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: citiesOfTurkey.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(citiesOfTurkey[index]),
                onTap: () {
                  bloc.add(UpdateUserCity(index));
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
