import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'src/features/tutorial/tutorial_controller.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'flavor_config.dart';
//import 'env/env.dart';
import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'src/utils/extensions.dart';
import 'src/utils/global_error_handler.dart';
import 'src/utils/magic_strings.dart';
import 'src/utils/platform_channel.dart';
import 'src/utils/tablet_utils.dart';
import 'src/utils/theme_handler.dart';

Future<void> mainCommon() async {
  var container = ProviderContainer();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (FlavorConfig.instance!.flavor == Flavor.prod) {
      await FlutterGeniusScan.setLicenceKey(Platform.isAndroid
          ? FlavorConfig.instance!.androidGeniusScanSDKKey
          : FlavorConfig.instance!.iosGeniusScanSDKKey);
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    var storage = const FlutterSecureStorage();
    String? driverData = await storage.read(key: StorageKey.driverData.name);
    ThemeMode? appThemeMode = ThemeMode.values.byNameOrNull(await storage.read(key: StorageKey.themeMode.name));
    var isTablet = await PlatformChannel.isTablet();
    var firstInstall = await storage.read(key: StorageKey.firstInstall.name);
    TabletUtils.instance.isTablet = isTablet;
    DriverUser? driverUser;
    var status = await storage.read(key: StorageKey.driverStatus.name);
    container = ProviderContainer(
      overrides: [
        firstInstallProvider.overrideWith(() => FirstInstallNotifier(firstInstall == null || firstInstall == 'true')),
        authProvider.overrideWith(
            () => AuthProviderNotifier(driver: driverUser, status: status?.titleCase ?? DriverStatus.online)),
        themeHandlerProvider.overrideWith(() => ThemeHandlerNotifier(appThemeMode)),
      ],
    );
    FlutterError.onError = (details) {
      container.read(globalErrorHandlerProvider).handle(details, true);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    FlutterError.demangleStackTrace = (stack) {
      if (stack is Trace) return stack.vmTrace;
      if (stack is Chain) return stack.toTrace().vmTrace;
      return stack;
    };

    if (driverData != null) {
      driverUser = DriverUser.fromJson(jsonDecode(driverData));
    }

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    runApp(UncontrolledProviderScope(
      container: container,
      child: App(isTablet),
    ));
  }, (error, stack) {
    container.read(globalErrorHandlerProvider).handle(null, false, error, stack);
  });
  //FlutterNativeSplash.remove();
}
