import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_remote_config_service.g.dart';

@riverpod
FirebaseRemoteConfigService firebaseRemoteConfigService(_) {
  throw UnimplementedError();
}

class FirebaseRemoteConfigService {
  const FirebaseRemoteConfigService({
    required this.firebaseRemoteConfig,
  });

  final FirebaseRemoteConfig firebaseRemoteConfig;

  Future<void> init() async {
    try {
      await firebaseRemoteConfig.ensureInitialized();
      await firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await firebaseRemoteConfig.setDefaults({
        "show_refresh_btn ": true,
        "show_tutorial_btn": true,
      });
      await firebaseRemoteConfig.fetchAndActivate();
    } catch (exception) {
      debugPrint("Error initializing Remote Config:$exception");
    }
  }

  bool showRefreshBtn() => firebaseRemoteConfig.getBool('show_refresh_btn');
  bool showTutorialBtn() => firebaseRemoteConfig.getBool('show_tutorial_btn');
}
