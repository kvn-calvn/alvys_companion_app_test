import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/routing/app_router.dart';
import 'package:alvys3/src/utils/app_theme.dart';
import 'package:alvys3/src/utils/theme_handler.dart';
//import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import './src/routing/route_generator.dart';

class App extends ConsumerWidget {
  const App(this.driver, {Key? key}) : super(key: key);
  final DriverUser? driver;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);
    return MaterialApp.router(
      //useInheritedMediaQuery: true,
      themeMode: ref.watch(themeHandlerProvider),
      theme: AlvysTheme.mainTheme(Brightness.light),
      darkTheme: AlvysTheme.mainTheme(Brightness.dark),
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
