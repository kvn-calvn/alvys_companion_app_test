import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tablet extends ConsumerWidget {
  final Widget left, right;
  const Tablet({required this.left, required this.right, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Flexible(flex: 35, child: left),
        Flexible(flex: 65, child: right)
      ],
    );
  }
}
