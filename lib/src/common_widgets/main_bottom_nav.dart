import 'package:alvys3/custom_icons/alvys3_icons.dart';
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
        backgroundColor: Colors.transparent,
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
              context.goNamed(RouteName.profile.name);
              break;
            case 2:
              context.goNamed(RouteName.settings.name);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Alvys3Icons.homeIco),
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
