import 'package:alvys3/src/utils/theme_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/extensions.dart';

class ThemeSwitcher extends ConsumerStatefulWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends ConsumerState<ThemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var themeMode in ThemeMode.values)
          RadioListTile<ThemeMode>(
              value: themeMode,
              groupValue: ref.watch(themeHandlerProvider),
              title: Text("${themeMode.toTitleCase} Mode"),
              onChanged: (value) =>
                  ref.watch(themeHandlerProvider.notifier).setThemeMode(value!))
      ],
    );
  }
}
