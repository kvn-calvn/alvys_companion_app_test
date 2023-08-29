import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/common_widgets/app_dialog.dart';
import 'package:alvys3/src/common_widgets/shimmers/trip_card_shimmer.dart';
import 'package:alvys3/src/common_widgets/trip_card.dart';
import 'package:alvys3/src/features/trips/presentation/controller/trip_page_controller.dart';
import 'package:alvys3/src/features/trips/presentation/pages/filtered_trip_page.dart';
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

class _LoadListPageState extends ConsumerState<LoadListPage> with TickerProviderStateMixin {
  String dropdownvalue = 'Online';
  late TabController _tabController;
  var items = [
    'Online',
    'Offline',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //checkLocationPermission(context);
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
        title: const Text('Trips'),
        leadingWidth: 120,
        leading: Padding(
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
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          onTap: (value) {
            /*if (functions.isLoading)
                  setState(() => tabController.index = 0);*/
          },
          tabs: const <Widget>[
            Tab(
              text: 'Active',
            ),
            Tab(
              text: 'Delivered',
            ),
            Tab(
              text: 'Processing',
            )
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: const [
        TripList(),
        FilteredTripPage(
          filterType: TripFilterType.delivered,
        ),
        FilteredTripPage(
          filterType: TripFilterType.processing,
        ),
      ]),
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(tripControllerProvider.notifier).refreshTrips();
                },
                child: value.activeTrips.isNotEmpty
                    ? ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
