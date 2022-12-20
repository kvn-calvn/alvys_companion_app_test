// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/shimmers/trip_card_shimmer.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../common_widgets/trip_card.dart';
import '../../../../network/client_error/client_error.dart';
import '../../../../utils/exceptions.dart';

class LoadListPage extends ConsumerStatefulWidget {
  const LoadListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoadListPageState createState() => _LoadListPageState();
}

class _LoadListPageState extends ConsumerState<LoadListPage> {
  String dropdownvalue = 'Online';
  var items = [
    'Online',
    'Offline',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trips'),
        actions: [
          DropdownButton(
            value: dropdownvalue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                onTap: () {
                  throw ClientException(
                      ClientError(title: 'test', content: ''));
                  // ref.read(tripPageControllerProvider.notifier).getTrips();
                },
                child: Text(
                  items,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                dropdownvalue = value!;
              });
            },
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: const TripList(),
    );
  }
}

class TripList extends ConsumerWidget {
  const TripList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripPageControllerProvider);
    return tripsState.when(loading: (() {
      return const TripListShimmer();
    }), error: (error, stack) {
      return const Text('Oops, something unexpected happened');
    }, data: (value) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            if (value.deliveredTrips.isNotEmpty)
              LargeNavButton(
                title: "Delivered",
                onPressed: () {
                  context.pushNamed(RouteName.delivered.name);
                },
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(tripPageControllerProvider.notifier)
                      .refreshTrips();
                },
                child: value.activeTrips.isNotEmpty
                    ? ListView(
                        children: value.activeTrips
                            .map((trip) => TripCard(trip: trip))
                            .toList(),
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
