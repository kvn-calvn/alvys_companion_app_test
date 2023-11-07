import 'dart:async';
import 'dart:io';

import '../../presentation/docs_controller.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../../../constants/api_routes.dart';
import '../../../../network/file_upload_process_provider.dart';
import '../../../../network/http_client.dart';
import '../../../../utils/extensions.dart';
import '../../../authentication/domain/models/driver_user/driver_user.dart';
import '../../domain/app_document/app_document.dart';
import '../../presentation/upload_documents_controller.dart';

abstract class DocumentsRepository<C, T> {
  Future<List<AppDocument>> getPaystubs(DriverUser user, [int top = 10]);
  Future<List<AppDocument>> getPersonalDocs(String companyCode, DriverUser user);
  Future<List<AppDocument>> getTripReportDocs(String companyCode, DriverUser user);
  Future<void> uploadTripDocuments(String companyCode, UploadDocumentOptions docData, File document, String tripId);
  Future<void> uploadPersonalDocuments(String companyCode, UploadDocumentOptions docData, File document);
  Future<void> uploadTripReport(String companyCode, UploadDocumentOptions docData, File document);
}

class AppDocumentRepository<C, T> implements DocumentsRepository<C, T> {
  final AlvysHttpClient httpClient;
  final FileUploadProgressNotifier fileProgress;
  AppDocumentRepository(this.fileProgress, this.httpClient);
  @override
  Future<List<AppDocument>> getPaystubs(DriverUser user, [int top = 10]) async {
    var tenant = user.userTenants.firstWhereOrNull(
        (element) => (element.companyOwnedAsset ?? false) && !element.contractorType.equalsIgnoreCase('Contractor'));
    if (tenant == null) return [];
    var dto = DriverPaystubDTO(top: top.toString(), driverId: tenant.assetId);
    var res = await httpClient.getData<C>(ApiRoutes.paystubs(dto), tenant.companyCode);
    return (res.body.toDecodedJson as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<List<AppDocument>> getPersonalDocs(String companyCode, DriverUser user) async {
    var dto =
        DriverDocumentsDTO(driverIds: user.userTenants.map((e) => e.assetId).removeNulls.toList(), userId: user.id!);
    var res = await httpClient.getData<C>(ApiRoutes.personalDocuments(dto), companyCode);
    return (res.body.toDecodedJson as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<List<AppDocument>> getTripReportDocs(String companyCode, DriverUser user) async {
    var dto =
        DriverDocumentsDTO(driverIds: user.userTenants.map((e) => e.assetId).removeNulls.toList(), userId: user.id!);
    var res = await httpClient.getData<C>(ApiRoutes.tripReports(dto), companyCode);
    return (res.body.toDecodedJson as List<dynamic>?).toListNotNull().map((x) => AppDocument.fromJson(x)).toList();
  }

  @override
  Future<void> uploadTripDocuments(
      String companyCode, UploadDocumentOptions docData, File document, String tripId) async {
    var data = await MultipartFile.fromPath(docData.value, document.path);
    await httpClient.upload<T>(Uri.parse(ApiRoutes.tripDocument(tripId)), companyCode,
        files: [data], onProgress: fileProgress.updateProgress);
  }

  @override
  Future<void> uploadPersonalDocuments(String companyCode, UploadDocumentOptions docData, File document) async {
    var data = await MultipartFile.fromPath(docData.value, document.path);
    await httpClient.upload<T>(ApiRoutes.personalDocuments(), companyCode,
        files: [data], onProgress: fileProgress.updateProgress);
  }

  @override
  Future<void> uploadTripReport(String companyCode, UploadDocumentOptions docData, File document) async {
    var data = await MultipartFile.fromPath(docData.value, document.path);
    await httpClient.upload<T>(Uri.parse(ApiRoutes.tripReport), companyCode,
        files: [data], onProgress: fileProgress.updateProgress);
  }
}

final documentsRepositoryProvider =
    Provider<AppDocumentRepository<DocumentsNotifier, UploadDocumentsController>>((ref) {
  final fileProgress = ref.watch(fileUploadProvider.notifier);
  final httpClient = ref.read(httpClientProvider);
  return AppDocumentRepository(fileProgress, httpClient);
});
