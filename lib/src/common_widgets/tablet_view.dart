import 'package:alvys3/src/common_widgets/main_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_icons/alvys3_icons.dart';

class TabletView extends ConsumerWidget {
  final Widget child;
  const TabletView(this.child, {super.key});
  List<Widget> get tabs => [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          Flexible(
              flex: 35,
              child: Scaffold(
                body: tabs[ref.watch(bottomNavIndexProvider)],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: ref.watch(bottomNavIndexProvider),
                  onTap: (i) {
                    ref
                        .read(bottomNavIndexProvider.notifier)
                        .update((state) => i);
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Alvys3Icons.homeIco),
                      label: 'Trips',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
