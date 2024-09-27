import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/utils/permission_helper.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PostHogService {
  DriverUser? driver;
  PostHogService(this.driver);
  Future<void> postHogTrackEvent(String event, Map<String, Object>? properties) async {
    await Posthog().capture(
      eventName: event,
      properties: properties,
    );
  }

  Future<void> reset() async {
    await Posthog().reset();
  }

  Future<void> postHogIdentify(String userId, [Map<String, Object>? userPropertiesSetOnce]) async {
    Map<String, Object> userProperties = driver != null
        ? {
            'Phone': driver?.phone ?? '',
            'Email': driver?.email ?? '',
            'Name:': driver?.name ?? '',
            'Tenant': driver?.companyCodesWithSpace ?? "",
            "Permissions": await PermissionHelper.getAllUserPermissions(await PermissionHelper.appUserPermissions),
          }
        : {};
    await Posthog()
        .identify(userId: userId, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce);
  }

  Future<void> postHogScreen(
    String screenName,
    Map<String, Object>? properties,
  ) async {
    await Posthog().screen(screenName: screenName, properties: properties);
  }
}
