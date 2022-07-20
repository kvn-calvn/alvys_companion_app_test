import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/trips/domain/trips/datum.dart';
import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:alvys3/src/routing/routing_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common_widgets/trip_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadListPage extends ConsumerStatefulWidget {
  const LoadListPage({Key? key}) : super(key: key);

  @override
  _LoadListPageState createState() => _LoadListPageState();
}

class _LoadListPageState extends ConsumerState<LoadListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ref.read(tripPageControllerProvider.notifier).getTrips();
  }

  String dropdownvalue = 'Online';
  var items = [
    'Online',
    'Offline',
  ];
/*
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Settings'),
            )
          ];
        },
        body: const Center(
          child: Text('Home Page'),
        ),
      ),
    );
  }
}*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Trips',
          textAlign: TextAlign.start,
          style: getBoldStyle(color: ColorManager.darkgrey, fontSize: 20),
        ),
        actions: [
          DropdownButton(
            value: dropdownvalue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((String items) {
              return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items,
                    style: getMediumStyle(
                        color: ColorManager.darkgrey, fontSize: 18),
                  ));
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
      backgroundColor: const Color(0xFFF1F4F8),
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

    return tripsState.when(
        loading: () => SpinKitFoldingCube(
              color: ColorManager.primary,
              size: 50.0,
            ),
        error: (error, stack) =>
            const Text('Oops, something unexpected happened'),
        data: (value) {
          List<Datum> _activeTripsData = [];
          List<Datum> _deliveredTripsData = [];
          List<Datum> _processingTripsData = [];

          if (value != null && value.data != null) {
            _activeTripsData = value.data!
                .where((element) => element.status == "Dispatched")
                .toList();

            _deliveredTripsData = value.data!
                .where((element) => element.status == "Delivered")
                .toList();

            _processingTripsData = value.data!
                .where((element) => element.status == "Released")
                .toList();
          }

          _activeTripList() {
            return _activeTripsData.map((trip) => TripCard(trip: trip));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            scrollDirection: Axis.vertical,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LargeNavButton(
                    title: "Delivered",
                    route: Routes.deliveredTripsRoute,
                    args: FilteredTripsArguments(
                        data: _deliveredTripsData, title: "Delivered"),
                  ),
                  LargeNavButton(
                    title: "Processing",
                    route: Routes.processingTripsRoute,
                    args: FilteredTripsArguments(
                        data: _processingTripsData, title: "Processing"),
                  ),
                  if (_activeTripsData.isNotEmpty) ...[
                    Column(
                      children: [..._activeTripList()],
                    )
                    //
                  ] else ...[
                    const Center(
                      heightFactor: 10,
                      child: Text(
                          "You do not have any active trip at the moment."),
                    )
                  ],
                ],
              ),
            ],
          );
        });
  }
}
