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
  late TabController _tabController;
  TripController get tripController => ref.read(tripControllerProvider.notifier);
  AppTrip? get tripState => ref.read(tripControllerProvider).value?.getTrip(widget.tripId);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: widget.tabIndex, length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.addListener(tabListener);
      TabletUtils.instance.detailsController = _tabController;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    _tabController.dispose();
    super.dispose();
  }

  void tabListener() {
    var tabC = _tabController;
    if (tabC.index == tabC.previousIndex || tabC.indexIsChanging) return;
    ref.read(postHogProvider).postHogScreen(
          tripController.tabName(_tabController.index),
          tripState?.loadNumber == null ? null : {'LoadNumber': tripState?.loadNumber ?? ''},
        );
  }

  @override
  Widget build(BuildContext context) {
    var tripDetailsState = ref.watch(tripControllerProvider);
    var trip = tripDetailsState.value?.getTrip(widget.tripId);
    var showTutorialBtn = ref.watch(firebaseRemoteConfigServiceProvider).showTutorialBtn();

    if (tripDetailsState.isLoading) return const TripDetailsShimmer();
    if (trip == null) {
      return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page');
    }

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
          if (showTutorialBtn) ...[
            IconButton(
              constraints: const BoxConstraints(),
              onPressed: () async {
                var previousTripId = widget.tripId;
                await ref.read(tripControllerProvider.notifier).showTripDetailsTutorialPreview(
                      context,
                      _tabController.index + 1,
                      _tabController.index + 1,
                      previousTripId,
                    );
                ref
                    .read(httpClientProvider)
                    .telemetryClient
                    .trackEvent(name: "trip_details_tour_button_tapped");
                await FirebaseAnalytics.instance.logEvent(name: "trip_details_tour_button_tapped");
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
                ref
                    .read(postHogProvider)
                    .postHogTrackEvent(PosthogTag.userRefreshTripdetails.toSnakeCase, null);
                ref
                    .read(httpClientProvider)
                    .telemetryClient
                    .trackEvent(name: "trip_refresh_button_tapped");
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
          controller: _tabController,
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
      body: TabBarView(
        controller: _tabController,
        children: [
          TripDetails(widget.tripId, widget.tabIndex),
          EcheckPage(widget.tripId),
          TripDocuments(widget.tripId)
        ],
      ),
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
    var trip = tripDetailsState.value?.tryGetTrip(tripId);
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
        controller: ref.read(tutorialProvider).tripInfoScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          TripGoogleMap(key: UniqueKey(), trip.id!),
          const SizedBox(height: 16),
          TripDetailsInfo(trip),
          const SizedBox(height: 8),
          TripReferencesCard(
            key: ref.read(tutorialProvider).tripReferencesCard,
            tripReferences: trip.loadReferences,
            tripId: tripId,
            tabIndex: tabIndex,
          ),
          if (trip.stops.isNullOrEmpty)
            SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No Stops",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text("There are no stops on this trip.",
                      style: Theme.of(context).textTheme.bodyMedium)
                ],
              ),
            )
          else ...{
            for (var i = 0; i < trip.stops.length; i++) ...{
              StopCard(
                index: i,
                stop: trip.stops[i],
                tripId: trip.id!,
                tabIndex: tabIndex,
                tripNumber: trip.tripNumber!,
                canCheckInOutStopId: trip.canCheckInOutStopId,
              ),
            },
          }
        ],
      ),
    );
  }
}
