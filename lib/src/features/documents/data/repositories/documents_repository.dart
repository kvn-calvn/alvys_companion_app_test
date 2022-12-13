import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';
import 'package:alvys3/src/features/documents/domain/paystub/paystub.dart';
import 'package:alvys3/src/network/api_client.dart';
import 'package:alvys3/src/network/endpoints.dart';
import 'package:flutter/foundation.dart';

import '../../../../network/api_response.dart';
import '../../../../network/network_info.dart';
import '../../domain/trip_documents/trip_documents.dart';
import '../../../../utils/extensions.dart';

abstract class DocumentsRepository {
  Future<ApiResponse<List<TripDocuments>>> getTripDocs(String tripId);
  Future<ApiResponse<List<Paystub>>> getPaystubs(DriverUser user,
      [int top = 10]);
  Future<ApiResponse<List<TripDocuments>>> getPersonalDocs(String tripId);
}

class AppDocumentsRepository implements DocumentsRepository {
  final NetworkInfoImpl network;

  AppDocumentsRepository(this.network);
  @override
  Future<ApiResponse<List<Paystub>>> getPaystubs(DriverUser user,
      [int top = 10]) async {
    if (await network.isConnected) {
      var res = await ApiClient.singleton.dio.get(Endpoint.driverPaystubs(
          user.id!, user.userTenants.first.companyCode!, top));
      if (res.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: (res.data as List<dynamic>?)
              .toListNotNull()
              .map((x) => Paystub.fromJson(x))
              .toList(),
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
  Future<ApiResponse<List<TripDocuments>>> getPersonalDocs(
      String tripId) async {
    // TODO: implement getPersonalDocs
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<TripDocuments>>> getTripDocs(String tripId) async {
    if (await network.isConnected) {
      var res = await ApiClient().dio.get(Endpoint.tripDocuments(tripId));
      if (res.statusCode == 200) {
        return ApiResponse(
            success: true,
            data: (res.data['Data'] as List<dynamic>?)
                .toListNotNull()
                .map((x) => TripDocuments.fromJson(x))
                .toList());
      }
      return ApiResponse(success: false, data: [], error: res.data["Error"]);
    }
    return ApiResponse(
      success: false,
      data: [],
      error: "Network unavailable, check internet connection",
    );
  }
}
