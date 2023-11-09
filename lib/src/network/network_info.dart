import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../features/trips/presentation/controller/trip_page_controller.dart';
import '../utils/exceptions.dart';
import '../utils/global_error_handler.dart';
import '../utils/magic_strings.dart';

class NetworkNotifier extends Notifier<bool> {
  Map<String, IAppErrorHandler> get refreshControllers => {
        RouteName.trips.name: ref.read(tripControllerProvider.notifier),
        RouteName.tripDetails.name: ref.read(tripControllerProvider.notifier),
      };
  bool? initConnection;
  bool _hasInsert = false;
  late GlobalErrorHandler errorHandler;
  late OverlayEntry noInternetOverlay;
  late InternetConnectionChecker checker;
  Stream<bool>? internetUpdate;
  Stream<ConnectivityResult>? connectionUpdate;
  late StreamSubscription<ConnectivityResult>? connectionSubscription;
  late StreamSubscription<bool>? internetSubscription;
  NetworkNotifier([this.initConnection]) {
    checker = InternetConnectionChecker.createInstance(checkTimeout: const Duration(minutes: 2));
  }
  @override
  bool build() {
    state = initConnection ?? true;
    initState();
    return state;
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      errorHandler = ref.read(globalErrorHandlerProvider);
      updateOverlay(!state);
      internetSubscription = internetUpdate?.listen((event) {
        var oldState = state;
        state = event;
        updateOverlay(oldState);
      });
      connectionSubscription = connectionUpdate?.listen((event) async {
        var oldState = state;
        state = event == ConnectivityResult.none ? false : await checker.hasConnection;
        updateOverlay(oldState);
      });
    });
  }

  void stopUpdates() {
    internetUpdate = null;
    connectionUpdate = null;
    connectionSubscription?.cancel();
    internetSubscription?.cancel();
  }

  void startUpdates() {
    internetUpdate = internetConnectionStream;
    connectionUpdate = Connectivity().onConnectivityChanged;
    initState();
  }

  void setInternetState(bool internetState) => state = internetState;
  Stream<bool> get internetConnectionStream {
    return Stream.periodic(const Duration(seconds: 30), (index) => checker.hasConnection).asyncMap((event) => event);
  }

  void updateOverlay(bool oldState) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (state == oldState) return;
      if (!state) {
        if (!_hasInsert) {
          noInternetOverlay = OverlayEntry(builder: (context) => NoInternetWidget(noInternetOverlay.remove));
          errorHandler.navKey.currentState!.overlay!.insert(noInternetOverlay);
          _hasInsert = true;
        }
      } else {
        if (_hasInsert) {
          _hasInsert = false;
        }
      }
    });
  }

  bool get hasInternet => state;
}

final internetConnectionCheckerProvider = NotifierProvider<NetworkNotifier, bool>(NetworkNotifier.new);

class NoInternetWidget extends ConsumerStatefulWidget {
  final void Function() removeBanner;
  const NoInternetWidget(this.removeBanner, {super.key});

  @override
  ConsumerState<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends ConsumerState<NoInternetWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller.view,
        builder: (context, child) {
          if (ref.watch(internetConnectionCheckerProvider)) {
            _controller.reverse().then((value) {
              try {
                widget.removeBanner.call();
              } catch (_) {}
            });
          }
          return Stack(
            children: [
              Positioned(
                top: Platform.isIOS ? -10 : 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  child: Align(
                    heightFactor: _controller.value,
                    child: Container(
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: SafeArea(
                          bottom: false,
                          child: Text(
                            'No internet',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
