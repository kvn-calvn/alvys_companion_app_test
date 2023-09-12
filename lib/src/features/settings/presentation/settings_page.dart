import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/custom_bottom_sheet.dart';
import '../../../common_widgets/large_nav_button.dart';
import '../../../common_widgets/theme_switcher.dart';
import '../../../common_widgets/url_nav_button.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/magic_strings.dart';
import '../../../utils/platform_channel.dart';
import '../../authentication/presentation/auth_provider_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          style: AlvysTheme.appbarTextStyle(context, true),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        const SizedBox(
          height: 10,
        ),
        LargeNavButton(
          title: "Change Theme",
          onPressed: () {
            showCustomBottomSheet(context, const ThemeSwitcher());
          },
        ),
        const UrlNavButton(title: "Help", url: "https://alvys.com/help/"),
        LargeNavButton(
          title: "About",
          onPressed: () {
            context.goNamed(RouteName.about.name);
          },
        ),
        LargeNavButton(
          title: "Sign Out",
          onPressed: () {
            PlatformChannel.stopLocationTracking();
            ref.read(authProvider.notifier).signOut(context);
          },
        ),
      ],
    );
  }
}
