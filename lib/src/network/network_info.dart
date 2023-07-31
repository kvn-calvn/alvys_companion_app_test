import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// class NetworkInfoImpl implements NetworkInfo {
//   final InternetConnectionChecker _internetConnectionChecker;

//   NetworkInfoImpl(this._internetConnectionChecker);

//   @override
//   Future<bool> get isConnected => _internetConnectionChecker.hasConnection;
// }

final internetConnectionCheckerProvider = Provider<InternetConnectionChecker>((ref) => InternetConnectionChecker());
