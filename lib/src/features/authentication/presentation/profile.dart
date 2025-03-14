import 'package:alvys3/src/features/authentication/presentation/auth_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/large_nav_button.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/magic_strings.dart';
import 'auth_provider_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
          style: AlvysTheme.appbarTextStyle(context, false),
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
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userState = ref.watch(authProvider);
    final authValue = userState.authValue;

    return RefreshIndicator.adaptive(
      onRefresh: ref.read(authProvider.notifier).refreshDriverUser,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(
            height: 10,
          ),
          LargeNavButton(
            title: authValue.driver?.name ?? "User Details",
            onPressed: () {
              context.goNamed(RouteName.userDetails.name);
            },
          ),
          LargeNavButton(
            title: "Personal Documents",
            onPressed: () {
              context.goNamed(RouteName.personalDocumentsList.name);
            },
          ),
          if (authValue.canViewPaystubsAll)
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
      ),
    );
  }
}
