import 'dart:async';
import 'dart:io';

import 'package:alvys3/flavor_config.dart';
import 'package:alvys3/src/network/http_client.dart';
import 'package:alvys3/src/utils/helpers.dart';
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
  Future<List<AppDocument>> getPaystubs(String companyCode, DriverUser user, [int top = 10]);
  Future<List<AppDocument>> getPersonalDocs(DriverUser user);
  Future<List<AppDocument>> getTripReportDocs(String companyCode, DriverUser user);
  Future<void> uploadTripDocuments(String companyCode, UploadDocumentOptions docData, File document, String tripId);
  Future<void> uploadPersonalDocuments(UploadDocumentOptions docData, File document);
  Future<void> uploadTripReport(String companyCode, UploadDocumentOptions docData, File document);
}

class AppDocumentRepository<T> implements DocumentsRepository<T> {
  final ApiClient client;
  final AlvysHttpClient httpClient;
  final FileUploadProgressNotifier fileProgress;
  AppDocumentRepository(this.fileProgress, this.client, this.httpClient);
  @override
  Future<List<AppDocument>> getPaystubs(String companyCode, DriverUser user, [int top = 10]) async {
    await Helpers.setCompanyCode(companyCode);
    var driverId = user.userTenants.firstWhereOrNull((element) => element.companyOwnedAsset ?? false)?.assetId;
    if (driverId == null) return [];
    var dto = DriverPaystubDTO(top: top, driverId: driverId);
    var res = await httpClient.getData<T>(ApiRoutes.paystubs(dto));
    return (res.body.toDecodedJson as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<List<AppDocument>> getPersonalDocs(DriverUser user) async {
    var driverId = user.userTenants.firstWhereOrNull((element) => element.companyOwnedAsset ?? false)?.assetId;
    if (driverId == null) return [];
    var dto = DriverDocumentsDTO(
        acceptedTypes: [DocumentTypes.driverLicense, DocumentTypes.license, DocumentTypes.medical], driverId: driverId);
    var res = await httpClient.getData<T>(ApiRoutes.documents(dto));
    return (res.body.toDecodedJson as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<List<AppDocument>> getTripReportDocs(String companyCode, DriverUser user) async {
    await Helpers.setCompanyCode(companyCode);
    var driverId = user.userTenants.firstWhereOrNull((element) => element.companyOwnedAsset ?? false)?.assetId;
    if (driverId == null) return [];
    var dto = DriverDocumentsDTO(acceptedTypes: [DocumentTypes.tripReport], driverId: driverId);
    var res = await httpClient.getData<T>(ApiRoutes.documents(dto));
    return (res.body.toDecodedJson as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<void> uploadTripDocuments(
      String companyCode, UploadDocumentOptions docData, File document, String tripId) async {
    await Helpers.setCompanyCode(companyCode);
    var data = await MultipartFile.fromPath(docData.title, document.path);
    await httpClient.upload(Uri.parse(ApiRoutes.tripDocument(tripId)),
        files: [data], onProgress: fileProgress.updateProgress);
  }

  @override
  Future<void> uploadPersonalDocuments(UploadDocumentOptions docData, File document) async {
    var data = await MultipartFile.fromPath(docData.title, document.path);
    await httpClient.upload(ApiRoutes.documents(), files: [data], onProgress: fileProgress.updateProgress);
  }

  @override
  Future<void> uploadTripReport(String companyCode, UploadDocumentOptions docData, File document) async {
    await Helpers.setCompanyCode(companyCode);
    var data = await MultipartFile.fromPath(docData.title, document.path);
    await httpClient.upload(Uri.parse(ApiRoutes.tripReport), files: [data], onProgress: fileProgress.updateProgress);
  }
}

final documentsRepositoryProvider = Provider<AppDocumentRepository<UploadDocumentsController>>((ref) {
  final fileProgress = ref.watch(fileUploadProvider.notifier);
  final apiClient = ref.read(apiClientProvider);
  final httpClient = ref.read(httpClientProvider);
  return AppDocumentRepository(fileProgress, apiClient, httpClient);
});
