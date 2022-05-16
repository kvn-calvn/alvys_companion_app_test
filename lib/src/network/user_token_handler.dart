import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserTokenHandle {
  final FlutterSecureStorage _flutterSecureStorage;

  UserTokenHandle(this._flutterSecureStorage);
  Future<String> getLoginData() async {
    String? token = await _flutterSecureStorage.read(key: 'appToken');
    if (token != null && token.isNotEmpty) {
      return "Basic $token";
    } else {
      return "";
    }
  }

  Future<void> generateToken() async {}
}

final flutterSecureStorageProvider =
    Provider((ref) => const FlutterSecureStorage());
final userTokenHandleProvider =
    Provider((ref) => UserTokenHandle(ref.read(flutterSecureStorageProvider)));
