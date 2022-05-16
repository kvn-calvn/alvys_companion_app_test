import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/dio_factory.dart';
import 'package:alvys3/src/network/network_info.dart';
import 'package:alvys3/src/network/user_token_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final flutterSecureStorageProvider =
    Provider((ref) => const FlutterSecureStorage());

final userTokenHandleProvider =
    Provider((ref) => UserTokenHandle(ref.read(flutterSecureStorageProvider)));

final dioFactoryProvider =
    Provider((ref) => DioFactory(ref.read(userTokenHandleProvider)));
/*
final appServiceClient = Provider((ref) async {
  var dio = await ref.watch(dioFactoryProvider).getDio();
  return AppServiceClient(dio);
});*/

final networkInfoProvider = Provider<NetworkInfoImpl>((ref) {
  return NetworkInfoImpl(ref.watch(internetConnectionCheckerProvider));
});

final apiClient = Provider((ref) => ApiClient());
