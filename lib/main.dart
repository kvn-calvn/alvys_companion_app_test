import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';

void main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(ProviderScope(child: App()));
  //FlutterNativeSplash.remove();
}
