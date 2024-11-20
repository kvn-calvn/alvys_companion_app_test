import 'package:alvys3/src/network/posthog/posthog_provider.dart';

import '../../../../common_widgets/empty_view.dart';
import '../../../../common_widgets/refreshable_page.dart';
import '../../../../common_widgets/shimmers/trip_references_shimmer.dart';
import '../../../../network/http_client.dart';
import '../../domain/app_trip/reference.dart';
import '../controller/trip_page_controller.dart';
import 'stop_details_page.dart';
import '../../../../utils/alvys_websocket.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/magic_strings.dart';

class TripReferencesCard extends StatelessWidget {
  final List<Reference> tripReferences;
  final String tripId;
  final int tabIndex;
  const TripReferencesCard(
      {super.key,
      required this.tripReferences,
      required this.tripId,
      required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    if (tripReferences.isNullOrEmpty) return const SizedBox.shrink();
    var firstTwoReferences = tripReferences.take(2);
    var restOfReferences = tripReferences.skip(2);
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.goNamed(RouteName.tripReferences.name, pathParameters: {
                ParamType.tripId.name: tripId,
              }, queryParameters: {
                ParamType.tabIndex.name: tabIndex.toString(),
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'References',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Icon(
                        Icons.adaptive.arrow_forward,
                        size: 20,
                      )
                    ],
                  ),
                  RichText(
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        text: firstTwoReferences
                            .map((x) => '${x.name}: ${x.getValue}')
                            .join(', '),
                        children: [
                          if (restOfReferences.isNotEmpty)
                            TextSpan(
                                text: ' and ${restOfReferences.length} more')
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class TripReferencesPage extends ConsumerWidget {
  final String tripId;
  const TripReferencesPage(this.tripId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshablePage(
        refresh: () async {
          await ref
              .read(tripControllerProvider.notifier)
              .refreshCurrentTrip(tripId);
          if (context.mounted) ref.read(websocketProvider).restartConnection();
        },
        title: 'References',
        body: () {
          if (ref.watch(tripControllerProvider).isLoading) {
            return TripReferencesShimer();
          }
          var trip = ref.watch(tripControllerProvider).value?.getTrip(tripId);
          ref
              .read(httpClientProvider)
              .telemetryClient
              .trackEvent(name: "opened_trip_references");
          ref.read(postHogProvider).postHogTrackEvent('opened_trip_references', null);
          return trip == null
              ? const EmptyView(
                  title: 'Trip Not found',
                  description: 'Return to the previous page.')
              : ListView(
                  children: [
                    for (var reference in trip.loadReferences)
                      ReferenceDetailsWidget(reference)
                  ],
                );
        });
  }
}
