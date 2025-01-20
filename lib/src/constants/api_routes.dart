import '../../flavor_config.dart';
import '../features/documents/domain/app_document/app_document.dart';

class ApiRoutes {
  static String get baseUrl => FlavorConfig.instance!.baseUrl;
  static String get rawBaseUrl => FlavorConfig.instance!.rawApiBase;
  static String get mobileBaseApi => FlavorConfig.instance!.mobileBaseApi;
  static String get storageUrl => FlavorConfig.instance!.storageUrl;
  static String locationTracking = '${mobileBaseApi}tracking';
  static String authenticate(String phone) =>
      '$mobileBaseApi$phone/authenticate';
  static String login(String phone, String code) =>
      '$mobileBaseApi$phone/login/$code';
  static String userData(String userId) => '${baseUrl}newusers/GetUser/$userId';
  static String trips = '${mobileBaseApi}trips';
  static String tripDetails(String tripId) => '$mobileBaseApi$tripId/trip';
  static String timeStopRecord(String tripId, String stopId) =>
      '$mobileBaseApi$tripId/$stopId/time_record';
  static String get webSocket => 'https://$rawBaseUrl/mobilehub';
  static String driverPaystubs = '${mobileBaseApi}driver/paystubs';
  static String tripReport = '${mobileBaseApi}driver/trip_report';
  static Uri get driverStatus => Uri.parse('${mobileBaseApi}driver/status');
  static Uri get generateEcheck => Uri.parse('${mobileBaseApi}echeck');
  static Uri cancelEcheck(String echeckNumber) =>
      Uri.parse('$mobileBaseApi$echeckNumber/echeck');
  static Uri paystubs(DriverPaystubDTO dto) => Uri.https(
      FlavorConfig.instance!.rawApiBase,
      '/api/mobile/driver/paystubs',
      dto.toJson());
  static Uri tripReports([DriverDocumentsDTO? dto]) => Uri.https(
      FlavorConfig.instance!.rawApiBase,
      '/api/mobile/driver/trip_report',
      dto?.toJson());
  static Uri personalDocuments([DriverDocumentsDTO? dto]) => Uri.https(
      FlavorConfig.instance!.rawApiBase,
      '/api/mobile/driver/documents',
      dto?.toJson());
  static String tripDocument(String tripId) =>
      '$mobileBaseApi$tripId/trip/documents';
  static Uri get driverInfo => Uri.parse('${mobileBaseApi}driver/info');
  static Uri driverAsset(String id) => Uri.parse('${baseUrl}drivers/$id');
  static Uri get suggestTrailers => Uri.parse('$baseUrl/search/SuggestTrailer');
  static Uri get assignTrailer => Uri.parse('$baseUrl/newloads/AssignTrailer3');
  static Uri getDocumentUrl(String companyCode, String documentPath) =>
      Uri.parse('${baseUrl}storage/$companyCode/$documentPath');
}
