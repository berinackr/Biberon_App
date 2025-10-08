import 'package:biberon/features/user/profile/presentation/screens/pregnancy/bloc/pregnancy_bloc.dart';
import 'package:biberon/features/user/profile/presentation/screens/pregnancy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryType extends StatelessWidget {
  const DeliveryType({
    required this.state,
    super.key,
  });

  final PregnancyState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HeaderText(title: 'Doğum Tipi :'),
        const SizedBox(width: 20),
        DropdownButton(
          value: state.deliveryType,
          items: lDeliveryType
              .map<DropdownMenuItem<String>>(
                (String deliveryType) => DropdownMenuItem(
                  value: deliveryType,
                  child: Text(
                    deliveryType.toTurkishDeliveryType,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                  ),
                ),
              )
              .toList(),
          onChanged: state.isActive == null || state.isActive!
              ? (String? value) {
                  context.read<PregnancyBloc>().add(
                        FieldChangedDeliveryType(value),
                      );
                }
              : null,
        ),
      ],
    );
  }
}
