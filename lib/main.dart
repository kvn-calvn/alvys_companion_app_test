import 'dart:convert';

import 'src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';
import 'src/routing/app_router.dart';

Future<void> main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  var storage = const FlutterSecureStorage();
  String? driverData = await storage.read(key: "driverData");
  DriverUser? driverUser;
  if (driverData != null) {
    driverUser = DriverUser.fromJson(jsonDecode(driverData));
  }
  runApp(ProviderScope(
    overrides: [
      authProvider.overrideWith(() => AuthProviderNotifier(driver: driverUser))
    ],
    child: App(),
  ));
  //FlutterNativeSplash.remove();
}

class Testingr extends ConsumerWidget {
  const Testingr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    return Container();
  }
}

class Tasdga extends ConsumerStatefulWidget {
  const Tasdga({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TasdgaState();
}

class _TasdgaState extends ConsumerState<Tasdga> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return Container();
  }
}
