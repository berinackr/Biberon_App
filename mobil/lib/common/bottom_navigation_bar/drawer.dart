import 'package:biberon/common/app/router/app_routes.dart';
import 'package:biberon/core/di.dart';
import 'package:biberon/features/authentication/authentication.dart';
import 'package:biberon/features/home/bloc/home_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationDrawer extends StatelessWidget {
  const BottomNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final id = context.read<AuthenticationBloc>().state.user?.id;
    return SafeArea(
      top: false,
      child: Drawer(
        shape: const Border(),
        width: 240,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'USER_ID: $id',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  title: const Text('Profil'),
                  onTap: () {
                    context.pushNamed(AppRoutes.motherProfile);
                  },
                ),
                ListTile(
                  title: const Text('Hamileliklerim'),
                  onTap: () {
                    context.pushNamed(AppRoutes.pregnancies);
                  },
                ),
                ListTile(
                  title: const Text('Bebeklerim'),
                  onTap: () {
                    context.pushNamed(AppRoutes.babies);
                  },
                ),
                ListTile(
                  title: const Text('Forum Main'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Post'),
                  onTap: () {
                    context.pushNamed(AppRoutes.post);
                  },
                ),
                ListTile(
                  title: const Text('Profiller'),
                  onTap: () => context.pushNamed(AppRoutes.profilesScreen),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Kullanıcı Bilgisi',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () async {
                      await getIt<Dio>(instanceName: 'client')
                          .get<Map<String, dynamic>>('auth/me');
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Çıkış Yap',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      context.read<HomeBloc>().add(const SignOutRequested());
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
