import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
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
              CircleAvatar(
                radius: 50.0,
                backgroundImage:
                    NetworkImage("https://via.placeholder.com/150"),
                backgroundColor: Colors.transparent,
              ),
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
                'Sandbox Driver',
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
                'sandbox@alvys.com',
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
                '9094623310',
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
                'Calvin Logistics, Archerhub',
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
                '123 Melrose St',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Brooklyn, NY 11206',
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
                'LC546987',
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
                'Aug 16, 2023',
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
                '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
        ]),
      ),
    );
    ;
  }
}
