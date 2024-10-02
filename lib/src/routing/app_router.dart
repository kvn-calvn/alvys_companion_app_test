import 'package:alvys3/src/routing/posthog_route_observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import '../common_widgets/empty_view.dart';
import '../common_widgets/main_bottom_nav.dart';
import '../common_widgets/tablet_view.dart';
import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/authentication/presentation/edit_profile.dart';
import '../features/authentication/presentation/phone_verification_page.dart';
import '../features/authentication/presentation/profile.dart';
import '../features/authentication/presentation/sign_in_page.dart';
import '../features/authentication/presentation/user_details_page.dart';
import '../features/documents/domain/app_document/app_document.dart';
import '../features/documents/presentation/docs_controller.dart';
import '../features/documents/presentation/document_page.dart';
import '../features/documents/presentation/pdf_viewer.dart';
import '../features/documents/presentation/upload_documents.dart';
import '../features/documents/presentation/upload_documents_controller.dart';
import '../features/echeck/presentation/pages/echeck_page.dart';
import '../features/permission/location/presentation/request_location.dart';
import '../features/permission/notification/request_notification.dart';
import '../features/settings/presentation/about_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/trips/presentation/pages/stop_details_page.dart';
import '../features/trips/presentation/pages/trip_details_page.dart';
import '../features/trips/presentation/pages/trips_page.dart';
import '../utils/extensions.dart';
import '../utils/global_error_handler.dart';
import '../utils/magic_strings.dart';
import '../utils/tablet_utils.dart';
import 'custom_observer.dart';
import 'error_page.dart';
import 'landing.dart';

Provider<GoRouter> get getRouter =>
    TabletUtils.instance.isTablet ? tabletRouteProvider : routerProvider;
Provider<GoRouter> routerProvider = Provider(
  (ref) => GoRouter(
    observers: [
      //PosthogObserver(),
      PostHogRouteObserver(),
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      CustomObserver.instance
    ],
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
          routes: [
            GoRoute(
              name: RouteName.verify.name,
              path: RouteName.verify.name,
              builder: (context, state) {
                return const PhoneNumberVerificationPage();
              },
            ),
          ]),
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
      StatefulShellRoute(
          parentNavigatorKey: ref.read(globalErrorHandlerProvider).navKey,
          pageBuilder: (context, state, navigationShell) => NoTransitionPage(
                key: state.pageKey,
                name: state.name,
                child: navigationShell,
              ),
          navigatorContainerBuilder: (context, navigationShell, children) =>
              MainBottomNav(
                navShell: navigationShell,
                children: children,
              ),
          branches: [
            StatefulShellBranch(observers: [
              CustomObserver.instance,
              //PosthogObserver(),
              PostHogRouteObserver()
            ], routes: [
              GoRoute(
                name: RouteName.trips.name,
                path: RouteName.trips.toRoute,
                pageBuilder: (context, state) => CustomTransitionPage(
                  name: RouteName.trips.name,
                  child: const LoadListPage(),
                  transitionDuration: Duration.zero,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) => child,
                ),
                redirect: (context, state) {
                  if (ref.read(authProvider).value!.driver == null) {
                    return RouteName.signIn.toRoute;
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    name: RouteName.tripDetails.name,
                    path: ':tripId',
                    builder: (context, state) {
                      return LoadDetailsPage(
                          state.pathParameters[ParamType.tripId.name]!,
                          int.parse(state.uri
                                  .queryParameters[ParamType.tabIndex.name] ??
                              '0'));
                    },
                    routes: <GoRoute>[
                      GoRoute(
                        name: RouteName.tripDocumentView.name,
                        path: RouteName.tripDocumentView.name,
                        builder: (context, state) {
                          final args = state.extra! as AppDocument;
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
                                tripId: state
                                    .pathParameters[ParamType.tripId.name]!,
                                uploadType: args,
                                documentType:
                                    DisplayDocumentType.tripDocuments),
                          );
                        },
                      ),
                      GoRoute(
                        name: RouteName.eCheck.name,
                        path: RouteName.eCheck.name,
                        builder: (context, state) {
                          return EcheckPage(
                              state.pathParameters[ParamType.tripId.name]!);
                        },
                      ),
                      GoRoute(
                        name: RouteName.stopDetails.name,
                        path: ':stopId',
                        builder: (context, state) {
                          return StopDetailsPage(
                              state.pathParameters[ParamType.tripId.name]!,
                              state.pathParameters[ParamType.stopId.name]!
                              );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(observers: [
              CustomObserver.instance,
              //PosthogObserver()
              PostHogRouteObserver()
            ], routes: [
              GoRoute(
                name: RouteName.profile.name,
                path: RouteName.profile.toRoute,
                pageBuilder: (context, state) => CustomTransitionPage(
                  child: const ProfilePage(),
                  transitionDuration: Duration.zero,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) => child,
                ),
                redirect: (context, state) {
                  if (ref.read(authProvider).value!.driver == null) {
                    return RouteName.signIn.toRoute;
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                    name: RouteName.paystubs.name,
                    path: RouteName.paystubs.name,
                    builder: (context, state) {
                      return DocumentsPage(
                          DocumentsArgs(DisplayDocumentType.paystubs, null));
                    },
                    // routes: [],
                  ),
                  GoRoute(
                    name: RouteName.personalDocumentsList.name,
                    path: RouteName.personalDocumentsList.name,
                    builder: (context, state) {
                      return DocumentsPage(DocumentsArgs(
                          DisplayDocumentType.personalDocuments, null));
                    },
                    routes: [
                      GoRoute(
                        name: RouteName.uploadPersonalDocument.name,
                        path: RouteName.uploadPersonalDocument.name,
                        builder: (context, state) {
                          final args = state.extra! as UploadType;

                          return UploadDocuments(
                            args: UploadDocumentArgs(
                              uploadType: args,
                              documentType:
                                  DisplayDocumentType.personalDocuments,
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
                          DocumentsArgs(DisplayDocumentType.tripReport, null));
                    },
                    routes: [
                      GoRoute(
                        name: RouteName.uploadTripReport.name,
                        path: RouteName.uploadTripReport.name,
                        builder: (context, state) {
                          final args = state.extra! as UploadType;

                          return UploadDocuments(
                            args: UploadDocumentArgs(
                              uploadType: args,
                              documentType: DisplayDocumentType.tripReport,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                      name: RouteName.userDetails.name,
                      path: RouteName.userDetails.name,
                      builder: (context, state) {
                        return const UserDetailsPage();
                      },
                      routes: [
                        GoRoute(
                          name: RouteName.editProfile.name,
                          path: RouteName.editProfile.name,
                          builder: (context, state) {
                            return const EditProfile();
                          },
                        )
                      ]),
                ],
              ),
            ]),
            StatefulShellBranch(observers: [
              //PosthogObserver(),
              PostHogRouteObserver()
            ], routes: [
              GoRoute(
                  name: RouteName.settings.name,
                  path: RouteName.settings.toRoute,
                  pageBuilder: (context, state) => CustomTransitionPage(
                        child: const SettingsPage(),
                        transitionDuration: Duration.zero,
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                child,
                      ),
                  redirect: (context, state) {
                    if (ref.read(authProvider).value!.driver == null) {
                      return RouteName.signIn.toRoute;
                    }
                    return null;
                  },
                  routes: [
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
                        final args = state.extra! as AppDocument;

                        return PDFViewer(
                          arguments: args,
                        );
                      },
                    ),
                  ]),
            ])
          ])
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: ErrorScreen(
        exception: state.error,
      ),
    ),
  ),
);

Provider<GoRouter> tabletRouteProvider = Provider((ref) {
  return GoRouter(
      navigatorKey: ref.read(globalErrorHandlerProvider).navKey,
      initialLocation: ref.read(authProvider).value!.driver == null
          ? RouteName.signIn.toRoute
          : RouteName.emptyView.toRoute,
      debugLogDiagnostics: false,
      observers: [
        PosthogObserver(),
        PostHogRouteObserver(),
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        CustomObserver.instance
      ],
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
            routes: [
              GoRoute(
                name: RouteName.verify.name,
                path: RouteName.verify.name,
                builder: (context, state) {
                  return const PhoneNumberVerificationPage();
                },
              ),
            ]),
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
        StatefulShellRoute(
            parentNavigatorKey: ref.read(globalErrorHandlerProvider).navKey,
            pageBuilder: (context, state, navigationShell) =>
                NoTransitionPage(child: navigationShell),
            navigatorContainerBuilder: (context, navigationShell, children) =>
                TabletView(
                  navigationShell,
                  children,
                ),
            branches: [
              StatefulShellBranch(
                observers: [PosthogObserver(), PostHogRouteObserver()],
                routes: [
                  GoRoute(
                    name: RouteName.emptyView.name,
                    path: RouteName.emptyView.toRoute,
                    builder: (context, state) => const Scaffold(
                      body: EmptyView(
                          title: '',
                          description:
                              'Tap a trip on the left to see the details'),
                    ),
                  )
                ],
              ),
              StatefulShellBranch(observers: [
                CustomObserver.instance,
                PosthogObserver(),
                PostHogRouteObserver()
              ], routes: [
                GoRoute(
                    path: RouteName.trips.toRoute,
                    name: RouteName.trips.name,
                    builder: (context, state) => const Scaffold(),
                    routes: [
                      GoRoute(
                        name: RouteName.tripDetails.name,
                        path: ':tripId',
                        builder: (context, state) {
                          return LoadDetailsPage(
                              state.pathParameters[ParamType.tripId.name]!,
                              int.parse(state.uri.queryParameters[
                                      ParamType.tabIndex.name] ??
                                  '0'));
                        },
                        routes: <GoRoute>[
                          GoRoute(
                            name: RouteName.tripDocumentView.name,
                            path: RouteName.tripDocumentView.name,
                            builder: (context, state) {
                              final args = state.extra! as AppDocument;
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
                                    tripId: state
                                        .pathParameters[ParamType.tripId.name]!,
                                    uploadType: args,
                                    documentType:
                                        DisplayDocumentType.tripDocuments),
                              );
                            },
                          ),
                          GoRoute(
                            name: RouteName.eCheck.name,
                            path: RouteName.eCheck.name,
                            builder: (context, state) {
                              return EcheckPage(
                                  state.pathParameters[ParamType.tripId.name]!);
                            },
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
                    ])
              ]),
              StatefulShellBranch(observers: [
                CustomObserver.instance,
                PosthogObserver(),
                PostHogRouteObserver()
              ], routes: [
                GoRoute(
                  name: RouteName.paystubs.name,
                  path: RouteName.paystubs.toRoute,
                  builder: (context, state) {
                    return DocumentsPage(
                        DocumentsArgs(DisplayDocumentType.paystubs, null));
                  },
                  // routes: [],
                ),
                GoRoute(
                  name: RouteName.personalDocumentsList.name,
                  path: RouteName.personalDocumentsList.toRoute,
                  builder: (context, state) {
                    return DocumentsPage(DocumentsArgs(
                        DisplayDocumentType.personalDocuments, null));
                  },
                  routes: [
                    GoRoute(
                      name: RouteName.uploadPersonalDocument.name,
                      path: RouteName.uploadPersonalDocument.name,
                      builder: (context, state) {
                        final args = state.extra! as UploadType;

                        return UploadDocuments(
                          args: UploadDocumentArgs(
                            uploadType: args,
                            documentType: DisplayDocumentType.personalDocuments,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteName.tripReportDocumentList.name,
                  path: RouteName.tripReportDocumentList.toRoute,
                  builder: (context, state) {
                    return DocumentsPage(
                        DocumentsArgs(DisplayDocumentType.tripReport, null));
                  },
                  routes: [
                    GoRoute(
                      name: RouteName.uploadTripReport.name,
                      path: RouteName.uploadTripReport.name,
                      builder: (context, state) {
                        final args = state.extra! as UploadType;

                        return UploadDocuments(
                          args: UploadDocumentArgs(
                            uploadType: args,
                            documentType: DisplayDocumentType.tripReport,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                    name: RouteName.userDetails.name,
                    path: RouteName.userDetails.toRoute,
                    builder: (context, state) {
                      return const UserDetailsPage();
                    },
                    routes: [
                      GoRoute(
                        name: RouteName.editProfile.name,
                        path: RouteName.editProfile.name,
                        builder: (context, state) {
                          return const EditProfile();
                        },
                      )
                    ]),
              ]),
              StatefulShellBranch(observers: [
                PosthogObserver(),
                PostHogRouteObserver()
              ], routes: [
                GoRoute(
                  name: RouteName.about.name,
                  path: RouteName.about.toRoute,
                  builder: (context, state) {
                    return const AboutPage();
                  },
                  // routes: [],
                ),
                GoRoute(
                  name: RouteName.documentView.name,
                  path: RouteName.documentView.toRoute,
                  builder: (context, state) {
                    final args = state.extra! as AppDocument;

                    return PDFViewer(
                      arguments: args,
                    );
                  },
                ),
              ])
            ])
      ]);
});
