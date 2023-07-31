// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/app_dialog.dart';
import 'package:alvys3/src/common_widgets/shimmers/trip_card_shimmer.dart';
import 'package:alvys3/src/common_widgets/trip_card.dart';
import 'package:alvys3/src/features/trips/presentation/controller/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:alvys3/src/utils/platform_channel.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadListPage extends ConsumerStatefulWidget {
  const LoadListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoadListPage> createState() => _LoadListPageState();
}

class _LoadListPageState extends ConsumerState<LoadListPage> {
  String dropdownvalue = 'Online';
  var items = [
    'Online',
    'Offline',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkLocationPermission(context);
    });
  }

  Future<void> checkLocationPermission(BuildContext context) async {
    if (await Permission.location.isPermanentlyDenied || await Permission.location.isDenied) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AppDialog(
              title: "Alvys wants to use your location.",
              description: "Alvys uses your location data to track the movement of loads you have been assigned.",
              actions: [
                AppDialogAction(
                    label: 'Allow',
                    action: () {
                      AppSettings.openAppSettings(type: AppSettingsType.location)
                          .then((value) => GoRouter.of(context).pop());
                    },
                    primary: true),
                AppDialogAction(label: 'Not Now', action: GoRouter.of(context).pop),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trips'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton(
              value: dropdownvalue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: [
                DropdownMenuItem(
                  value: "Online",
                  onTap: () {
                    //Check if user is on an active trip then start tracking if not dialog show that they are not on an active trip therefore they will remain offline.
                  },
                  child: Text(
                    "Online",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownMenuItem(
                  value: "Offline",
                  onTap: () {
                    //Stop location tracking when offline.
                    PlatformChannel.stopLocationTracking();
                  },
                  child: Text(
                    "Offline",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              ],
              onChanged: (String? value) {
                setState(() {
                  dropdownvalue = value!;
                });
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: const TripList(),
    );
  }
}

class TripList extends ConsumerWidget {
  const TripList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripControllerProvider);
    return tripsState.when(
        // skipError: true,
        loading: (() {
      return const TripListShimmer();
    }), error: (error, stack) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(tripControllerProvider.notifier).refreshTrips();
        },
        child: const EmptyView(
          title: "Error Occured",
          description: "Try pull to refresh.",
        ),
      );
    }, data: (value) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            if (value.deliveredTrips.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: LargeNavButton(
                  title: "Delivered",
                  onPressed: () {
                    context.pushNamed(RouteName.delivered.name);
                  },
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(tripControllerProvider.notifier).refreshTrips();
                },
                child: value.activeTrips.isNotEmpty
                    ? ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        children: value.activeTrips.map((trip) => TripCard(trip: trip)).toList(),
                      )
                    : const EmptyView(
                        title: "No Trips",
                        description: "Assigned trips will appear here.",
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
