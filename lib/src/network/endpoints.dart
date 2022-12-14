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

  static String get baseApi => 'https://$rawApiBase/api/';
  static String get mobileBaseApi => '${baseApi}mobilev2/';
  static String tripDocuments(String tripId) =>
      "${mobileBaseApi}getDocumentsByTrip/$tripId";
  static String driverPaystubs(String driverId, String companyCode,
          [int top = 10]) =>
      '${baseApi}billing/QueryPaystubData?UserId=$driverId&CompanyCode=$companyCode&Top=$top';
  static String driverPersonalDocuments =
      "${mobileBaseApi}GetMinifiedDocuments";
}
