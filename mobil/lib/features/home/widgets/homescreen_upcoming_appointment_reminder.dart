import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class HomescreenUpcomingAppointmentReminder extends StatelessWidget {
  const HomescreenUpcomingAppointmentReminder({
    required this.viewportConstraints,
    this.horizontalPadding = 20,
    super.key,
  });

  final BoxConstraints viewportConstraints;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            bottom: horizontalPadding / 2,
          ),
          child: Text(
            'Yaklaşan Doktor Randevunuz',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        DottedBorder(
          color: Theme.of(context).colorScheme.secondary,
          borderType: BorderType.RRect,
          dashPattern: const [8, 6, 8, 6],
          radius: const Radius.circular(20),
          borderPadding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      (viewportConstraints.maxWidth / 3) - horizontalPadding,
                ),
                child: Image.asset(
                  'assets/icon.png',
                  fit: BoxFit.fill,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: (viewportConstraints.maxWidth * 2 / 3) -
                      horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '17.03.24',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    Text(
                      'Üçlü Tarama Testi',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Hamileliğin 16. haftasında yapılır.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
