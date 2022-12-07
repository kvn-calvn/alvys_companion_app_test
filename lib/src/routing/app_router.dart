// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/main_bottom_nav.dart';
import 'package:alvys3/src/features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import 'package:alvys3/src/features/authentication/presentation/verify_phonenumber/phone_verification_page.dart';
import 'package:alvys3/src/features/documents/presentation/pdf_viewer.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_page.dart';
import 'package:alvys3/src/features/echeck/presentation/echeck_page.dart';
import 'package:alvys3/src/features/permission/location/presentation/request_location.dart';
import 'package:alvys3/src/features/permission/notification/request_notification.dart';
import 'package:alvys3/src/features/settings/presentation/settings_page.dart';
import 'package:alvys3/src/features/trips/presentation/stopdetails/stop_details_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/filtered_trip_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/load_list_page.dart';
import 'package:alvys3/src/features/trips/presentation/tripdetails/trip_details_page.dart';
import 'package:alvys3/src/routing/error_page.dart';
import 'package:alvys3/src/routing/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//final _rootNavigatorKey = GlobalKey<NavigatorState>();
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
            name: 'SignIn',
            path: '/signin',
            builder: (context, state) {
              return const SignInPage();
            },
          ),
          GoRoute(
            name: 'Verify',
            path: '/verify',
            builder: (context, state) {
              return const PhoneNumberVerificationPage();
            },
          ),
          GoRoute(
            name: 'LocationPermission',
            path: '/location',
            builder: (context, state) {
              return const RequestLocation();
            },
          ),
          GoRoute(
            name: 'NotificationPermission',
            path: '/notification',
            builder: (context, state) {
              return const RequestNotification();
            },
          ),
          ShellRoute(
              navigatorKey: _shellNavigatorKey,
              builder: (context, state, child) {
                return MainBottomNav(child: child);
              },
              routes: [
                GoRoute(
                  name: 'Trips',
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
                      name: 'delivered',
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
                      name: 'processing',
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
                    GoRoute(
                      name: 'tripDetails',
                      path: 'tripdetails',
                      builder: (context, state) {
                        return LoadDetailsPage(
                          key: state.pageKey,
                        );
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
                            routes: <GoRoute>[
                              GoRoute(
                                name: 'docView',
                                path: 'docview',
                                builder: (context, state) {
                                  final _docURL = state.queryParams['docUrl']!;
                                  final _docType =
                                      state.queryParams['docType']!;
                                  return PDFViewer(
                                    documentType: _docType,
                                    documentPath: _docURL,
                                  );
                                },
                              )
                            ]),
                        GoRoute(
                          name: 'stopDetails',
                          path: 'stopdetails',
                          builder: (context, state) {
                            return const StopDetailsPage();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  name: 'Settings',
                  path: '/settings',
                  builder: (context, state) {
                    return const SettingsPage();
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
