import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import '../../../network/posthog/posthog_provider.dart';

import '../../trips/presentation/controller/trip_page_controller.dart';
import '../../../utils/tablet_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/custom_bottom_sheet.dart';
import '../../../common_widgets/large_nav_button.dart';
import '../../../common_widgets/tablet_view.dart';
import '../../../common_widgets/theme_switcher.dart';
import '../../../common_widgets/url_nav_button.dart';
import '../../../network/firebase_remote_config_service.dart';
import '../../../network/http_client.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/magic_strings.dart';
import '../../authentication/presentation/auth_provider_controller.dart';
import '../../tutorial/tutorial_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: AlvysTheme.appbarTextStyle(context, false),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SettingsList(),
      ),
    );
  }
}

class SettingsList extends ConsumerWidget {
  const SettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        const SizedBox(
          height: 10,
        ),
        LargeNavButton(
          title: "Theme",
          onPressed: () {
            showCustomBottomSheet(context, const ThemeSwitcher(), constrain: true);
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            var alvysHelp = ref.watch(firebaseRemoteConfigServiceProvider).alvysHelpUrl();
            return UrlNavButton(title: "Help", url: alvysHelp);
          },
        ),
        //const UrlNavButton(title: "Help", url: "https://alvys.com/help/"),
        LargeNavButton(
          title: "About",
          onPressed: () {
            context.goNamed(RouteName.about.name);
          },
        ),
        LargeNavButton(
          title: "Tutorial",
          onPressed: () async {
            ref.read(firstInstallProvider.notifier).setState(true);
            if (TabletUtils.instance.isTablet) {
              ref.invalidate(tripControllerProvider);
              ref.read(tabletViewProvider.notifier).setState(0);
            } else {
              context.goNamed(RouteName.trips.name);
            }
            ref.read(postHogProvider).postHogTrackEvent(PosthogTag.tutorialButtonTapped.toSnakeCase, null);

            ref.read(httpClientProvider).telemetryClient.trackEvent(name: "watch_tutorial");
            await FirebaseAnalytics.instance.logEvent(name: "watch_tutorial");
          },
        ),
        LargeNavButton(
          title: "Sign Out",
          onPressed: () async {
            ref.read(postHogProvider).postHogTrackEvent(PosthogTag.userSignedOut.toSnakeCase, null);
            if (context.mounted) {
              ref.read(authProvider.notifier).signOut(context);
            }
            ref.read(postHogProvider).reset();
            ref.read(httpClientProvider).telemetryClient.trackEvent(name: "signed_out");
            await FirebaseAnalytics.instance.logEvent(name: "signed_out");
          },
        ),
      ],
    );
  }
}
