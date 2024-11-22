import '../features/trailers/domain/trailer_request/trailer_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/documents/presentation/docs_controller.dart';
import '../features/documents/presentation/upload_documents_controller.dart';

class ProviderArgsSaver {
  UploadDocumentArgs? uploadArgs;
  String? echeckArgs;
  DocumentsArgs? documentArgs;
  SetTrailerDto? assignTrailerDto;
  ProviderArgsSaver._privateConstructor();

  static final ProviderArgsSaver _instance = ProviderArgsSaver._privateConstructor();

  static ProviderArgsSaver get instance => _instance;
}

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) {
  return null;
});
