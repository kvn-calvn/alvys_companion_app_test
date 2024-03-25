import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_genius_scan/flutter_genius_scan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_trace/stack_trace.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'flavor_config.dart';
//import 'env/env.dart';
import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'src/features/tutorial/tutorial_controller.dart';
import 'src/network/firebase_remote_config_service.dart';
import 'src/network/http_client.dart';
import 'src/network/network_info.dart';
import 'src/utils/exceptions.dart';
import 'src/utils/global_error_handler.dart';
import 'src/utils/magic_strings.dart';
import 'src/utils/platform_channel.dart';
import 'src/utils/provider_args_saver.dart';
import 'src/utils/tablet_utils.dart';
import 'src/utils/theme_handler.dart';

Future<void> mainCommon() async {
  var container = ProviderContainer();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //enableFlutterDriverExtension();
    PlatformChannel.passApiKeys();
    if (FlavorConfig.instance!.flavor == Flavor.prod) {
      FlutterGeniusScan.setLicenseKey(
          Platform.isAndroid
              ? FlavorConfig.instance!.androidGeniusScanSDKKey
              : FlavorConfig.instance!.iosGeniusScanSDKKey,
          autoRefresh: true);
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ErrorWidget.builder = (details) {
      if (details.exception is AppControllerException) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return const Center(child: Text('An internal error occured.'));
    };

    final firebaseRemoteConfigService = FirebaseRemoteConfigService(
      firebaseRemoteConfig: FirebaseRemoteConfig.instance,
    );
    await firebaseRemoteConfigService.init();

    var pref = await SharedPreferences.getInstance();
    String? driverData = pref.getString(SharedPreferencesKey.driverData.name);
    ThemeMode? appThemeMode = ThemeMode.values.byNameOrNull(pref.getString(SharedPreferencesKey.themeMode.name));
    var isTablet = await PlatformChannel.isTablet();
    var firstInstall = pref.getBool(SharedPreferencesKey.firstInstall.name);
    TabletUtils.instance.isTablet = isTablet;
    DriverUser? driverUser;
    var hasInternet = await InternetConnectionChecker().hasConnection;
    var status = pref.getString(SharedPreferencesKey.driverStatus.name);
    if (driverData != null) {
      try {
        driverUser = DriverUser.fromJson(jsonDecode(driverData));
      } catch (e) {
        pref.remove(SharedPreferencesKey.driverData.name);
        driverUser = null;
      }
    }

    container = ProviderContainer(
      overrides: [
        internetConnectionCheckerProvider.overrideWith(() => NetworkNotifier(hasInternet)),
        firebaseRemoteConfigServiceProvider.overrideWith(
          (_) => firebaseRemoteConfigService,
        ),
        sharedPreferencesProvider.overrideWithValue(pref),
        firstInstallProvider.overrideWith(() => FirstInstallNotifier(firstInstall ?? false)),
        authProvider.overrideWith(
            () => AuthProviderNotifier(initDriver: driverUser, status: status?.titleCase ?? DriverStatus.online)),
        themeHandlerProvider.overrideWith(() => ThemeHandlerNotifier(appThemeMode)),
      ],
    );
    if (driverUser != null) {
      await container.read(httpClientProvider).setTelemetryContext(user: driverUser);
    }
    if (Platform.isAndroid && !isTablet) {
      if (isTablet) {
        await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      } else {
        await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      }
    }
    FlutterError.onError = (details) {
      container.read(globalErrorHandlerProvider).handle(details, true);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    FlutterError.demangleStackTrace = (stack) {
      if (stack is Trace) return stack.vmTrace;
      if (stack is Chain) return stack.toTrace().vmTrace;
      return stack;
    };
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
