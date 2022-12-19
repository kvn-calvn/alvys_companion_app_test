import 'dart:async';
import 'dart:convert';

import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:alvys3/src/utils/theme_handler.dart';

import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';

Future<void> main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // late GlobalKey<NavigatorState> navKey;

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
    var storage = const FlutterSecureStorage();
    FlutterError.onError = (details) => showDialog(
        context: navKey.currentState!.context,
        builder: (context) => const AlertDialog());
    String? driverData = await storage.read(key: StorageKey.driverData.name);
    ThemeMode? appThemeMode = ThemeMode.values
        .byNameOrNull(await storage.read(key: StorageKey.themeMode.name));
    DriverUser? driverUser;
    if (driverData != null) {
      driverUser = DriverUser.fromJson(jsonDecode(driverData));
    }
    runApp(ProviderScope(
      overrides: [
        authProvider
            .overrideWith(() => AuthProviderNotifier(driver: driverUser)),
        themeHandlerProvider
            .overrideWith(() => ThemeHandlerNotifier(appThemeMode)),
      ],
      child: App(navKey, driverUser),
    ));
  }, (error, stack) {});
  //FlutterNativeSplash.remove();
}
