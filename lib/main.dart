import 'dart:convert';

import 'package:alvys3/src/features/authentication/domain/models/auth_state/auth_state.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/network/user_token_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';

Future<void> main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  var storage = const FlutterSecureStorage();
  String? driverData = await storage.read(key: "driverData");
  if (driverData != null) {
    var driverUser = DriverUser.fromJson(jsonDecode(driverData));
    authProvider = AsyncNotifierProvider<AuthProviderNotifier, AuthState>(
        () => AuthProviderNotifier(driver: driverUser));
  }
  runApp(ProviderScope(child: App()));
  //FlutterNativeSplash.remove();
}
