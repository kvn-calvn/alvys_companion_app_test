import 'package:alvys3/src/common_widgets/main_bottom_nav.dart';
import 'package:alvys3/src/features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_page.dart';
import 'package:alvys3/src/features/echeck/presentation/echeck_page.dart';
import 'package:alvys3/src/features/trips/presentation/stopdetails/stop_details_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/filtered_trip_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/load_list_page.dart';
import 'package:alvys3/src/features/trips/presentation/tripdetails/trip_details_page.dart';
import 'package:alvys3/src/routing/error_page.dart';
import 'package:alvys3/src/routing/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider(
  ((ref) => GoRouter(
        initialLocation: '/landing',
        debugLogDiagnostics: true,
        routes: [
          GoRoute(
            name: 'landing',
            path: '/landing',
            builder: (context, state) {
              return const Landing();
            },
          ),
          GoRoute(
            name: 'signin',
            path: '/signin',
            builder: (context, state) {
              return const SignInPage();
            },
          ),
          ShellRoute(
              navigatorKey: _shellNavigatorKey,
              builder: (context, state, child) {
                return MainBottomNav(child: child);
              },
              routes: [
                GoRoute(
                  name: 'trips',
                  path: '/trips',
                  pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: LoadListPage(key: state.pageKey),
                      transitionDuration: Duration.zero,
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              child),
                  routes: [
                    GoRoute(
                      name: 'Delivered',
                      path: 'delivered',
                      builder: (context, state) {
                        final Map<String, Object> extra =
                            state.extra! as Map<String, Object>;

                        final String _title = extra['title']! as String;
                        final List<Object> _deliveredTrips =
                            extra['deliveredTrips']! as List<Object>;

                        return FilteredTripPage(
                          trips: _deliveredTrips,
                          title: _title,
                        );
                      },
                    ),
                    GoRoute(
                      name: 'Processing',
                      path: 'processing',
                      builder: (context, state) {
                        final Map<String, Object> extra =
                            state.extra! as Map<String, Object>;

                        final String _title = extra['title']! as String;
                        final List<Object> _processingTripsData =
                            extra['processingTrips']! as List<Object>;
                        return FilteredTripPage(
                          trips: _processingTripsData,
                          title: _title,
                        );
                      },
                    ),
                    /* GoRoute(
                      name: 'echeck',
                      path: 'tripdetails/echeck/:tripId',
                      builder: (context, state) {
                        final _tripId = state.params['tripId']!;
                        return EcheckPage(
                          tripId: _tripId,
                        );
                      },
                    ),*/
                    GoRoute(
                      name: 'tripDetails',
                      path: 'tripdetails',
                      builder: (context, state) {
                        final _tripNumber = state.queryParams['tripNumber']!;
                        final _tripId = state.queryParams['tripId']!;
                        return LoadDetailsPage(
                            key: state.pageKey,
                            tripId: _tripId,
                            tripNumber: _tripNumber);
                      },
                      routes: <GoRoute>[
                        GoRoute(
                          name: 'echeck',
                          path: 'echeck',
                          builder: (context, state) {
                            final _tripId = state.queryParams['tripId']!;
                            return EcheckPage(
                              tripId: _tripId,
                            );
                          },
                        ),
                        GoRoute(
                          name: 'tripDocs',
                          path: 'docs',
                          builder: (context, state) {
                            final _tripId = state.queryParams['tripId']!;
                            return TripDocsPage(
                              tripId: _tripId,
                            );
                          },
                        ),
                        /*
                        GoRoute(
                          name: 'echeck',
                          path: 'echeck',
                          builder: (context, state) {
                            /*final Map<String, Object> extra =
                                state.extra! as Map<String, Object>;*/

                            //final _tripId = extra['tripId']! as String;
                            final _tripId = state.queryParams['tripId']!;
                            return EcheckPage(
                              tripId: _tripId,
                            );
                          },
                        ),
                        GoRoute(
                          name: 'tripDocs',
                          path: 'tripDetails/docs/:tripId',
                          builder: (context, state) {
                            final _tripId = state.params['tripId']!;
                            return TripDocsPage(
                              tripId: _tripId,
                            );
                          },
                        ),
                        */
                        GoRoute(
                          name: 'stopDetails',
                          path: 'tripdetails/stopdetails/:tripId/:stopId',
                          builder: (context, state) {
                            final _tripId = state.params['tripId']!;
                            final _stopId = state.params['stopId']!;
                            return StopDetailsPage(
                              stopId: _stopId,
                              tripId: _tripId,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  name: 'settings',
                  path: '/settings',
                  builder: (context, state) {
                    final _tripId = state.params['tripId']!;
                    return TripDocsPage(
                      tripId: _tripId,
                    );
                  },
                ),
              ])
        ],
        errorPageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: ErrorScreen(
            exception: state.error,
          ),
        ),
      )),
);
