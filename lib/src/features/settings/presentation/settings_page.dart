import 'package:alvys3/src/common_widgets/custom_bottomSheet.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/theme_switcher.dart';
import 'package:flutter/material.dart';

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
      body: const SettingsList(),
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
        Text(
          'Sandbox Driver',
          textAlign: TextAlign.start,
        ),
        Text(
          'app@alvys.com',
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        LargeNavButton(
          title: "Profile",
          onPressed: () {},
        ),
        LargeNavButton(
          title: "My Documents",
          onPressed: () {},
        ),
        LargeNavButton(
          title: "Trip Report",
          onPressed: () {},
        ),
        LargeNavButton(
          title: "Paystubs",
          onPressed: () {},
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
          title: "Tutorial",
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
