import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alvys3/flavor_config.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/global_error_handler.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:alvys3/src/utils/theme_handler.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';

//import 'env/env.dart';
import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';

Future<void> mainCommon() async {
  var container = ProviderContainer();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (FlavorConfig.instance!.flavor == Flavor.prod) {
      await FlutterGeniusScan.setLicenceKey(Platform.isAndroid
          ? FlavorConfig.instance!.androidGeniusScanSDKKey
          : FlavorConfig.instance!.iosGeniusScanSDKKey);
    }
    var storage = const FlutterSecureStorage();
    String? driverData = await storage.read(key: StorageKey.driverData.name);
    ThemeMode? appThemeMode = ThemeMode.values
        .byNameOrNull(await storage.read(key: StorageKey.themeMode.name));
    DriverUser? driverUser;
    container = ProviderContainer(
      overrides: [
        authProvider
            .overrideWith(() => AuthProviderNotifier(driver: driverUser)),
        themeHandlerProvider
            .overrideWith(() => ThemeHandlerNotifier(appThemeMode)),
      ],
    );
    FlutterError.onError = (details) {
      container.read(globalErrorHandlerProvider).handle(details, true);
    };
    FlutterError.demangleStackTrace = (details) {
      return details;
    };

    if (driverData != null) {
      driverUser = DriverUser.fromJson(jsonDecode(driverData));
    }
    runApp(UncontrolledProviderScope(
      container: container,
      child: App(driverUser),
    ));
  }, (error, stack) {
    container
        .read(globalErrorHandlerProvider)
        .handle(null, false, error, stack);
  });
  //FlutterNativeSplash.remove();
}
