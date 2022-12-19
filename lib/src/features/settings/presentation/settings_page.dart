import 'package:alvys3/src/common_widgets/custom_bottom_sheet.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/profile_nav_button.dart';
import 'package:alvys3/src/common_widgets/theme_switcher.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
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
        title: Text('Settings',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w700, fontSize: 30)),
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
          profileImageUrl: 'https://i.pravatar.cc/300',
          onPressed: () {
            context.pushNamed(RouteName.profile.name);
          },
        ),
        LargeNavButton(
          title: "My Documents",
          onPressed: () {
            context.pushNamed(RouteName.personalDocuments.name);
          },
        ),
        LargeNavButton(
          title: "Paystubs",
          onPressed: () {
            context.pushNamed(RouteName.paystubs.name);
          },
        ),
        LargeNavButton(
          title: "Trip Report",
          onPressed: () {
            context.pushNamed(RouteName.tripReport.name);
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
