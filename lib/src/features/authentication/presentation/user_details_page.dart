import '../../../utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_theme.dart';
import 'auth_provider_controller.dart';

class UserDetailsPage extends ConsumerWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        centerTitle: true,
        leading: IconButton(
          // 1
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
            ),
            onPressed: () {
              debugPrint('IconButton pressed ...');
              context.goNamed(RouteName.editProfile.name);
            },
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: ListView(children: [
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [Avatar(profileImageUrl: 'https://i.pravatar.cc/300')],
          // ),
          // TextButton(onPressed: () {}, child: const Text("Edit Picture")),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileDetailCard(title: 'Full Name', content: userState.value!.driver!.name),
              ProfileDetailCard(title: 'Email', content: userState.value!.driver!.email),
              ProfileDetailCard(title: 'Phone', content: userState.value!.driver!.phone),
              ProfileDetailCard(title: 'Tenant(s)', content: userState.value!.driver!.companyCodesWithSpace),
              ProfileDetailCard(title: 'Address', content: userState.value!.driver!.address?.formattedAddress),
              ProfileDetailCard(title: 'License #', content: userState.value!.driver!.driversLicenceNumber),
              ProfileDetailCard(
                  title: 'License Expiration Date',
                  content: DateFormat('MMM d, yyyy', 'en_US')
                      .formatNullDate(userState.value!.driver!.driversLicenceExpirationDate)),
              ProfileDetailCard(title: 'License Issue State', content: userState.value!.driver!.driversLicenceState),
            ],
          )
        ]),
      ),
    );
  }
}

class ProfileDetailCard extends StatelessWidget {
  final String title;
  final String? content;
  const ProfileDetailCard({super.key, required this.title, required this.content});

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
