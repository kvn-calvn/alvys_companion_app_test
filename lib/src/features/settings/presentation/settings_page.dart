import 'package:alvys3/src/common_widgets/custom_bottom_sheet.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/profile_nav_button.dart';
import 'package:alvys3/src/common_widgets/theme_switcher.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const SettingsList(),
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        const SizedBox(
          height: 10,
        ),
        ProfileNavButton(
          title: "Sandbox Driver",
          profileImageUrl: 'https://via.placeholder.com/150',
          onPressed: () {
            context.pushNamed(RouteName.profile.name);
          },
        ),
        LargeNavButton(
          title: "My Documents",
          onPressed: () {},
        ),
        LargeNavButton(
          title: "Paystubs",
          onPressed: () {},
        ),
        LargeNavButton(
          title: "Trip Report",
          onPressed: () {},
        ),
        const SizedBox(
          height: 15,
        ),
        LargeNavButton(
          title: "Change Theme",
          onPressed: () {
            showCustomBottomSheet(context, const ThemeSwitcher(),
                title: const Text('Change Theme'));
          },
        ),
        LargeNavButton(
          title: "About",
          onPressed: () {},
        ),
        LargeNavButton(
          title: "Help",
          onPressed: () {},
        ),
        LargeNavButton(
          title: "Sign Out",
          onPressed: () {},
        ),
      ],
    );
  }
}
