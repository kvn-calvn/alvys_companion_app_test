import 'dart:async';
import 'dart:io';

import 'package:alvys3/src/features/trips/presentation/controller/trip_page_controller.dart';
import 'package:alvys3/src/routing/app_router.dart';
import 'package:alvys3/src/routing/custom_observer.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../utils/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkNotifier extends Notifier<bool> {
  Map<String, IAppErrorHandler> get refreshControllers => {
        RouteName.trips.name: ref.read(tripControllerProvider.notifier),
        RouteName.tripDetails.name: ref.read(tripControllerProvider.notifier),
      };
  bool? initConnection;
  bool _hasInsert = false;
  late GlobalErrorHandler errorHandler;
  late OverlayEntry noInternetOverlay;
  NetworkNotifier([this.initConnection]);
  @override
  bool build() {
    state = initConnection ?? true;
    initState();
    return state;
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      errorHandler = ref.read(globalErrorHandlerProvider);
      updateOverlay();
      internetConnectionStream.listen((event) {
        state = event;
        updateOverlay();
      });
      Connectivity().onConnectivityChanged.listen((event) async {
        state = await InternetConnectionChecker().hasConnection;
        updateOverlay();
      });
    });
  }

  void setInternetState(bool internetState) => state = internetState;
  Stream<bool> get internetConnectionStream {
    return Stream.periodic(const Duration(seconds: 30), (index) => InternetConnectionChecker().hasConnection)
        .asyncMap((event) => event);
  }

  void updateOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
            _controller.reverse().then((value) => widget.removeBanner);
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
