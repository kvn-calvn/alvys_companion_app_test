import 'dart:convert';

import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore2/ihub_protocol.dart';
import 'package:signalr_netcore2/signalr_client.dart';

import '../constants/api_routes.dart';
import '../features/authentication/domain/models/user_details/user_details.dart';
import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/trips/domain/app_trip/app_trip.dart';
import '../features/trips/presentation/controller/trip_page_controller.dart';
import 'magic_strings.dart';
import 'provider_args_saver.dart';

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
    var pref = ref.read(sharedPreferencesProvider)!;
    var res = pref.getString(SharedPreferencesKey.driverToken.name);
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
  }

  Future<void> stopWebsocketConnection() async {
    await connection?.stop();
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
          if (trip.stops.isNullOrEmpty || !ref.exists(tripControllerProvider)) return;
          ref.read(tripControllerProvider.notifier).updateTrip(trip);
        } catch (_) {}
      },
    );
    connection?.on(
      'UserUpdated',
      (args) {
        debugPrint("from signalr: $args");
        try {
          var user = UserDetails.fromJson(jsonDecode(jsonEncode(args))[0]);
          ref.read(authProvider.notifier).updateUserFromDetails(user);
        } catch (_) {}
      },
    );
  }
}
