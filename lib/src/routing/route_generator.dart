/*import 'package:alvys/app/pages/documents.dart';
import 'package:alvys/app/pages/load_details.dart';
import 'package:alvys/app/pages/load_list.dart';
import 'package:alvys/app/pages/auth/phone_verification.dart';
import 'package:alvys/app/pages/auth/sign_in.dart';*/
import 'package:alvys3/src/features/echeck/ui/echeck_page.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../features/trips/ui/load_list_page.dart';
import 'landing.dart';
import '../features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
import '../features/authentication/presentation/verify_phonenumber/phone_verification_page.dart';
import '../features/trips/ui/load_details_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.name;

    switch (settings.name) {
      case Routes.landingRoute:
        return MaterialPageRoute(builder: (context) => const Landing());
      case Routes.signInRoute:
        return MaterialPageRoute(builder: (context) => SignInPage());
      case Routes.verifyRoute:
        return PageTransition(
            child: const PhoneNumberVerificationPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.tripPageRoute:
        return PageTransition(
            child: const LoadListPage(), type: PageTransitionType.rightToLeft);
      case Routes.tripDetailsRoute:
        return PageTransition(
            child: const LoadDetailsPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.echecksRoute:
        return PageTransition(
            child: const EcheckPage(), type: PageTransitionType.rightToLeft);
      /*case '/loaddocs':
        return PageTransition(
            child: const DocumentsPage(), type: PageTransitionType.rightToLeft);
*/
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
