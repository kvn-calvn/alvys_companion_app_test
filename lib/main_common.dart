import 'dart:async';
import 'dart:convert';

import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/global_error_handler.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:alvys3/src/utils/theme_handler.dart';

import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';

Future<void> mainCommon() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //await FlutterGeniusScan.setLicenceKey(Env.geniusScanKey);
    var storage = const FlutterSecureStorage();
    FlutterError.onError = (details) {
      GlobalErrorHandler.handle(details, true);
    };

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
      child: App(driverUser),
    ));
  }, (error, stack) {
    GlobalErrorHandler.handle(null, false, error, stack);
  });
  //FlutterNativeSplash.remove();
}
