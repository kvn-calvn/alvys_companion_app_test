import 'dart:async';
import 'dart:convert';

import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/global_error_handler.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:alvys3/src/utils/theme_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> mainCommon() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
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

    await Firebase.initializeApp();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

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
