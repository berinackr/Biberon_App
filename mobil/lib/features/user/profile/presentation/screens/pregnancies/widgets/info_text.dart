import 'package:flutter/material.dart';

class InfoTextAddNewPregnancy extends StatelessWidget {
  const InfoTextAddNewPregnancy({
    required this.isLoading,
    super.key,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLoading ? 0.5 : 1,
      child: AbsorbPointer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '''Ekranın sağ altındaki butona tıklayarak yeni bir hamilelik ekleyebilirsiniz. 🤰''',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
