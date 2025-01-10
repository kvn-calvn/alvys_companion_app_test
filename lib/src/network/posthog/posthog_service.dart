import '../../features/authentication/domain/models/driver_user/driver_user.dart';
import '../../utils/permission_helper.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../../utils/helpers.dart';

class PostHogService {
  DriverUser? driver;
  PostHogService(this.driver);
  Future<void> postHogTrackEvent(String event, Map<String, Object>? properties) async {
    debugPrint("Event: $event, Properties: $properties");
    await Posthog().capture(
      eventName: event,
      properties: properties,
    );
  }

  Future<void> reset() async {
    await Posthog().reset();
  }

  Future<void> postHogIdentify(String userId, [Map<String, Object>? userPropertiesSetOnce]) async {
    var appPermissions = await PermissionHelper.getAllUserPermissions(await PermissionHelper.appUserPermissions);

    Map<String, Object> userProperties = driver != null
        ? {
            'UserID': driver?.id ?? '',
            'UserPhone': driver?.phone ?? '',
            'UserEmail': driver?.email ?? '',
            'UserName': driver?.name ?? '',
            'UserType': driver?.userType ?? '',
            'UserTenantID': driver?.companyCodesWithSpace ?? "",
            'Platform': 'Mobile',
            ...appPermissions.map((key, value) => MapEntry(key.sentenceCase, value as Object))
          }
        : {};

    await Posthog().capture(
      eventName: 'user_app_permissions',
      properties: appPermissions.map((key, value) => MapEntry(key.sentenceCase, value as Object)),
    );
    debugPrint("Extra $userProperties");
    await Posthog()
        .identify(userId: userId, userProperties: userProperties, userPropertiesSetOnce: userPropertiesSetOnce);
  }

  Future<void> postHogScreen(String screenName, [Map<String, Object>? properties]) async {
    await Posthog().screen(screenName: Helpers().toSnakeCase(screenName.trim()).toLowerCase(), properties: properties);
  }
}
