import 'package:alvys3/src/common_widgets/custom_bottom_sheet.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/profile_nav_button.dart';
import 'package:alvys3/src/common_widgets/tenant_switcher.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

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
        title: const Text('Profile'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () =>
                  {showCustomBottomSheet(context, const TenantSwitcher())},
              padding: const EdgeInsets.only(right: 14),
              icon: const Icon(
                Symbols.change_circle,
                size: 35,
              ))
        ],
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
          tenant: "TVA Logistics",
          profileImageUrl: 'https://i.pravatar.cc/300',
          onPressed: () {
            context.pushNamed(RouteName.userDetails.name);
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
      ],
    );
  }
}
