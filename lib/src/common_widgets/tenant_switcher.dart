import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TenantSwitcher extends ConsumerStatefulWidget {
  const TenantSwitcher({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TenantSwitcherState();
}

class _TenantSwitcherState extends ConsumerState<TenantSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
            value: "TVA Logistics",
            groupValue: "tenant",
            title: const Text("TVA Logistics"),
            onChanged: (value) {}),
        RadioListTile(
            value: "Calvin Logistics",
            groupValue: "tenant",
            title: const Text("Calvin Logistics"),
            onChanged: (value) {})
      ],
    );
  }
}
