// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/app_trip/m_comodity.dart';

class StopDetailsPage extends ConsumerStatefulWidget {
  const StopDetailsPage({Key? key}) : super(key: key);

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
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
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
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: StopDetails(),
      ),
    );
  }
}

class StopDetails extends ConsumerWidget {
  const StopDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopDetailsState = ref.watch(tripPageControllerProvider);

    return stopDetailsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary(Theme.of(context).brightness),
              size: 50.0,
            ),
        error: (error, stack) =>
            Text('Oops, something unexpected happened, $stack'),
        data: (value) {
          var currentStop = value.currentStop;
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(tripPageControllerProvider.notifier)
                  .refreshCurrentTrip();
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
                      currentStop.street ?? "",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${currentStop.city!} ${currentStop.state!} ${currentStop.zip!}',
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
                          DateFormat.MEd()
                              .formatNullDate(currentStop.actualStopdate),
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
                          currentStop.timeRecord?.driver?.driverIn ?? '-',
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
                          currentStop.timeRecord?.driver?.out ?? '-',
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
                ItemsWidget(
                    commodities: currentStop.mComodities ?? <MComodity>[]),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Instruction',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      currentStop.genInstructions.isNullOrEmpty
                          ? '-'
                          : currentStop.genInstructions!,
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
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      type: MaterialType.card,
      child: Column(
        children: [
          for (var item in commodities)
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
