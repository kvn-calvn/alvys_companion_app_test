import 'dart:async';
import 'dart:convert';

import 'package:alvys3/flavor_config.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/alvys_websocket.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/extensions.dart';
import '../../../utils/helpers.dart';
import '../../../utils/magic_strings.dart';
import '../../../utils/permission_helper.dart';
import '../../../utils/platform_channel.dart';
import '../../../utils/provider_args_saver.dart';
import '../data/auth_repository.dart';
import '../domain/models/auth_state/auth_state.dart';
import '../domain/models/driver_user/driver_user.dart';
import '../domain/models/driver_user/user_tenant.dart';
import '../domain/models/update_driver_status_dto/update_driver_status_dto.dart';
import '../domain/models/update_user_dto/update_user_dto.dart';
import '../domain/models/user_details/user_details.dart';

class AuthProviderNotifier extends AsyncNotifier<AuthState> implements IErrorHandler {
  final DriverUser? initDriver;
  String? status;
  late AuthRepository<AuthProviderNotifier> authRepo;
  late SharedPreferences pref;
  AuthProviderNotifier({this.initDriver, this.status});
  @override
  FutureOr<AuthState> build() {
    authRepo = ref.read(authRepoProvider);
    pref = ref.read(sharedPreferencesProvider)!;
    state = AsyncValue.data(AuthState(driver: initDriver, driverStatus: status, driverLoggedIn: initDriver != null));
    return state.value!;
  }

  void setUserTenantCompanyCode(String? companyCode) {
    state = AsyncValue.data(state.value!.copyWith(userTenantCompanyCode: companyCode));
  }

  void setPhone(String? p) {
    state = AsyncValue.data(state.value!.copyWith(phone: p.numbersOnly));
  }

  void setVerificationCode(String v) {
    state = AsyncValue.data(state.value!.copyWith(verificationCode: v.numbersOnly));
  }

  void logOutDriver() {
    state = AsyncValue.data(state.value!.copyWith(phone: '', verificationCode: '', driverLoggedIn: false));
  }

  DriverUser? get driver => state.value!.driver;

  Future<void> verifyDriver(BuildContext context) async {
    state = const AsyncValue.loading();
    var driverRes = await authRepo.verifyDriverCode(state.value!.phone, state.value!.verificationCode);
    var driverTenant = driverRes.userTenants.length == 1
        ? driverRes.userTenants.firstOrNull
        : driverRes.userTenants.firstWhereOrNull((element) => element.companyOwnedAsset ?? false);
    await pref.setString(SharedPreferencesKey.driverData.name, driverRes.toJson().toJsonEncodedString);
    await pref.setString(
      SharedPreferencesKey.driverToken.name,
      base64.encode(utf8.encode("${driverRes.userName}:${driverRes.appToken ?? driverRes.currentToken?.accessToken}")),
    );
    String? driverStatus;
    if (driverTenant != null) {
      var driverAsset = await authRepo.getDriverAsset(driverTenant.companyCode!, driverTenant.assetId!);
      await pref.setString(
          SharedPreferencesKey.driverStatus.name, DriverStatus.initStatus(driverAsset.status).titleCase);
      driverStatus = DriverStatus.initStatus(driverAsset.status).titleCase;
    }
    state = AsyncValue.data(
        state.value!.copyWith(driver: driverRes, driverStatus: driverStatus?.titleCase, hasLoginError: false));
    if (driverStatus.equalsIgnoreCase(DriverStatus.offDuty)) {
      await initDriverStatus(DriverStatus.online);
    }
    await FirebaseAnalytics.instance.setUserId(id: driverRes.phone);
    await FirebaseAnalytics.instance.setUserProperty(name: 'driverId', value: driverRes.phone);
    await FirebaseCrashlytics.instance.setUserIdentifier(driverRes.phone.toString());

    var locationStatus = await Permission.location.status;
    var notificationStatus = await Permission.notification.status;

    if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
      if (context.mounted) context.goNamed(RouteName.locationPermission.name);
    } else if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
      if (context.mounted) {
        context.goNamed(RouteName.notificationPermission.name);
      }
    } else {
      debugPrint("GO_STRAIGHT_HOME");
/*
      if (Platform.isIOS) {
        PlatformChannel.getNotification(user.phone);
      } else if (Platform.isAndroid) {
        AlvysNotficationHub.startNotificationService(
            user.phone,
            ServiceGlobals.notificationHubUrl,
            ServiceGlobals.notificationHubName);
      }*/
      if (context.mounted) context.goNamed(RouteName.trips.name);
    }

    //state = AsyncValue.data(state.value!);
  }

  Future<void> signInDriver(BuildContext context) async {
    state = const AsyncValue.loading();
    await authRepo.signInDriverByPhone(state.value!.phone);

    if (context.mounted) context.goNamed(RouteName.verify.name);
    state = AsyncValue.data(state.value!);
  }

  Future<void> resendCode() async {
    await authRepo.signInDriverByPhone(state.value!.phone);
  }

  Future<void> signOut(BuildContext context) async {
    GoRouter.of(context).goNamed(RouteName.signIn.name);

    if (await Permission.location.isGranted) {
      debugPrint("isGranted");
      PlatformChannel.stopLocationTracking();
    }
    unRegisterForNotification();
    //PlatformChannel.stopLocationTracking();

    await ref.read(websocketProvider).stopWebsocketConnection();
    resetFields();
    await pref.remove(SharedPreferencesKey.driverData.name);
    await pref.remove(SharedPreferencesKey.driverToken.name);
    await pref.remove(SharedPreferencesKey.driverStatus.name);
    state = AsyncValue.data(state.value!.copyWith(driver: null));
  }

  void resetFields() {
    state = AsyncValue.data(state.value!.copyWith(
      phone: '',
      verificationCode: '',
    ));
  }

  Future<void> registerForNotification() async {
    var notificationPermission = await PermissionHelper.getPermission(Permission.notification);
    if (notificationPermission) {
      PlatformChannel.getNotification(
          state.value!.driver!.phone!, FlavorConfig.instance!.hubName, FlavorConfig.instance!.connectionString);
    }
  }

  Future<void> unRegisterForNotification() async {
    PlatformChannel.unregisterNotification();
  }

  void updateUser(DriverUser user) {
    if (state.value?.driver != null) {
      state = AsyncValue.data(state.value!.copyWith(driver: user));
      pref.setString(SharedPreferencesKey.driverData.name, user.toJson().toJsonEncodedString);
      pref.setString(
        SharedPreferencesKey.driverToken.name,
        base64.encode(utf8.encode("${user.userName}:${user.appToken ?? user.currentToken?.accessToken}")),
      );
    }
  }

  Future<void> updateUserProfile<K>(UpdateUserDTO dto) async {
    var res = await authRepo.updateDriverUser<K>(getCompanyOwned.companyCode!, dto);
    updateUser(res);
  }

  Future<void> updateDriverStatus(String? s) async {
    if (s != null) {
      status = state.value!.driverStatus;
      state = AsyncValue.data(state.value!.copyWith(driverStatus: s));

      await initDriverStatus(s);
      await pref.setString(SharedPreferencesKey.driverStatus.name, s);
    }
  }

  Future<void> initDriverStatus(String status) async {
    var location = await Helpers.getUserPosition(() {
      state = AsyncValue.data(state.value!.copyWith(driverStatus: status));
    });
    var dto = UpdateDriverStatusDTO(
        status: status.toUpperCase(), id: '', latitude: location.latitude, longitude: location.longitude);
    await authRepo.updateDriverStatus(getCompanyOwned.companyCode!, dto);
  }

  void updateUserFromDetails(UserDetails user) {
    if (state.value?.driver != null) {
      var driverUser = state.value!.driver!.copyWith(
          email: user.email,
          phone: user.phone,
          userTenants: user.userTenants
              .map((e) => state.value!.driver!.userTenants
                  .firstWhereOrNull((element) => element.companyCode == e.companyCode)
                  ?.copyWith(permissions: e.permissions))
              .removeNulls
              .toList());
      updateUser(driverUser);
    }
  }

  List<String> get tenantCompanyCodes => state.value!.driver!.userTenants
      .where((t) => t.companyCode.isNotNullOrEmpty)
      .map<String>((e) => e.companyCode!)
      .toList();

  UserTenant? getCurrentUserTenant(String companyCode) =>
      state.value!.driver!.userTenants.firstWhereOrNull((element) => element.companyCode == companyCode);
  UserTenant get getCompanyOwned =>
      state.value!.driver!.userTenants
          .firstWhereOrNull((element) => (element.companyOwnedAsset ?? false) && !(element.isDisabled ?? true)) ??
      state.value!.driver!.userTenants.first;

  Future<void> refreshDriverUser() async {
    var res = await authRepo.getDriverUser(getCompanyOwned.companyCode!, driver!.id!);
    var driverTenant = res.userTenants
        .firstWhereOrNull((element) => (element.companyOwnedAsset ?? false) && !(element.isDisabled ?? true));
    updateUser(res);
    if (driverTenant != null) {
      var driverAsset = await authRepo.getDriverAsset(driverTenant.companyCode!, driverTenant.assetId!);
      await pref.setString(
          SharedPreferencesKey.driverStatus.name, DriverStatus.initStatus(driverAsset.status).titleCase);
      state =
          AsyncValue.data(state.value!.copyWith(driverStatus: DriverStatus.initStatus(driverAsset.status).titleCase));
    }
  }

  @override
  FutureOr<void> onError(Exception ex) {
    state = AsyncValue.data(status == null
        ? state.value!
        : state.value!.copyWith(
            driverStatus: status,
            hasLoginError: ex is AlvysClientException ? true : state.value!.hasLoginError,
          ));
  }

  @override
  FutureOr<void> refreshPage(String page) async {
    await refreshDriverUser();
  }
}

var authProvider = AsyncNotifierProvider<AuthProviderNotifier, AuthState>(AuthProviderNotifier.new);


// ACCEPT NOT WORKING
// connection issues: reaccept, error in backend
// integration not available (extreme)

// TENDER NOT AVAILABLE

