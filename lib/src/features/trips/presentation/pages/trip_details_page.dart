import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/shimmers/trip_details_shimmer.dart';
import '../../../../common_widgets/stop_card.dart';
import '../../../../utils/app_theme.dart';
import '../../../echeck/presentation/pages/echeck_page.dart';
import '../controller/trip_page_controller.dart';
import 'trip_documents_page.dart';

class LoadDetailsPage extends ConsumerStatefulWidget {
  final String tripId;

  const LoadDetailsPage(this.tripId, {Key? key}) : super(key: key);

  @override
  ConsumerState<LoadDetailsPage> createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends ConsumerState<LoadDetailsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var trip = ref.watch(tripControllerProvider).value!.getTrip(widget.tripId);
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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          onTap: (value) {
            /*if (functions.isLoading)
                  setState(() => tabController.index = 0);*/
          },
          tabs: const <Widget>[
            Tab(
              text: 'Details',
            ),
            Tab(
              text: 'E-Checks',
            ),
            Tab(
              text: 'Documents',
            )
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        TripDetails(widget.tripId),
        EcheckPage(widget.tripId),
        TripDocuments(widget.tripId)
        // DocumentsPage(DocumentsArgs(DocumentType.tripDocuments, widget.tripId)),
      ]),
    );
  }
}

class TripDetails extends ConsumerWidget {
  final String tripId;
  const TripDetails(this.tripId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final tripDetailsState = ref.watch(tripControllerProvider);
    var trip = tripDetailsState.value!.tryGetTrip(tripId);
    // return TripDetailsShimmer();
    if (trip == null) return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page');
    if (tripDetailsState.isLoading) return const TripDetailsShimmer();

    var equipment = "${trip.equipment} ${trip.equipmentLength}";

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(tripId);
      },
      child: ListView(scrollDirection: Axis.vertical, padding: const EdgeInsets.symmetric(horizontal: 16.0), children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        tilt: 20,
                        target: LatLng(37.6, -95.665),
                        zoom: 21,
                      ),
                      mapToolbarEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      mapType: MapType.normal,
                    ),
                  ),
                ),
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
                                '${trip.equipment!} ${trip.equipmentLength ?? ''}',
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
                                '${trip.temperature!.toStringAsFixed(1)} °f',
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
                          if (trip.driverPayable(authState.value!.currentUserTenant(trip.companyCode!).assetId!) !=
                                  null &&
                              authState.value!.shouldShowPayableAmount(trip.companyCode!)) ...[
                            Chip(
                              label: Text(
                                'Driver Payable ${NumberFormat.simpleCurrency().format(trip.driverPayable(authState.value!.currentUserTenant(trip.companyCode!).assetId!))}',
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
                      ...trip.stops!.map((stop) => StopCard(
                            stop: stop,
                            tripId: trip.id!,
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
