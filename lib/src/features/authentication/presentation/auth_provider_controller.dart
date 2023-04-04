import 'dart:async';
import 'dart:convert';

import 'package:alvys3/src/features/authentication/data/auth_repository.dart';
import 'package:alvys3/src/features/authentication/data/data_providers.dart';
import 'package:alvys3/src/features/authentication/domain/models/auth_state/auth_state.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/user_tenant.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common_widgets/main_bottom_nav.dart';

class AuthProviderNotifier extends AsyncNotifier<AuthState>
    implements IAppErrorHandler {
  final DriverUser? driver;
  late AuthRepository<AuthProviderNotifier> authRepo;
  AuthProviderNotifier({this.driver});
  @override
  FutureOr<AuthState> build() {
    authRepo = ref.read(authRepoProvider);
    state = AsyncValue.data(
        AuthState(driver: driver, driverLoggedIn: driver != null));
    return state.value!;
  }

  void setUserTenantCompanyCode(String? companyCode) {
    state = AsyncValue.data(
        state.value!.copyWith(userTenantCompanyCode: companyCode));
  }

  void setPhone(String? p) {
    state = AsyncValue.data(state.value!.copyWith(phone: p.numbersOnly));
  }

  void setVerificationCode(String v) {
    state =
        AsyncValue.data(state.value!.copyWith(verificationCode: v.numbersOnly));
  }

  void setDriverUserData(DriverUser? data) {
    state = AsyncValue.data(
        state.value!.copyWith(driver: data, driverLoggedIn: driver != null));
  }

  void logOutDriver() {
    state = AsyncValue.data(state.value!
        .copyWith(phone: '', verificationCode: '', driverLoggedIn: false));
  }

  Future<void> verifyDriver(BuildContext context, bool mounted) async {
    state = const AsyncValue.loading();
    var driverRes = await authRepo.verifyDriverCode(
        state.value!.phone, state.value!.verificationCode);
    var storage = const FlutterSecureStorage();
    state = AsyncValue.data(state.value!.copyWith(driver: driverRes.data));
    await storage.write(
        key: StorageKey.driverData.name, value: driverRes.data!.toStringJson());
    await storage.write(
      key: StorageKey.driverToken.name,
      value: base64.encode(
        utf8.encode("${driverRes.data!.userName}:${driverRes.data!.appToken}"),
      ),
    );

    var locationStatus = await Permission.location.status;
    var notificationStatus = await Permission.notification.status;

    if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
      if (mounted) context.goNamed(RouteName.locationPermission.name);
    } else if (notificationStatus.isDenied ||
        notificationStatus.isPermanentlyDenied) {
      if (mounted) context.goNamed(RouteName.notificationPermission.name);
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
      if (mounted) context.goNamed(RouteName.trips.name);
    }

    state = AsyncValue.data(state.value!);
  }

  Future<void> signInDriver(BuildContext context, bool mounted) async {
    state = const AsyncValue.loading();
    await authRepo.signInDriverByPhone(state.value!.phone);

    if (mounted) context.pushNamed(RouteName.verify.name);
    state = AsyncValue.data(state.value!);
  }

  Future<void> resendCode() async {
    await authRepo.signInDriverByPhone(state.value!.phone);
  }

  Future<void> signOut(BuildContext context) async {
    GoRouter.of(context).goNamed(RouteName.signIn.name);
    var storage = const FlutterSecureStorage();
    ref.read(bottomNavIndexProvider.notifier).update((state) => 0);
    resetFields();
    await storage.delete(key: StorageKey.driverData.name);
    await storage.delete(key: StorageKey.driverToken.name);
  }

  void resetFields() {
    state = AsyncValue.data(state.value!.copyWith(
      phone: '',
      verificationCode: '',
    ));
  }

  List<String> get tenantCompanyCodes => state.value!.driver!.userTenants
      .map<String>((e) => e.companyCode!)
      .toList();

  UserTenant? getCurrentUserTenant(String companyCode) =>
      state.value!.driver!.userTenants
          .firstOrNull((element) => element.companyCode == companyCode);

  @override
  FutureOr<void> onError() {
    state = AsyncValue.data(state.value!);
  }
}

var authProvider = AsyncNotifierProvider<AuthProviderNotifier, AuthState>(
    AuthProviderNotifier.new);
