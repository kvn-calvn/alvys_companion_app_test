import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/features/updater/updater_controller.dart';
import 'src/network/network_info.dart';
import 'src/routing/app_router.dart';
import 'src/utils/app_theme.dart';
import 'src/utils/theme_handler.dart';

class App extends ConsumerStatefulWidget {
  const App(this.isTablet, {super.key});
  final bool isTablet;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        var data = ref.watch(updaterProvider);
        data.whenData((value) => value.showUpdateDialog());
        ref.read(internetConnectionCheckerProvider.notifier).startUpdates();
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        ref.read(internetConnectionCheckerProvider.notifier).stopUpdates();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(internetConnectionCheckerProvider);
    var data = ref.watch(updaterProvider);
    data.whenData((value) => value.showUpdateDialog());
  }

  @override
  Widget build(BuildContext context) {
    final router = widget.isTablet ? ref.read(tabletRouteProvider) : ref.read(routerProvider);
    return MaterialApp.router(
      //useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
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
