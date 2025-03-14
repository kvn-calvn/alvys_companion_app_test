// import 'package:alvys3/src/features/echeck/presentation/echeck_page.dart';
// import 'package:alvys3/src/features/trips/presentation/stopdetails/stop_details_page.dart';
// import 'package:alvys3/src/features/trips/presentation/trip/filtered_trip_page.dart';
// import 'package:alvys3/src/features/trips/presentation/tripdetails/trip_details_page.dart';
// import 'package:alvys3/src/features/trips/presentation/trip/load_list_page.dart';
// import 'package:alvys3/src/routing/routes.dart';
// import 'package:alvys3/src/utils/magic_strings.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import '../features/documents/presentation/document_page.dart';
// import 'landing.dart';
// import '../features/authentication/presentation/sign_in_phonenumber/sign_in_page.dart';
// import '../features/authentication/presentation/verify_phonenumber/phone_verification_page.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case Routes.landingRoute:
//         return MaterialPageRoute(builder: (context) => const Landing());
//       case Routes.signInRoute:
//         return MaterialPageRoute(builder: (context) => const SignInPage());
//       case Routes.verifyRoute:
//         return PageTransition(
//             child: const PhoneNumberVerificationPage(),
//             type: PageTransitionType.rightToLeft);
//       case Routes.tripPageRoute:
//         return PageTransition(
//             child: const LoadListPage(), type: PageTransitionType.rightToLeft);
//       case Routes.tripDetailsRoute:
//         return PageTransition(
//             child: const LoadDetailsPage(),
//             type: PageTransitionType.rightToLeft);

//       case Routes.echecksRoute:
//         return PageTransition(
//             child: const EcheckPage(), type: PageTransitionType.rightToLeft);
//       case Routes.deliveredTripsRoute:
//         final arguments = settings.arguments as TripFilterType;

//         return PageTransition(
//             child: FilteredTripPage(
//               filterType: arguments,
//             ),
//             type: PageTransitionType.rightToLeft);

//       case Routes.tripDocumentsRoute:
//         return PageTransition(
//             child: const DocumentsPage(DocumentType.personalDocuments),
//             type: PageTransitionType.rightToLeft);
// /*
//       case Routes.pdfViewer:
//         final arguments = settings.arguments as PDFViewerArguments;
//         return PageTransition(
//             child: PDFViewer(documentPath: arguments.docUrl),
//             type: PageTransitionType.rightToLeft);
// */
//       case Routes.stopDetailsRoute:
//         return PageTransition(
//             child: const StopDetailsPage(),
//             type: PageTransitionType.rightToLeft);
//       case Routes.processingTripsRoute:
//         final arguments = settings.arguments as TripFilterType;

//         return PageTransition(
//             child: FilteredTripPage(
//               filterType: arguments,
//             ),
//             type: PageTransitionType.rightToLeft);

//       default:
//         return _errorRoute();
//     }
//   }

//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(builder: (context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Error!'),
//           centerTitle: true,
//         ),
//         body: const Center(
//           child: Text('Page Not Found.'),
//         ),
//       );
//     });
//   }
// }
