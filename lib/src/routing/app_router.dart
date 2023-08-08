import 'package:alvys3/src/common_widgets/main_bottom_nav.dart';
import 'package:alvys3/src/features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import 'package:alvys3/src/features/authentication/presentation/verify_phonenumber/phone_verification_page.dart';
import 'package:alvys3/src/features/documents/presentation/document_page.dart';
import 'package:alvys3/src/features/documents/presentation/pdf_viewer.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/features/documents/presentation/upload_documents.dart';
import 'package:alvys3/src/features/echeck/presentation/pages/echeck_page.dart';
import 'package:alvys3/src/features/echeck/presentation/pages/generate_echeck.dart';
import 'package:alvys3/src/features/notifications/notification_page.dart';
import 'package:alvys3/src/features/permission/location/presentation/request_location.dart';
import 'package:alvys3/src/features/permission/notification/request_notification.dart';
import 'package:alvys3/src/features/settings/presentation/about_page.dart';
import 'package:alvys3/src/features/settings/presentation/profile_page.dart';
import 'package:alvys3/src/features/settings/presentation/settings_page.dart';
import 'package:alvys3/src/features/trips/presentation/pages/stop_details_page.dart';
import 'package:alvys3/src/features/trips/presentation/pages/filtered_trip_page.dart';
import 'package:alvys3/src/features/trips/presentation/pages/trips_page.dart';
//import 'package:alvys3/src/features/trips/presentation/trip/trip_page_controller.dart';
import 'package:alvys3/src/features/trips/presentation/pages/trip_details_page.dart';
import 'package:alvys3/src/routing/error_page.dart';
import 'package:alvys3/src/routing/landing.dart';
import 'package:alvys3/src/routing/routing_arguments.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/global_error_handler.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/documents/presentation/upload_documents_controller.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

Provider<GoRouter> routerProvider = Provider(
  (ref) => GoRouter(
    navigatorKey: ref.read(globalErrorHandlerProvider).navKey,
    initialLocation: ref.read(authProvider).value!.driver == null
        ? RouteName.signIn.toRoute
        : RouteName.trips.toRoute,
    debugLogDiagnostics: false,
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

      /// tablet shellRoute
      ShellRoute(
        builder: (context, state, child) {
          return MainBottomNav(child: child);
        },
        routes: [
          GoRoute(
            name: RouteName.tabletTrips.name,
            path: RouteName.tabletTrips.toRoute,
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const LoadListPage(),
                transitionDuration: Duration.zero,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child),
          ),
        ],
      ),

      ///phone shell route
      ShellRoute(
          builder: (context, state, child) {
            return MainBottomNav(child: child);
          },
          routes: [
            GoRoute(
              name: RouteName.trips.name,
              path: RouteName.trips.toRoute,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const LoadListPage(),
                transitionDuration: Duration.zero,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
              ),
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
                  path: ':tripId',
                  builder: (context, state) {
                    return LoadDetailsPage(
                        state.pathParameters[ParamType.tripId.name]!);
                  },
                  routes: <GoRoute>[
                    GoRoute(
                        name: RouteName.eCheck.name,
                        path: RouteName.eCheck.name,
                        builder: (context, state) {
                          return EcheckPage(
                              state.pathParameters[ParamType.tripId.name]!);
                        },
                        routes: [
                          GoRoute(
                            name: RouteName.generateEcheck.name,
                            path: RouteName.generateEcheck.name,
                            builder: (context, state) {
                              return GenerateEcheck(
                                  state.pathParameters[ParamType.tripId.name]!);
                            },
                          ),
                        ]),
                    GoRoute(
                      name: RouteName.tripDocumentList.name,
                      path: RouteName.tripDocumentList.name,
                      builder: (context, state) {
                        return DocumentsPage(
                          DocumentsArgs(
                            DocumentType.tripDocuments,
                            state.pathParameters[ParamType.tripId.name],
                          ),
                        );
                      },
                      routes: <GoRoute>[
                        GoRoute(
                          name: RouteName.tripDocumentView.name,
                          path: RouteName.tripDocumentView.name,
                          builder: (context, state) {
                            final args = state.extra! as PDFViewerArguments;

                            return PDFViewer(
                              arguments: args,
                            );
                          },
                        ),
                        GoRoute(
                          name: RouteName.uploadTripDocument.name,
                          path: RouteName.uploadTripDocument.name,
                          builder: (context, state) {
                            final args = state.extra! as UploadType;
                            return UploadDocuments(
                              args: UploadDocumentArgs(
                                  context: context,
                                  tripId: state
                                      .pathParameters[ParamType.tripId.name]!,
                                  uploadType: args,
                                  documentType: DocumentType.tripDocuments),
                            );
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      name: RouteName.stopDetails.name,
                      path: ':stopId',
                      builder: (context, state) {
                        return StopDetailsPage(
                            state.pathParameters[ParamType.tripId.name]!,
                            state.pathParameters[ParamType.stopId.name]!);
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: RouteName.notifications.name,
              path: RouteName.notifications.toRoute,
              pageBuilder: (context, state) => CustomTransitionPage(
                child: const NotificationPage(),
                transitionDuration: Duration.zero,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) => child,
              ),
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
                      return DocumentsPage(
                          DocumentsArgs(DocumentType.paystubs, null));
                    },
                    // routes: [],
                  ),
                  GoRoute(
                    name: RouteName.personalDocumentsList.name,
                    path: RouteName.personalDocumentsList.name,
                    builder: (context, state) {
                      return DocumentsPage(
                          DocumentsArgs(DocumentType.personalDocuments, null));
                    },
                    routes: [
                      GoRoute(
                        name: RouteName.uploadPersonalDocument.name,
                        path: RouteName.uploadPersonalDocument.name,
                        builder: (context, state) {
                          final args = state.extra! as UploadType;

                          return UploadDocuments(
                            args: UploadDocumentArgs(
                              context: context,
                              uploadType: args,
                              documentType: DocumentType.personalDocuments,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    name: RouteName.tripReportDocumentList.name,
                    path: RouteName.tripReportDocumentList.name,
                    builder: (context, state) {
                      return DocumentsPage(
                          DocumentsArgs(DocumentType.tripReport, null));
                    },
                    routes: [
                      GoRoute(
                        name: RouteName.uploadTripReport.name,
                        path: RouteName.uploadTripReport.name,
                        builder: (context, state) {
                          final args = state.extra! as UploadType;

                          return UploadDocuments(
                            args: UploadDocumentArgs(
                              context: context,
                              uploadType: args,
                              documentType: DocumentType.tripReport,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    name: RouteName.about.name,
                    path: RouteName.about.name,
                    builder: (context, state) {
                      return const AboutPage();
                    },
                    // routes: [],
                  ),
                  GoRoute(
                    name: RouteName.documentView.name,
                    path: RouteName.documentView.name,
                    builder: (context, state) {
                      final args = state.extra! as PDFViewerArguments;

                      return PDFViewer(
                        arguments: args,
                      );
                    },
                  ),
                ]),
          ])
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: ErrorScreen(
        exception: state.error,
      ),
    ),
  ),
);
