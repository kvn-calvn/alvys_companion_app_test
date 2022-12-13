import 'dart:convert';

import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';
import 'src/routing/app_router.dart';

Future<void> main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  var storage = const FlutterSecureStorage();
  String? driverData = await storage.read(key: "driverData");
  DriverUser? driverUser;
  if (driverData != null) {
    driverUser = DriverUser.fromJson(jsonDecode(driverData));
  }
  runApp(ProviderScope(
    overrides: [
      authProvider.overrideWith(() => AuthProviderNotifier(driver: driverUser))
    ],
    child: App(),
  ));
  //FlutterNativeSplash.remove();
}
