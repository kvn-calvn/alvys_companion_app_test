import 'package:alvys3/src/features/documents/domain/trip_documents/trip_documents.dart';
import 'package:alvys3/src/network/api_response.dart';

abstract class TripDocsRepository {
  Future<ApiResponse<List<TripDocuments>>> getTripDocs(String tripId);
}
