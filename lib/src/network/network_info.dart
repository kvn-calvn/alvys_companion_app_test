import 'dart:async';

import '../utils/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkNotifier extends Notifier<bool> {
  bool? initConnection;
  bool _hasInsert = false;
  late GlobalErrorHandler errorHandler;
  OverlayEntry noInternetOverlay = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.red,
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                child: Text(
                  'No internet',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
  NetworkNotifier([this.initConnection]);
  @override
  bool build() {
    errorHandler = ref.read(globalErrorHandlerProvider);
    state = initConnection ?? true;
    updateOverlay();
    InternetConnectionChecker().onStatusChange.listen((event) {
      state = event == InternetConnectionStatus.connected;
      updateOverlay();
    });
    // Timer.periodic(const Duration(seconds: 30), (timer) async {
    //   state = await InternetConnectionChecker().hasConnection;
    //   updateOverlay();
    // });
    return state;
  }

  void updateOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!state) {
        if (!_hasInsert) {
          //if (errorHandler.navKey.currentState?.overlay != null) {
          errorHandler.navKey.currentState?.overlay!.insert(noInternetOverlay);
          _hasInsert = true;
          //}
        }
      } else {
        if (_hasInsert) {
          noInternetOverlay.remove();
          _hasInsert = false;
        }
      }
    });
  }

  bool get hasInternet => state;
}
// class NetworkInfoImpl implements NetworkInfo {
//   final InternetConnectionChecker _internetConnectionChecker;

//   NetworkInfoImpl(this._internetConnectionChecker);

//   @override
//   Future<bool> get isConnected => _internetConnectionChecker.hasConnection;
// }
final internetConnectionCheckerProvider =
    NotifierProvider<NetworkNotifier, bool>(NetworkNotifier.new);
// final internetConnectionCheckerProvider = Provider<InternetConnectionChecker>((ref) => InternetConnectionChecker());
