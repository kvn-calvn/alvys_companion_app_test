import '../utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import '../network/posthog/posthog_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/http_client.dart';
import '../utils/extensions.dart';
import '../utils/theme_handler.dart';

class ThemeSwitcher extends ConsumerStatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends ConsumerState<ThemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var themeMode in ThemeMode.values)
        RadioListTile<ThemeMode>(
          value: themeMode,
          groupValue: ref.watch(themeHandlerProvider),
          title: Text("${themeMode.toTitleCase} Mode"),
          onChanged: (value) async {
            ref.watch(themeHandlerProvider.notifier).setThemeMode(value!);
            Navigator.of(context, rootNavigator: true).pop();
            ref.read(postHogProvider).postHogTrackEvent(PosthogTag.userChangedTheme.toSnakeCase, {"theme": value.name});
            ref
                .read(httpClientProvider)
                .telemetryClient
                .trackEvent(name: "app_theme_changed", additionalProperties: {"theme": value.name});
            await FirebaseAnalytics.instance.logEvent(name: "app_theme_changed", parameters: {"theme": value.name});
          },
        )
    ]);
  }
}
