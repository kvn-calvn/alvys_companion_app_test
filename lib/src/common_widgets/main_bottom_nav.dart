import '../features/tutorial/tutorial_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../custom_icons/alvys3_icons.dart';
import '../features/documents/presentation/upload_documents_controller.dart';
import '../utils/alvys_websocket.dart';

class MainBottomNav extends ConsumerStatefulWidget {
  const MainBottomNav({
    required this.navShell,
    required this.children,
    Key? key,
  }) : super(key: key);

  final StatefulNavigationShell navShell;
  final List<Widget> children;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends ConsumerState<MainBottomNav> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(tutorialProvider).startTutorial(context);
      await ref.read(websocketProvider).restartConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.children[widget.navShell.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navShell.currentIndex,
        onTap: (i) {
          if (ref.read(scanningProvider)) return;
          widget.navShell.goBranch(i, initialLocation: widget.navShell.currentIndex == i);
          // ref.read(bottomNavIndexProvider.notifier).update((state) => i);

          // switch (i) {
          //   case 0:
          //     context.goNamed(RouteName.trips.name);
          //     break;
          //   case 1:
          //     context.goNamed(RouteName.profile.name);
          //     break;
          //   case 2:
          //     context.goNamed(RouteName.settings.name);
          // }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Alvys3Icons.tripIcon),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Symbols.person,
              key: ref.read(tutorialProvider).profileButton,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Symbols.settings,
              key: ref.read(tutorialProvider).settingsButton,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
