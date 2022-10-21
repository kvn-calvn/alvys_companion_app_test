import 'package:alvys3/src/routing/app_router.dart';
//import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import './src/routing/route_generator.dart';

class App extends ConsumerWidget {
  //const App({Key? key}) : super(key: key);
  const App._internal();

  static const App instance = App._internal();
  factory App() => instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}

/*class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: Routes.signInRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}*/
