import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/shimmers/stop_details_shimmer.dart';
import '../../../../common_widgets/stop_card.dart';
import '../../../../network/http_client.dart';
import '../../../../network/posthog/posthog_provider.dart';
import '../../../../utils/app_theme.dart';
import '../../domain/app_trip/m_comodity.dart';
import '../../domain/app_trip/reference.dart';
import '../../domain/app_trip/stop.dart';
import '../controller/trip_page_controller.dart';

class StopDetailsPage extends ConsumerStatefulWidget {
  final String tripId;
  final String stopId;
  const StopDetailsPage(this.tripId, this.stopId, {super.key});

  @override
  ConsumerState<StopDetailsPage> createState() => _StopDetailsPageState();
}

class _StopDetailsPageState extends ConsumerState<StopDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Stop Details',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 18.0, left: 5.0),
            constraints: const BoxConstraints(),
            onPressed: () async {
              await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(widget.tripId);
              if (mounted) {
                ref.read(postHogProvider).postHogTrackEvent('user_refresh_stopdetails', null);
                ref.read(httpClientProvider).telemetryClient.trackEvent(name: "stop_refresh_button_tapped");
                await FirebaseAnalytics.instance.logEvent(name: "stop_refresh_button_tapped");
              }
            },
            icon: const Icon(Icons.refresh),
          )
        ],
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
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopDetailsState = ref.watch(tripControllerProvider);
    if (stopDetailsState.isLoading) return const StopDetailsShimmer();
    var currentStop = stopDetailsState.value!.tryGetStop(tripId, stopId);
    var trip = stopDetailsState.value!.tryGetTrip(tripId);
    // ref.read(postHogProvider).postHogScreen('Stop Details - ${trip?.loadNumber ?? ''}', {
    //   "stop_id": stopId,
    // });
    if (trip == null) {
      return const EmptyView(title: 'Trip Not found', description: 'Return to the previous page.');
    }
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(tripId);
        if (context.mounted) {
          ref.read(httpClientProvider).telemetryClient.trackEvent(name: "stop_refresh_button_tapped");
          await FirebaseAnalytics.instance.logEvent(name: "stop_refresh_button_tapped");
        }
      },
      child: currentStop == null
          ? const EmptyView(
              title: 'Stop Unavailable',
              description: 'Stop details not found. Try refreshing this page or the trip list page')
          : ListView(
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
                    SelectableText.rich(
                      TextSpan(
                          text: currentStop.address?.street ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            if (currentStop.address?.apartmentNumber.isNotNullOrEmpty ?? false)
                              TextSpan(
                                text: '\n${currentStop.address?.apartmentNumber}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            TextSpan(
                              text:
                                  '\n${currentStop.address?.city} ${currentStop.address?.state} ${currentStop.address?.zip}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ]),
                    ),
                    const SizedBox(height: 10),
                    StopLoadingTypeWidget(currentStop)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SelectableText(
                          currentStop.phone ?? "-",
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
                          currentStop.formattedStopDate.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Checked In',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          DateFormat.yMMMd().addPattern('@').add_Hm().formatNullDate(currentStop.arrived?.localDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Checked Out',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          DateFormat.yMMMd().addPattern('@').add_Hm().formatNullDate(currentStop.departed?.localDate),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Commodities',
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
                    HtmlWidget(
                      currentStop.genInstructions.isNullOrEmpty ? '-' : currentStop.genInstructions!,
                    ),
                    /*Text(
                      currentStop.genInstructions.isNullOrEmpty
                          ? '-'
                          : currentStop.genInstructions!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),*/
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
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'References',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    ReferencesWidget(references: currentStop.references ?? <Reference>[])
                  ],
                ),
              ],
            ),
    );
  }
}

class ReferencesWidget extends StatelessWidget {
  const ReferencesWidget({
    super.key,
    required this.references,
  });

  final List<Reference> references;

  @override
  Widget build(BuildContext context) {
    if (references.isEmpty) return const Text('-');
    return LayoutBuilder(builder: (context, constaints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: references
            .map(
              (reference) => reference.access.equalsIgnoreCase(StopReferenceAccessType.public)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reference.name ?? '',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: constaints.maxWidth * 0.6),
                          child: Text(reference.getValue,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              softWrap: true),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            )
            .toList(),
      );
    });
  }
}

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    super.key,
    required this.commodities,
  });

  final List<MComodity> commodities;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (commodities.isEmpty)
        const Row(
          children: [Text('-')],
        ),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.spaceBetween,
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
                              item.numPieces.isNull ? '-' : NumberFormat.decimalPattern().format(item.numPieces ?? 0),
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
                              item.weight.isNull
                                  ? '-'
                                  : '${NumberFormat.decimalPattern().format(item.weight)} ${item.weightType}',
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

class StopDateDetails extends StatelessWidget {
  final StopTimeArgs? args;
  final TextStyle? style;
  const StopDateDetails({super.key, required this.args, this.style});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: (style ?? Theme.of(context).textTheme.bodyMedium!).copyWith(height: 1.2),
        child: args?.isEmpty ?? true
            ? const Text('-')
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(args!.title), Text(args!.date)],
              ));
  }
}
