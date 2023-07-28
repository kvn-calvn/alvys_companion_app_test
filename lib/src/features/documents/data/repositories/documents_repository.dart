import 'dart:async';
import 'dart:io';

import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/documents/domain/paystub/paystub.dart';
import 'package:alvys3/src/network/api_client.dart';
//import 'package:alvys3/src/network/endpoints.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:dio/dio.dart';

import '../../../../network/api_response.dart';
import '../../../../network/network_info.dart';
import '../../domain/app_documents/app_documents.dart';
import '../../../../utils/extensions.dart';

abstract class DocumentsRepository<T> {
  Future<ApiResponse<List<AppDocuments>>> getTripDocs(String tripId);
  Future<ApiResponse<List<Paystub>>> getPaystubs(DriverUser user, [int top = 10]);
  Future<ApiResponse<List<AppDocuments>>> getPersonalDocs();
  Future<ApiResponse<List<AppDocuments>>> getTripReportDocs();
  Future<ApiResponse<String>> uploadDocuments(String companyCode, String tripId, List<File> document);
}

class AppDocumentsRepository<T> implements DocumentsRepository<T> {
  final NetworkInfoImpl network;
  final ApiClient client;
  final FileUploadProgressNotifier fileProgress;
  AppDocumentsRepository(this.network, this.fileProgress, this.client);
  @override
  Future<ApiResponse<List<Paystub>>> getPaystubs(DriverUser user, [int top = 10]) async {
    if (await network.isConnected) {
      var res = await client.getData(ApiRoutes.driverPaystubs(user, top));
      if (res.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: (res.data as List<dynamic>?).toListNotNull().map((x) => Paystub.fromJson(x)).toList(),
        );
      }
      return ApiResponse(success: false, data: [], error: res.data["Error"]);
    }
    return ApiResponse(
      success: false,
      data: [],
      error: "Network unavailable, check internet connection",
    );
  }

  @override
  Future<ApiResponse<List<AppDocuments>>> getPersonalDocs() async {
    if (await network.isConnected) {
      var res = await client.getData(ApiRoutes.minifiedDocuments);
      if (res.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: (res.data as List<dynamic>?).toListNotNull().map((x) => AppDocuments.fromJson(x)).toList(),
        );
      }
      return ApiResponse(success: false, data: [], error: res.data["Error"]);
    }
    return ApiResponse(
      success: false,
      data: [],
      error: "Network unavailable, check internet connection",
    );
  }

  @override
  Future<ApiResponse<List<AppDocuments>>> getTripDocs(String tripId) async {
    if (await network.isConnected) {
      var res = await client.getData(ApiRoutes.tripDocs(tripId));
      if (res.statusCode == 200) {
        return ApiResponse(
            success: true,
            data: (res.data['Data'] as List<dynamic>?).toListNotNull().map((x) => AppDocuments.fromJson(x)).toList());
      }
      if (res.statusCode == 404) {
        throw AlvysClientException(res.data, T);
      }
      return ApiResponse(success: false, data: [], error: res.data["Error"]);
    }
    return ApiResponse(
      success: false,
      data: [],
      error: "Network unavailable, check internet connection",
    );
  }

  @override
  Future<ApiResponse<List<AppDocuments>>> getTripReportDocs() async {
    Map<String, dynamic> data = {
      "IncludeTypes": ["Trip Report"],
      "ExcludeTypes": []
    };
    if (await network.isConnected) {
      var res = await client.postData(ApiRoutes.minifiedDocuments, data: data);
      if (res.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: (res.data as List<dynamic>?).toListNotNull().map((x) => AppDocuments.fromJson(x)).toList(),
        );
      }
      return ApiResponse(success: false, data: [], error: res.data["Error"]);
    }
    return ApiResponse(
      success: false,
      data: [],
      error: "Network unavailable, check internet connection",
    );
  }

  @override
  Future<ApiResponse<String>> uploadDocuments(String companyCode, String tripId, List<File> documents) async {
    if (await network.isConnected) {
      var data = FormData();
      data.fields.add(MapEntry('TripId', tripId));
      data.files.add(MapEntry('file', await MultipartFile.fromFile(documents.first.path)));
      var res = await client.postData(ApiRoutes.tripDocumentUpload,
          data: data,
          onSendProgress: (count, total) => fileProgress.updateProgress(total, count),
          options: Options(headers: {
            'content-type': 'multipart/form-data',
            'CompanyCode': companyCode,
          }));
      return ApiResponse(
        success: true,
        data: res.data.toString(),
      );
    }
    return ApiResponse(
      success: false,
      data: '',
      error: "Network unavailable, check internet connection",
    );
  }
}
