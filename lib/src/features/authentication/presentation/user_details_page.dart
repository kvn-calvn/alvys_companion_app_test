import 'package:alvys3/src/features/authentication/presentation/auth_extension.dart';

import '../../../network/firebase_remote_config_service.dart';
import '../../../utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_theme.dart';
import 'auth_provider_controller.dart';

class UserDetailsPage extends ConsumerWidget {
  const UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var showEditProfile = ref.watch(firebaseRemoteConfigServiceProvider).showEditProfileBtn();
    var userState = ref.watch(authProvider);
    var userValue = userState.authValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        centerTitle: true,
        actions: [
          if (showEditProfile)
            IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              onPressed: () {
                context.goNamed(RouteName.editProfile.name);
              },
            ),
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        children: [
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [Avatar(profileImageUrl: 'https://i.pravatar.cc/300')],
          // ),
          // TextButton(onPressed: () {}, child: const Text("Edit Picture")),
          ProfileDetailCard(
            title: 'Full Name',
            content: userValue.driver?.name,
          ),
          ProfileDetailCard(
            title: 'Email',
            content: userValue.driver?.email,
          ),
          ProfileDetailCard(
            title: 'Phone',
            content: userValue.driver?.phone,
          ),
          ProfileDetailCard(
            title: 'Tenant(s)',
            content: userValue.driver?.companyCodesWithSpace,
          ),
          ProfileDetailCard(
            title: 'Address',
            content: userValue.driver?.address?.formattedAddress,
          ),
          ProfileDetailCard(
            title: 'License #',
            content: userValue.driver?.driversLicenceNumber,
          ),
          ProfileDetailCard(
            title: 'License Expiration Date',
            content: DateFormat('MMM d, yyyy', 'en_US').formatNullDate(
              userValue.driver?.driversLicenceExpirationDate,
            ),
          ),
          ProfileDetailCard(
            title: 'License Issue State',
            content: userValue.driver?.driversLicenceState,
          ),
        ],
      ),
    );
  }
}

class ProfileDetailCard extends StatelessWidget {
  final String title;
  final String? content;
  const ProfileDetailCard({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          content ?? "N/A",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
