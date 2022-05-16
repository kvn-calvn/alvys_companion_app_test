import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import './src/routing/route_generator.dart';

class App extends StatefulWidget {
  //const App({Key? key}) : super(key: key);
  const App._internal();

  static const App instance = App._internal();
  factory App() => instance;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: Routes.signInRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
