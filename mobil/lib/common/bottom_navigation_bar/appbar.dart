import 'package:biberon/features/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Merhaba,',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                user?.username ?? '',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.white,
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/icon.png',
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// BiberonApp default AppBar height : 80
  @override
  Size get preferredSize => const Size(double.maxFinite, 56);
}
