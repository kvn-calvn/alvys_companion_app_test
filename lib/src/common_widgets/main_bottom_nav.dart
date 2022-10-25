import 'package:alvys3/src/constants/color.dart';
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
              context.go('/trips');
              break;
            case 1:
              context.go('/settings');
              break;
          }
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: ColorManager.primary,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.drive_eta_rounded,
                // color: Colors.grey,
              ),
              label: 'Trips'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                // color: Colors.grey,
              ),
              label: 'Settings'),
        ],
      ),
    );
  }
}
