import '../../../../network/firebase_remote_config.dart';
import '../../../../network/http_client.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../authentication/presentation/driver_status_dropdown.dart';
import '../../../tutorial/tutorial_controller.dart';

import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/app_dialog.dart';
import '../../../../common_widgets/shimmers/trip_card_shimmer.dart';
import '../../../../common_widgets/trip_card.dart';
import '../../../../utils/app_theme.dart';
import '../controller/trip_page_controller.dart';
import 'filtered_trip_page.dart';
import '../../../../utils/magic_strings.dart';
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(tutorialProvider)
          .startTutorial(context, () async => ref.read(tripControllerProvider.notifier).handleAfterTutorial(context));
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
    final showTutBtn = ref.read(remoteconfigProvider).value?.getBool("show_tutorial_btn");
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: DriverStatusDropdown(),
        ),
        leadingWidth: 128,
        title: Text(
          'Trips',
          style: AlvysTheme.appbarTextStyle(context, false),
        ),
        actions: [
          IconButton(
            constraints: const BoxConstraints(),
            onPressed: () async {
              await ref.read(tripControllerProvider.notifier).showTripListPreview(context, 0, 0);
              ref.read(httpClientProvider).telemetryClient.trackEvent(name: "trip_list_tour_button_tapped");
              await FirebaseAnalytics.instance.logEvent(name: "trip_list_tour_button_tapped");
            },
            icon: const Icon(Icons.info),
          ),
          if (showTutBtn.isNotNull && showTutBtn == true) ...[
            IconButton(
              padding: const EdgeInsets.only(right: 18.0, left: 5.0),
              constraints: const BoxConstraints(),
              key: ref.read(tutorialProvider).refresh,
              onPressed: () async {
                await ref.read(tripControllerProvider.notifier).refreshTrips(true);
                ref.read(httpClientProvider).telemetryClient.trackEvent(name: "refresh_button_tapped");
                await FirebaseAnalytics.instance.logEvent(name: "refresh_button_tapped");
              },
              icon: const Icon(Icons.refresh),
            )
          ]
        ],
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
    if (tripsState.isLoading) return const TripListShimmer();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(tripControllerProvider.notifier).refreshTrips();
              },
              child: tripsState.value!.activeTrips.isNotEmpty
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      children: tripsState.value!.activeTrips.map((trip) => TripCard(trip: trip)).toList(),
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
  }
}
