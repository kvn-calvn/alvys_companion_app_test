import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabletView extends ConsumerWidget {
  final Widget child;
  const TabletView(this.child, {super.key});
  List<Widget> get tabs => [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Material(
      color: Colors.transparent,
      child: Row(
        children: [
          // Flexible(
          //     flex: 35,
          //     child: Main)
        ],
      ),
    );
  }
}
