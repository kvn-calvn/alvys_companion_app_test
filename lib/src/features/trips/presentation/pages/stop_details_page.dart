import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/controller/trip_page_controller.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_theme.dart';
import '../../domain/model/app_trip/m_comodity.dart';

class StopDetailsPage extends ConsumerStatefulWidget {
  final String tripId;
  final String stopId;
  const StopDetailsPage(this.tripId, this.stopId, {Key? key}) : super(key: key);

  @override
  ConsumerState<StopDetailsPage> createState() => _StopDetailsPageState();
}

class _StopDetailsPageState extends ConsumerState<StopDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Stop Details',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        centerTitle: true,
        leading: IconButton(
          // 1
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: StopDetails(widget.tripId, widget.stopId),
      ),
    );
  }
}

class StopDetails extends ConsumerWidget {
  final String tripId;
  final String stopId;
  const StopDetails(
    this.tripId,
    this.stopId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopDetailsState = ref.watch(tripControllerProvider);

    return stopDetailsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary(Theme.of(context).brightness),
              size: 50.0,
            ),
        error: (error, stack) => Text('Oops, something unexpected happened, $stack'),
        data: (value) {
          var currentStop = value.getStop(tripId, stopId);
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(tripId);
            },
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      currentStop.companyName ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      currentStop.address?.street ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${currentStop.address?.city} ${currentStop.address?.state} ${currentStop.address?.zip}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          currentStop.phone ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Date',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          DateFormat.MEd().formatNullDate(currentStop.actualStopdate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check In',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          DateFormat.MEd().formatNullDate(currentStop.timeRecord?.driver?.timeIn),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Check Out',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          DateFormat.MEd().formatNullDate(currentStop.timeRecord?.driver?.timeOut),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Items',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                ItemsWidget(commodities: currentStop.comodities ?? <MComodity>[]),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Instruction',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      currentStop.genInstructions.isNullOrEmpty ? '-' : currentStop.genInstructions!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stop Instruction',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      currentStop.instructions ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    Key? key,
    required this.commodities,
  }) : super(key: key);

  final List<MComodity> commodities;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var item in commodities)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              type: MaterialType.card,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UNITS',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${item.numUnits} ${item.unitType}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'PIECES',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${item.numPieces}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'WEIGHT',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${item.weight} ${item.weightType}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        )
    ]);
  }
}
