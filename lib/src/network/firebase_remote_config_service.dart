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
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 12),
        ),
      );
      await firebaseRemoteConfig.setDefaults({
        "show_refresh_btn ": true,
        "show_tutorial_btn": true,
        "alvys_help_url": "https://alvys.com/help/",
        "alvys_url": "https://alvys.com/",
        "alvys_terms_url": "https://alvys.com/terms/",
        "alvys_privacy_url": "https://alvys.com/privacy/",
        "show_company_code": false,
        "edit_profile": false,
        "show_distance": false,
        "login_title": "Let's get you set up",
        "login_message":
            "This app is for the drivers of current Alvys customers. If you're a driver, you're in the right place, just make sure the office has registered your cell phone number in the main Alvys platform.",
        "login_error_message":
            "Please ask the office to add your phone number in Alvys.",
        "sales_url": "https://alvys.com/try-for-free-landing-page/",
        "support_url": "mailto:support@alvys.com?subject=Login%20Help",
        "copy_support_email": "support@alvys.com"
      });
      await firebaseRemoteConfig.fetchAndActivate();
    } catch (exception) {
      debugPrint("Error initializing Remote Config:$exception");
    }
  }

  bool showRefreshBtn() => firebaseRemoteConfig.getBool('show_refresh_btn');
  bool showTutorialBtn() => firebaseRemoteConfig.getBool('show_tutorial_btn');
  bool showEditProfileBtn() => firebaseRemoteConfig.getBool('edit_profile');
  String alvysHelpUrl() => firebaseRemoteConfig.getString('alvys_help_url');
  String alvysUrl() => firebaseRemoteConfig.getString('alvys_url');
  String alvysTermsUrl() => firebaseRemoteConfig.getString('alvys_terms_url');
  String alvysPrivacyUrl() =>
      firebaseRemoteConfig.getString('alvys_privacy_url');
  bool showCompanyCode() => firebaseRemoteConfig.getBool('show_company_code');
  bool showTooFarDistance() => firebaseRemoteConfig.getBool('show_distance');
  String loginTitle() => firebaseRemoteConfig.getString('login_title');
  String loginMessage() => firebaseRemoteConfig.getString('login_message');
  String salesUrl() => firebaseRemoteConfig.getString('sales_url');
  String supportUrl() => firebaseRemoteConfig.getString('support_url');
  String copySupportEmail() =>
      firebaseRemoteConfig.getString('copy_support_email');
  String loginErrorMessage() =>
      firebaseRemoteConfig.getString('login_error_message');
}
