import '../features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../custom_icons/alvys3_icons.dart';
import '../features/authentication/presentation/profile.dart';
import '../features/trips/presentation/pages/trips_page.dart';

class TabletView extends ConsumerWidget {
  final StatefulNavigationShell navShell;
  final List<Widget> children;
  const TabletView(this.navShell, this.children, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          const Flexible(flex: 4, child: TabletLeftNav()),
          Flexible(flex: 6, child: children[navShell.currentIndex])
        ],
      ),
    );
  }
}

class TabletLeftNav extends ConsumerStatefulWidget {
  const TabletLeftNav({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabletLeftNavState();
}

class _TabletLeftNavState extends ConsumerState<TabletLeftNav> {
  var pages = <Widget>[const LoadListPage(), const ProfilePage(), const SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[ref.watch(tabletViewProvider)],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.read(tabletViewProvider),
        onTap: ref.read(tabletViewProvider.notifier).setState,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Alvys3Icons.tripIcon),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

final tabletViewProvider = NotifierProvider<TabletViewNotifier, int>(TabletViewNotifier.new);

class TabletViewNotifier extends Notifier<int> {
  @override
  int build() {
    state = 0;
    return state;
  }

  void setState(int x) => state = x;
}
