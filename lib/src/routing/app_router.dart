import 'package:alvys3/main.dart';
import 'package:alvys3/src/common_widgets/main_bottom_nav.dart';
import 'package:alvys3/src/features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import 'package:alvys3/src/features/authentication/presentation/verify_phonenumber/phone_verification_page.dart';
import 'package:alvys3/src/features/documents/presentation/document_page.dart';
import 'package:alvys3/src/features/documents/presentation/pdf_viewer.dart';
import 'package:alvys3/src/features/echeck/presentation/echeck_page.dart';
import 'package:alvys3/src/features/echeck/presentation/generate_echeck.dart';
import 'package:alvys3/src/features/permission/location/presentation/request_location.dart';
import 'package:alvys3/src/features/permission/notification/request_notification.dart';
import 'package:alvys3/src/features/settings/presentation/about_page.dart';
import 'package:alvys3/src/features/settings/presentation/profile_page.dart';
import 'package:alvys3/src/features/settings/presentation/settings_page.dart';
import 'package:alvys3/src/features/trips/presentation/stopdetails/stop_details_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/filtered_trip_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/load_list_page.dart';
import 'package:alvys3/src/features/trips/presentation/tripdetails/trip_details_page.dart';
import 'package:alvys3/src/routing/dialog_page.dart';
import 'package:alvys3/src/routing/error_page.dart';
import 'package:alvys3/src/routing/landing.dart';
import 'package:alvys3/src/routing/routing_arguments.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/presentation/auth_provider_controller.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

Provider<GoRouter> routerProvider = Provider(
  (ref) => GoRouter(
    navigatorKey: navKey,
    initialLocation: ref.read(authProvider).value!.driver == null
        ? RouteName.signIn.toRoute
        : RouteName.trips.toRoute,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: RouteName.landing.name,
        path: RouteName.landing.toRoute,
        builder: (context, state) {
          return const Landing();
        },
      ),
      GoRoute(
        name: RouteName.signIn.name,
        path: RouteName.signIn.toRoute,
        builder: (context, state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        name: RouteName.verify.name,
        path: RouteName.verify.toRoute,
        builder: (context, state) {
          return const PhoneNumberVerificationPage();
        },
      ),
      GoRoute(
        name: RouteName.locationPermission.name,
        path: RouteName.locationPermission.toRoute,
        builder: (context, state) {
          return const RequestLocation();
        },
      ),
      GoRoute(
        name: RouteName.notificationPermission.name,
        path: RouteName.notificationPermission.toRoute,
        builder: (context, state) {
          return const RequestNotification();
        },
      ),
      ShellRoute(
          // navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainBottomNav(child: child);
          },
          routes: [
            GoRoute(
              name: RouteName.trips.name,
              path: RouteName.trips.toRoute,
              pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: LoadListPage(key: state.pageKey),
                  transitionDuration: Duration.zero,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) => child),
              routes: [
                GoRoute(
                  name: RouteName.delivered.name,
                  path: RouteName.delivered.name,
                  builder: (context, state) {
                    return const FilteredTripPage(
                      filterType: TripFilterType.delivered,
                    );
                  },
                ),
                GoRoute(
                  name: RouteName.processing.name,
                  path: RouteName.processing.name,
                  builder: (context, state) {
                    return const FilteredTripPage(
                      filterType: TripFilterType.processing,
                    );
                  },
                ),
                GoRoute(
                  name: RouteName.tripDetails.name,
                  path: RouteName.tripDetails.name,
                  builder: (context, state) {
                    return LoadDetailsPage(
                      key: state.pageKey,
                    );
                  },
                  routes: <GoRoute>[
                    GoRoute(
                      name: RouteName.eCheck.name,
                      path: RouteName.eCheck.name,
                      builder: (context, state) {
                        return const EcheckPage();
                      },
                    ),
                    GoRoute(
                      name: RouteName.generateEcheck.name,
                      path: RouteName.generateEcheck.name,
                      builder: (context, state) {
                        return const GenerateEcheck();
                      },
                    ),
                    GoRoute(
                      name: RouteName.tripDocuments.name,
                      path: RouteName.tripDocuments.name,
                      builder: (context, state) {
                        return DocumentsPage(
                          DocumentType.tripDocuments,
                          key: state.pageKey,
                        );
                      },
                      routes: <GoRoute>[
                        GoRoute(
                          name: RouteName.documentView.name,
                          path: RouteName.documentView.name,
                          builder: (context, state) {
                            final args = state.extra! as PDFViewerArguments;

                            return PDFViewer(
                              arguments: args,
                            );
                          },
                        )
                      ],
                    ),
                    GoRoute(
                      name: RouteName.stopDetails.name,
                      path: RouteName.stopDetails.name,
                      builder: (context, state) {
                        return const StopDetailsPage();
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
                name: RouteName.settings.name,
                path: RouteName.settings.toRoute,
                builder: (context, state) {
                  return const SettingsPage();
                },
                routes: [
                  GoRoute(
                    name: RouteName.profile.name,
                    path: RouteName.profile.name,
                    builder: (context, state) {
                      return const ProfilePage();
                    },
                    routes: [
                      GoRoute(
                        name: RouteName.editProfile.name,
                        path: RouteName.editProfile.name,
                        builder: (context, state) {
                          return const RequestNotification();
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    name: RouteName.paystubs.name,
                    path: RouteName.paystubs.name,
                    builder: (context, state) {
                      return const DocumentsPage(DocumentType.paystubs);
                    },
                    // routes: [],
                  ),
                  GoRoute(
                    name: RouteName.personalDocuments.name,
                    path: RouteName.personalDocuments.name,
                    builder: (context, state) {
                      return const DocumentsPage(
                          DocumentType.personalDocuments);
                    },
                    // routes: [],
                  ),
                  GoRoute(
                    name: RouteName.tripReport.name,
                    path: RouteName.tripReport.name,
                    builder: (context, state) {
                      return const DocumentsPage(DocumentType.tripReport);
                    },
                    // routes: [],
                  ),
                  GoRoute(
                    name: RouteName.about.name,
                    path: RouteName.about.name,
                    builder: (context, state) {
                      return const AboutPage();
                    },
                    // routes: [],
                  ),
                ]),
          ])
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorScreen(
        exception: state.error,
      ),
    ),
  ),
);
