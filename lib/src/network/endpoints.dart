import 'package:alvys3/app.dart';
import 'package:alvys3/src/network/environment.dart';

import '../utils/magic_strings.dart';

class Endpoint {
  static String get storageUrl {
    switch (AppEnvironment.environment) {
      case Environment.dev:
        return 'https://alvysstorage.blob.core.windows.net';
      case Environment.qa:
        return 'https://alvysqastorage.blob.core.windows.net';
      case Environment.sandbox:
        return 'https://alvyssandboxstorage.blob.core.windows.net';
    }
  }

  static String get rawApiBase {
    switch (AppEnvironment.environment) {
      case Environment.dev:
        return 'devapi.alvys.com';
      case Environment.qa:
        return 'alvysapi-qa.azurewebsites.net';
      case Environment.sandbox:
        return 'api.alvys.com';
    }
  }
}
