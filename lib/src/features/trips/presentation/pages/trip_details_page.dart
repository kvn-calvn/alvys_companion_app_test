import '../../../../utils/magic_strings.dart';

import 'trip_details_info.dart';

import '../../domain/app_trip/app_trip.dart';
import 'trip_references.dart';
import '../../../../common_widgets/tab_text.dart';
import '../../../../network/posthog/posthog_provider.dart';
import '../../../../utils/alvys_websocket.dart';

import '../../../../network/firebase_remote_config_service.dart';
import '../../../../network/http_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/tablet_utils.dart';

import '../../../google_maps_helper/presentation/trip_google_map.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
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
  const LoadDetailsPage(this.tripId, this.tabIndex, {super.key});

  @override
  ConsumerState<LoadDetailsPage> createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage> with TickerProviderStateMixin {
  // late TabController _tabController;
  TripController get tripController => ref.read(tripControllerProvider.notifier);
  AppTrip? get tripState => ref.read(tripControllerProvider).value?.getTrip(widget.tripId);

  @override
  void initState() {
    super.initState();
    TabletUtils.instance.detailsController = TabController(initialIndex: widget.tabIndex, length: 3, vsync: this);
    TabletUtils.instance.detailsController.addListener(tabListener);
  }

  @override
  void dispose() {
    TabletUtils.instance.detailsController.removeListener(tabListener);
    TabletUtils.instance.detailsController.dispose();
    super.dispose();
  }

  void tabListener() {
    var tabC = TabletUtils.instance.detailsController;
    if (tabC.index == tabC.previousIndex || tabC.indexIsChanging) return;
    ref.read(postHogProvider).postHogScreen(tripController.tabName(TabletUtils.instance.detailsController.index),
        tripState?.loadNumber == null ? null : {'LoadNumber': tripState?.loadNumber ?? ''});
  }

  @override
  Widget build(BuildContext context) {
    var trip = ref.watch(tripControllerProvider).value!.getTrip(widget.tripId);
    var showTutBtn = ref.watch(firebaseRemoteConfigServiceProvider).showTutorialBtn();
    // ref.read(postHogProvider).postHogScreen('Trip Details - ${trip.loadNumber ?? ''}',
    //     {'load_number': trip.loadNumber ?? '', 'trip_id': trip.id ?? ''});

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
              if (mounted) {
                ref.read(websocketProvider).restartConnection();
                ref.read(postHogProvider).postHogTrackEvent(PosthogTag.userRefreshTripdetails.toSnakeCase, null);
                ref.read(httpClientProvider).telemetryClient.trackEvent(name: "trip_refresh_button_tapped");
                await FirebaseAnalytics.instance.logEvent(name: "trip_refresh_button_tapped");
              }
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
                child: const TabText('Details'),
              );
            }),
            Consumer(builder: (context, ref, child) {
              return Tab(
                key: ref.read(tutorialProvider).echeckTab,
                child: const TabText('E-Checks'),
              );
            }),
            Consumer(builder: (context, ref, child) {
              return Tab(
                key: ref.read(tutorialProvider).documentTab,
                child: const TabText('Documents'),
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
  const TripDetails(this.tripId, this.tabIndex, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDetailsState = ref.watch(tripControllerProvider);
    var trip = tripDetailsState.value!.tryGetTrip(tripId);
    if (tripDetailsState.isLoading) return const TripDetailsShimmer();
    if (trip == null) {
      return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page');
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(tripId);
        if (context.mounted) ref.read(websocketProvider).restartConnection();
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
                    TripGoogleMap(key: ValueKey(trip.id!), trip.id!),
                    // Column(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 15, 0),
                    //       child: Wrap(
                    //         direction: Axis.horizontal,
                    //         children: [
                    //           if (equipment.isNotNullOrEmpty) ...[
                    //             ChipCard(text: equipment),
                    //           ],
                    //           if (trip.temperature != null) ...[
                    //             ChipCard(
                    //                 text:
                    //                     '${trip.temperature!.toStringAsFixed(1)} °f ${(trip.continuous ?? false) ? '(cont.)' : ''}')
                    //           ],
                    //           if (trip.trailerNum.isNotNullOrEmpty) ...[
                    //             ChipCard(text: 'Trailer ${trip.trailerNum}'),
                    //           ],
                    //           if (trip.totalWeight != null && trip.totalWeight != 0) ...[
                    //             ChipCard(text: '${NumberFormat.decimalPattern().format(trip.totalWeight)} lbs'),
                    //           ],
                    //           if (trip.totalMiles != null) ...[
                    //             ChipCard(text: '${NumberFormat.decimalPattern().format(trip.totalMiles)} mi'),
                    //           ],
                    //           if (trip.driverPayable(authState.value!.tryGetUserTenant(trip.companyCode!)?.assetId) !=
                    //                   null &&
                    //               authState.value!.shouldShowPayableAmount(trip.companyCode!)) ...[
                    //             ChipCard(
                    //               text:
                    //                   'Driver Payable ${NumberFormat.simpleCurrency().format(trip.driverPayable(authState.value!.tryGetUserTenant(trip.companyCode!)!.assetId!))}',
                    //             ),
                    //           ],
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 16),
                    TripDetailsInfo(trip),
                    const SizedBox(height: 8),
                    TripReferencesCard(tripReferences: trip.loadReferences, tripId: tripId, tabIndex: tabIndex),
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
                                tripNumber: trip.tripNumber!,
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
