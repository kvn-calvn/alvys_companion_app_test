import 'package:alvys3/custom_icons/alvys3_icons.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final bottomNavIndexProvider = StateProvider((ref) => 0);

class MainBottomNav extends ConsumerStatefulWidget {
  const MainBottomNav({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends ConsumerState<MainBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(bottomNavIndexProvider),
        onTap: (i) {
          ref.read(bottomNavIndexProvider.notifier).update((state) => i);

          switch (i) {
            case 0:
              context.goNamed(RouteName.trips.name);
              break;
            case 1:
              context.goNamed(RouteName.settings.name);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Alvys3Icons.homeIco,
              ),
              label: 'Trips'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Settings'),
        ],
      ),
    );
  }
}
