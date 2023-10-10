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
        "alvys_help_url": "https://alvys.com/help/",
        "alvys_url": "https://alvys.com/",
        "alvys_terms_url": "https://alvys.com/terms/",
        "alvys_privacy_url": "https://alvys.com/privacy/",
        "show_company_code": false
      });
      await firebaseRemoteConfig.fetchAndActivate();
      firebaseRemoteConfig.onConfigUpdated.listen((event) {
        debugPrint("\n \n ${event.updatedKeys}");
      });
    } catch (exception) {
      debugPrint("Error initializing Remote Config:$exception");
    }
  }

  bool showRefreshBtn() => firebaseRemoteConfig.getBool('show_refresh_btn');
  bool showTutorialBtn() => firebaseRemoteConfig.getBool('show_tutorial_btn');
  String alvysHelpUrl() => firebaseRemoteConfig.getString('alvys_help_url');
  String alvysUrl() => firebaseRemoteConfig.getString('alvys_url');
  String alvysTermsUrl() => firebaseRemoteConfig.getString('alvys_terms_url');
  String alvysPrivacyUrl() =>
      firebaseRemoteConfig.getString('alvys_privacy_url');
  bool showCompanyCode() => firebaseRemoteConfig.getBool('show_company_code');
}
