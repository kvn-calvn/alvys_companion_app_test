import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
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
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          textAlign: TextAlign.start,
          style: getBoldStyle(color: ColorManager.darkgrey, fontSize: 20),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      body: SettingsList(),
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
          style: getMediumStyle(color: ColorManager.darkgrey, fontSize: 18),
        ),
        Text(
          'app@alvys.com',
          textAlign: TextAlign.start,
          style: getMediumStyle(color: ColorManager.darkgrey, fontSize: 18),
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
