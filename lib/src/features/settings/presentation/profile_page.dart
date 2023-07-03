import 'package:alvys3/src/common_widgets/avatar.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/utils/app_theme.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
            },
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Avatar(profileImageUrl: 'https://i.pravatar.cc/300')
            ],
          ),
          TextButton(onPressed: () {}, child: const Text("Edit Picture")),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Full Name',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                userState.value!.driver!.name!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Email',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                userState.value!.driver!.email!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Phone',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                userState.value!.driver!.phone!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Tenant (s)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                userState.value!.driver!.userTenants.last.companyCode!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Address',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                userState.value!.driver!.address!.street!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "${userState.value!.driver!.address!.city}, ${userState.value!.driver!.address!.state!} ${userState.value!.driver!.address!.zip!}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'License #',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                userState.value!.driver!.driversLicenceNumber!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'License Expiration Date',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                DateFormat('MMM d, yyyy', 'en_US').formatNullDate(
                    userState.value!.driver!.driversLicenceExpirationDate),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'License Issue State',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                //userState.value!.driver!.driversLicenceState? ?? "N/A",
                "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
