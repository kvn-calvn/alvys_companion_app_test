import '../features/documents/presentation/upload_documents_controller.dart';

class ProviderArgsSaver {
  UploadDocumentArgs? uploadArgs;
  ProviderArgsSaver._privateConstructor();

  static final ProviderArgsSaver _instance = ProviderArgsSaver._privateConstructor();

  static ProviderArgsSaver get instance => _instance;
}
