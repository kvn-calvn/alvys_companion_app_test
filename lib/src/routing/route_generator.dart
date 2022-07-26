/*import 'package:alvys/app/pages/documents.dart';
import 'package:alvys/app/pages/load_details.dart';
import 'package:alvys/app/pages/load_list.dart';
import 'package:alvys/app/pages/auth/phone_verification.dart';
import 'package:alvys/app/pages/auth/sign_in.dart';*/
import 'package:alvys3/src/features/documents/presentation/trip_docs_page.dart';
import 'package:alvys3/src/features/echeck/presentation/echeck_page.dart';
import 'package:alvys3/src/features/trips/presentation/stopdetails/stop_details_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/filtered_trip_page.dart';
import 'package:alvys3/src/features/trips/presentation/tripdetails/trip_details_page.dart';
import 'package:alvys3/src/features/trips/presentation/trip/load_list_page.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:alvys3/src/routing/routing_arguments.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'landing.dart';
import '../features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import '../features/authentication/presentation/verify_phonenumber/phone_verification_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.name;

    switch (settings.name) {
      case Routes.landingRoute:
        return MaterialPageRoute(builder: (context) => const Landing());
      case Routes.signInRoute:
        return MaterialPageRoute(builder: (context) => const SignInPage());
      case Routes.verifyRoute:
        return PageTransition(
            child: const PhoneNumberVerificationPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.tripPageRoute:
        return PageTransition(
            child: const LoadListPage(), type: PageTransitionType.rightToLeft);
      case Routes.tripDetailsRoute:
        final arguments = settings.arguments as TripDetailsArguments;
        return PageTransition(
            child: LoadDetailsPage(
              tripId: arguments.tripId,
              tripNumber: arguments.tripNumber,
            ),
            type: PageTransitionType.rightToLeft);

      case Routes.echecksRoute:
        final arguments = settings.arguments as EcheckArguments;
        return PageTransition(
            child: EcheckPage(tripId: arguments.tripId),
            type: PageTransitionType.rightToLeft);
      case Routes.deliveredTripsRoute:
        final arguments = settings.arguments as FilteredTripsArguments;

        return PageTransition(
            child: FilteredTripPage(
              trips: arguments.data,
              title: arguments.title,
            ),
            type: PageTransitionType.rightToLeft);

      case Routes.tripDocumentsRoute:
        final arguments = settings.arguments as TripDocsArguments;
        return PageTransition(
            child: TripDocsPage(tripId: arguments.tripId),
            type: PageTransitionType.rightToLeft);

      case Routes.stopDetailsRoute:
        final arguments = settings.arguments as StopDetailsArguments;
        return PageTransition(
            child: StopDetailsPage(
              tripId: arguments.tripId,
              stopId: arguments.stopId,
            ),
            type: PageTransitionType.rightToLeft);
      case Routes.processingTripsRoute:
        final arguments = settings.arguments as FilteredTripsArguments;

        return PageTransition(
            child: FilteredTripPage(
              trips: arguments.data,
              title: arguments.title,
            ),
            type: PageTransitionType.rightToLeft);

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error!'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Page Not Found.'),
        ),
      );
    });
  }
}
