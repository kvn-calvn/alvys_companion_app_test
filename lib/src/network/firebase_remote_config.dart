import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final remoteconfigProvider = FutureProvider<FirebaseRemoteConfig>((ref) async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  try {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 5),
    ));
    await remoteConfig.setDefaults({
      "show_refresh_btn ": true,
      "show_tutorial_btn": true,
    });

    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
  } catch (exception) {
    debugPrint("Error initializing Remote Config:$exception");
  }
  return remoteConfig;
});
