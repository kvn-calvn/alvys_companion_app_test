import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/routing/app_router.dart';
import 'src/utils/app_theme.dart';
import 'src/utils/theme_handler.dart';

class App extends ConsumerWidget {
  const App(this.isTablet, {Key? key}) : super(key: key);
  final bool isTablet;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = isTablet ? ref.read(tabletRouteProvider) : ref.read(routerProvider);
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
