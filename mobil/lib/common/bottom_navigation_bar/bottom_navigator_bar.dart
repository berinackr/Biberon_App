import 'package:biberon/common/bottom_navigation_bar/appbar.dart';
import 'package:biberon/common/bottom_navigation_bar/drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index, BuildContext context) {
    if (index == 2) {
      // TODO(umutakpinar): Burada forumun hangi sayfasındaysa o yenilenecek.
      // Örneğin forumun anasayfasındaysa RefreshForum eventi gönderilecek.
      // Ya da bir post içerisinde ise o postun yenilenmesi sağlanacak.
      // context.read<ForumBloc>().add(const RefreshForum());
    }
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: navigationShell),
      appBar: const NavigationAppBar(),
      drawer: const BottomNavigationDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(label: 'Anasayfa', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Bebeğim', icon: Icon(Icons.child_care)),
          NavigationDestination(label: 'Forum', icon: Icon(Icons.forum)),
          NavigationDestination(
            label: 'Etkinlik',
            icon: Icon(Icons.celebration),
          ),
        ],
        onDestinationSelected: (index) => _goBranch(index, context),
      ),
    );
  }
}
