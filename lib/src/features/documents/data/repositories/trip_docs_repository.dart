import 'package:alvys3/src/features/documents/domain/app_documents/app_documents.dart';
import 'package:alvys3/src/network/api_response.dart';

abstract class TripDocsRepository {
  Future<ApiResponse<List<AppDocuments>>> getTripDocs(String tripId);
}
