import '../../../../network/firebase_remote_config_service.dart';
import '../../../../network/http_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/tablet_utils.dart';

import '../../../authentication/presentation/auth_provider_controller.dart';
import '../../../google_maps_helper/presentation/trip_google_map.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/shimmers/trip_details_shimmer.dart';
import '../../../../common_widgets/stop_card.dart';
import '../../../../utils/app_theme.dart';
import '../../../echeck/presentation/pages/echeck_page.dart';
import '../../../tutorial/tutorial_controller.dart';
import '../controller/trip_page_controller.dart';
import 'trip_documents_page.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  final String tripId;
  final int tabIndex;
  const LoadDetailsPage(this.tripId, this.tabIndex, {Key? key}) : super(key: key);

  @override
  ConsumerState<LoadDetailsPage> createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage> with TickerProviderStateMixin {
  // late TabController _tabController;

  @override
  void initState() {
    super.initState();
    TabletUtils.instance.detailsController = TabController(initialIndex: widget.tabIndex, length: 3, vsync: this);
  }

  @override
  void dispose() {
    TabletUtils.instance.detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var trip = ref.watch(tripControllerProvider).value!.getTrip(widget.tripId);
    var showTutBtn = ref.watch(firebaseRemoteConfigServiceProvider).showTutorialBtn();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          trip.tripNumber ?? '',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          if (showTutBtn) ...[
            IconButton(
              constraints: const BoxConstraints(),
              onPressed: () async {
                var previousTripId = widget.tripId;
                await ref.read(tripControllerProvider.notifier).showTripDetailsTutorialPreview(
                    context,
                    TabletUtils.instance.detailsController.index + 1,
                    TabletUtils.instance.detailsController.index + 1,
                    previousTripId);
                ref.read(httpClientProvider).telemetryClient.trackEvent(name: "trip_details_tour_button_tapped");
                await FirebaseAnalytics.instance.logEvent(name: "trip_details_tour_button_tapped");
                // context.goNamed(RouteName.tripDetails.name, pathParameters: {ParamType.tripId.name: testTrip.id!});
                // ref.read(tripControllerProvider.notifier).prepareTutorialPreview(context,
                //     TabletUtils.instance.detailsController.index + 1, TabletUtils.instance.detailsController.index + 1);
                // ref.read(tutorialProvider).showTutorialSection(context, TabletUtils.instance.detailsController.index + 1,
                //     TabletUtils.instance.detailsController.index + 1, () async {
                //   context.goNamed(RouteName.tripDetails.name, pathParameters: {ParamType.tripId.name: previousTripId});
                //   // await ref.read(tripControllerProvider.notifier).refreshTrips(true);
                // });
              },
              icon: const Icon(Icons.info),
            ),
          ],
          IconButton(
            padding: const EdgeInsets.only(right: 18.0, left: 5.0),
            constraints: const BoxConstraints(),
            onPressed: () async {
              await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(widget.tripId);
              ref.read(httpClientProvider).telemetryClient.trackEvent(name: "trip_refresh_button_tapped");
              await FirebaseAnalytics.instance.logEvent(name: "trip_refresh_button_tapped");
            },
            icon: const Icon(Icons.refresh),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: TabletUtils.instance.detailsController,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          tabs: <Widget>[
            Consumer(builder: (context, ref, child) {
              return Tab(
                key: ref.read(tutorialProvider).infoTab,
                text: 'Details',
              );
            }),
            Consumer(builder: (context, ref, child) {
              return Tab(
                key: ref.read(tutorialProvider).echeckTab,
                text: 'E-Checks',
              );
            }),
            Consumer(builder: (context, ref, child) {
              return Tab(
                key: ref.read(tutorialProvider).documentTab,
                text: 'Documents',
              );
            })
          ],
        ),
      ),
      body: TabBarView(controller: TabletUtils.instance.detailsController, children: [
        TripDetails(widget.tripId, widget.tabIndex),
        EcheckPage(widget.tripId),
        TripDocuments(widget.tripId)
        // DocumentsPage(DocumentsArgs(DocumentType.tripDocuments, widget.tripId)),
      ]),
    );
  }
}

class TripDetails extends ConsumerWidget {
  final String tripId;
  final int tabIndex;
  const TripDetails(this.tripId, this.tabIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final tripDetailsState = ref.watch(tripControllerProvider);
    var trip = tripDetailsState.value!.tryGetTrip(tripId);
    // return TripDetailsShimmer();
    if (tripDetailsState.isLoading) return const TripDetailsShimmer();
    if (trip == null) {
      return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page');
    }

    var equipment = "${trip.equipment} ${trip.equipmentLength}".trim();

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(tripId);
      },
      child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TripGoogleMap(trip.id!),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 15, 0),
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              if (equipment.isNotNullOrEmpty) ...[
                                Chip(
                                  label: Text(
                                    equipment,
                                    style: Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ],
                              if (trip.totalWeight != null) ...[
                                Chip(
                                  label: Text(
                                    '${NumberFormat.decimalPattern().format(trip.totalWeight)} lbs',
                                    style: Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ],
                              if (trip.temperature != null) ...[
                                Chip(
                                  label: Text(
                                    '${trip.temperature!.toStringAsFixed(1)} °f ${(trip.continuous ?? false) ? '(cont.)' : ''}',
                                    style: Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ],
                              if (trip.totalMiles != null) ...[
                                Chip(
                                  label: Text(
                                    '${NumberFormat.decimalPattern().format(trip.totalMiles)} mi',
                                    style: Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ],
                              if (trip.trailerNum.isNotNullOrEmpty) ...[
                                Chip(
                                  label: Text(
                                    'Trailer ${trip.trailerNum}',
                                    style: Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ],
                              if (trip.driverPayable(authState.value!.tryGetUserTenant(trip.companyCode!)?.assetId) !=
                                      null &&
                                  authState.value!.shouldShowPayableAmount(trip.companyCode!)) ...[
                                Chip(
                                  label: Text(
                                    'Driver Payable ${NumberFormat.simpleCurrency().format(trip.driverPayable(authState.value!.tryGetUserTenant(trip.companyCode!)!.assetId!))}',
                                    style: Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (trip.stops.isNullOrEmpty) ...{
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Text(
                              "No Stops",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text("There are no stops on this trip.", style: Theme.of(context).textTheme.bodyMedium)
                          ],
                        ),
                      ),
                    } else ...{
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...trip.stops.mapList((stop, index, last) => StopCard(
                                index: index,
                                stop: stop,
                                tripId: trip.id!,
                                tabIndex: tabIndex,
                                canCheckInOutStopId: trip.canCheckInOutStopId,
                              ))
                        ],
                      ),
                    }
                  ],
                ),
              ],
            )
          ]),
    );
  }
}
