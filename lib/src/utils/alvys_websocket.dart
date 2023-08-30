import 'dart:convert';

import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/features/trips/domain/model/app_trip/app_trip.dart';
import 'package:alvys3/src/features/trips/presentation/controller/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

final websocketProvider = Provider<AlvysWebsocket>((ref) => AlvysWebsocket(ref: ref));

class AlvysWebsocket {
  HubConnection get getWebSocketConnection {
    // Logger.root.level = Level.ALL;
    // Logger.root.onRecord.listen((LogRecord rec) {
    //   //  debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
    // });
    var headers = MessageHeaders();
    headers.setHeaderValue('CompanyCode', ref.read(authProvider.notifier).tenantCompanyCodes.join(','));
    // headers.setHeaderValue('Authorization', 'Basic ${await getToken()}');
    return HubConnectionBuilder()
        .withUrl(
      ApiRoutes.webSocket,
      options: HttpConnectionOptions(
          requestTimeout: 10000,
          // logger: Logger("SignalR - transport"),
          accessTokenFactory: getToken,
          headers: headers),
    )
//        .configureLogging(Logger("SignalR - hub"))
        .withAutomaticReconnect(retryDelays: [
      0,
      2000,
      10000,
      30000,
      100000,
      9000000,
      9000000,
    ]).build();
  }

  Future<String> getToken() async {
    var storage = const FlutterSecureStorage();
    var res = await storage.read(key: StorageKey.driverToken.name);
    return res ?? '';
  }

  final ProviderRef ref;
  HubConnection? connection;
  AlvysWebsocket({required this.ref});
  Future<void> restartConnection() async {
    if ((await getToken()).isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1), () async {
        if (connection.isNotNull) {
          if (connection!.state == HubConnectionState.Disconnected) {
            try {
              await stopWebsocketConnection();
              await startWebsocketConnection();
            } catch (e) {
              debugPrint('$e');
            }
          }
        } else {
          await startWebsocketConnection();
        }
      });
    }
  }

  Future<void> startWebsocketConnection() async {
    connection ??= getWebSocketConnection;
    await connection?.start();
    updateHandler();
    //await addToGroups();
  }

  Future<void> stopWebsocketConnection() async {
    //   await removeFromGroups();
    await connection?.stop();
  }

  Future<void> addToGroups() async {
    var user = ref.read(authProvider.notifier).stateUser!;
    var args = [user.userTenants.map((e) => e.companyCode!).toList()];
    await connection?.invoke('AddToGroupsAsync', args: args);
  }

  Future<void> removeFromGroups() async {
    var user = ref.read(authProvider.notifier).stateUser!;
    await connection?.invoke('RemoveFromGroupsAsync', args: [user.userTenants.map((e) => e.companyCode!).toList()]);
  }

  void updateHandler() {
    connection?.on(
      "Ping",
      (arguments) {
        debugPrint("from signalr: $arguments");
      },
    );
    connection?.on(
      'TripUpdated',
      (args) {
        try {
          var trip = AppTrip.fromJson(jsonDecode(jsonEncode(args))[0]);
          ref.read(tripControllerProvider.notifier).updateTrip(trip);
        } catch (_) {}
      },
    );
    connection?.on(
      'UserUpdated',
      (args) {
        debugPrint("from signalr: $args");
        try {
          var user = DriverUser.fromJson(jsonDecode(jsonEncode(args))[0]);
          ref.read(authProvider.notifier).updateUser(user);
        } catch (_) {}
      },
    );
  }
}
