import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class HomeScreenPregnancyStatusPercentage extends StatelessWidget {
  const HomeScreenPregnancyStatusPercentage({
    required this.viewportConstraints,
    super.key,
  });

  final BoxConstraints viewportConstraints;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: viewportConstraints.maxWidth / 2,
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: viewportConstraints.maxWidth / 2,
                height: viewportConstraints.maxWidth / 2,
                child: Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, viewport) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewport.maxWidth * 0.9,
                              minWidth: viewport.maxWidth * 0.9,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                color: Theme.of(context).colorScheme.secondary,
                                strokeCap: StrokeCap.round,
                                backgroundColor:
                                    Colors.deepOrange.getShadeColor(
                                  shadeValue: 37,
                                ),
                                value: 0.2,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Center(
                      child: Image.asset(
                        'assets/home/homescreen_cilek.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: viewportConstraints.maxWidth / 2,
                height: viewportConstraints.maxWidth / 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Bebeğiniz yaklaşık bir ',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 14,
                                  ),
                          children: [
                            TextSpan(
                              text: 'çilek',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            TextSpan(
                              text: ' kadar.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Tahmini doğum',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      Text(
                        '18.12.2024',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      Text(
                        'Doğuma',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      Text(
                        '180 gün kaldı.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: VerticalDivider(
              indent: 25,
              endIndent: 25,
              thickness: 5,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
