import 'package:alvys3/src/features/documents/presentation/upload_documents_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

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
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(bottomNavIndexProvider),
        onTap: (i) {
          if (ref.read(scanningProvider)) return;
          ref.read(bottomNavIndexProvider.notifier).update((state) => i);

          switch (i) {
            case 0:
              context.goNamed(RouteName.trips.name);
              break;
            case 1:
              context.goNamed(RouteName.notifications.name);
              break;
            case 2:
              context.goNamed(RouteName.settings.name);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Symbols.local_shipping), //Icon(Alvys3Icons.homeIco),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.notifications),
            label: 'Notifications',
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
