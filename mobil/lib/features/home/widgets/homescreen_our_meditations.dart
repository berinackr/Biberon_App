import 'package:biberon/common/utils/snackbar.dart';
import 'package:flutter/material.dart';

class OurMeditations extends StatelessWidget {
  const OurMeditations({
    required this.viewportConstraints,
    super.key,
  });

  final BoxConstraints viewportConstraints;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meditasyonlarımız',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Toast.showToast(
                    context,
                    'Meditasyonlarımız',
                    ToastType.success,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Meditasyon için hazır mısın?',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              '''Bebeğin ve kendin için iyilik yap, rahatlatıcı meditasyonlarla tanış.''',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            onTap: () {
              Toast.showToast(
                context,
                'Meditasyonlarımız',
                ToastType.success,
              );
            },
            splashFactory: NoSplash.splashFactory,
            child: SizedBox(
              width: viewportConstraints.maxWidth / 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Image.asset(
                  fit: BoxFit.fill,
                  'assets/home/meditation.png',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 40,
              bottom: 40,
            ),
            child: InkWell(
              onTap: () {
                Toast.showToast(
                  context,
                  'Meditasyonlarımız',
                  ToastType.success,
                );
              },
              child: Icon(
                color: Theme.of(context).colorScheme.secondary,
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
