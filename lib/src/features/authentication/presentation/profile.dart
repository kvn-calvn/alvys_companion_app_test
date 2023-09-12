import '../../../utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/large_nav_button.dart';
import '../../../common_widgets/profile_nav_button.dart';
import '../../../utils/magic_strings.dart';
import 'auth_provider_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ProfileList(),
      ),
    );
  }
}

class ProfileList extends ConsumerWidget {
  const ProfileList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userState = ref.watch(authProvider);
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        const SizedBox(
          height: 10,
        ),
        ProfileNavButton(
          title: userState.value!.driver!.name!,
          profileImageUrl: 'https://i.pravatar.cc/300',
          onPressed: () {
            context.goNamed(RouteName.userDetails.name);
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
            context.goNamed(RouteName.tripReportDocumentList.name);
          },
        ),
      ],
    );
  }
}
