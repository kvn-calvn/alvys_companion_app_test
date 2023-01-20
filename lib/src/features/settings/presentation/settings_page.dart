import 'package:alvys3/src/common_widgets/custom_bottom_sheet.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/profile_nav_button.dart';
import 'package:alvys3/src/common_widgets/theme_switcher.dart';
import 'package:alvys3/src/common_widgets/url_nav_button.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        title: const Text('Settings'),
        centerTitle: false,
        elevation: 0,
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
        ProfileNavButton(
          title: "Sandbox Driver",
          profileImageUrl: 'https://i.pravatar.cc/300',
          onPressed: () {
            context.pushNamed(RouteName.profile.name);
          },
        ),
        LargeNavButton(
          title: "My Documents",
          onPressed: () {
            context.goNamed(RouteName.personalDocumentsList.name);
          },
        ),
        LargeNavButton(
          title: "Paystubs",
          onPressed: () {
            context.goNamed(RouteName.paystubs.name);
          },
        ),
        LargeNavButton(
          title: "Trip Report",
          onPressed: () {
            context.pushNamed(RouteName.tripReportDocumentList.name);
          },
        ),
        const SizedBox(
          height: 15,
        ),
        LargeNavButton(
          title: "Change Theme",
          onPressed: () {
            showCustomBottomSheet(context, const ThemeSwitcher());
          },
        ),
        LargeNavButton(
          title: "About",
          onPressed: () {
            context.pushNamed(RouteName.about.name);
          },
        ),
        const UrlNavButton(title: "Help", url: "https://alvys.com/help/"),
        LargeNavButton(
          title: "Sign Out",
          onPressed: () {
            ref.read(authProvider.notifier).signOut(context);
          },
        ),
      ],
    );
  }
}
