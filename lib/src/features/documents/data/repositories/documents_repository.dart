import 'dart:async';
import 'dart:io';

import 'package:alvys3/src/network/http_client.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../../../constants/api_routes.dart';
import '../../../../network/api_client.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/magic_strings.dart';
import '../../../authentication/domain/models/driver_user/driver_user.dart';
import '../../domain/app_document/app_document.dart';
import '../../presentation/upload_documents_controller.dart';

abstract class DocumentsRepository<T> {
  Future<List<AppDocument>> getTripDocs(String tripId);
  Future<List<AppDocument>> getPaystubs(DriverUser user, [int top = 10]);
  Future<List<AppDocument>> getPersonalDocs(DriverUser user);
  Future<List<AppDocument>> getTripReportDocs(DriverUser user);
  Future<void> uploadDocuments(UploadDocumentOptions docData, List<File> documents, [String? tripId]);
}

class AppDocumentRepository<T> implements DocumentsRepository<T> {
  final ApiClient client;
  final AlvysHttpClient httpClient;
  final FileUploadProgressNotifier fileProgress;
  AppDocumentRepository(this.fileProgress, this.client, this.httpClient);
  @override
  Future<List<AppDocument>> getPaystubs(DriverUser user, [int top = 10]) async {
    var driverId = user.userTenants.firstWhereOrNull((element) => element.companyOwnedAsset ?? false)?.assetId;
    if (driverId == null) return [];
    var dto = DriverPaystubDTO(top: top, driverId: driverId);
    var res = await client.getData<T>(ApiRoutes.driverPaystubs, queryParameters: dto.toJson());
    return (res.data as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<List<AppDocument>> getPersonalDocs(DriverUser user) async {
    var driverId = user.userTenants.firstWhereOrNull((element) => element.companyOwnedAsset ?? false)?.assetId;
    if (driverId == null) return [];
    var dto = DriverDocumentsDTO(
        acceptedTypes: [DocumentTypes.driverLicense, DocumentTypes.license, DocumentTypes.medical], driverId: driverId);
    var res = await client.getData<T>(ApiRoutes.documents, queryParameters: dto.toJson());
    return (res.data as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<List<AppDocument>> getTripDocs(String tripId) async {
    var res = await client.getData<T>(ApiRoutes.tripDocs(tripId));
    return (res.data['Data'] as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<List<AppDocument>> getTripReportDocs(DriverUser user) async {
    var driverId = user.userTenants.firstWhereOrNull((element) => element.companyOwnedAsset ?? false)?.assetId;
    if (driverId == null) return [];
    var dto = DriverDocumentsDTO(acceptedTypes: [DocumentTypes.tripReport], driverId: driverId);
    var res = await client.getData<T>(ApiRoutes.documents, queryParameters: dto.toJson());
    return (res.data as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<void> uploadDocuments(UploadDocumentOptions docData, List<File> documents, [String? tripId]) async {
    var headers = tripId != null ? {'TripId': tripId} : <String, String>{};
    var data = await documents.asyncMap((e) => MultipartFile.fromPath(docData.title, e.path));
    await httpClient.upload(Uri.parse(ApiRoutes.tripDocumentUpload),
        files: data.toList(), onProgress: fileProgress.updateProgress, headers: headers);
  }
}

final documentsRepositoryProvider = Provider<AppDocumentRepository<UploadDocumentsController>>((ref) {
  final fileProgress = ref.watch(fileUploadProvider.notifier);
  final apiClient = ref.read(apiClientProvider);
  final httpClient = ref.read(httpClientProvider);
  return AppDocumentRepository(fileProgress, apiClient, httpClient);
});
