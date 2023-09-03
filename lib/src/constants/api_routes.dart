import '../../flavor_config.dart';
import '../features/documents/domain/app_document/app_document.dart';

class ApiRoutes {
  static String get baseUrl => FlavorConfig.instance!.baseUrl;
  static String get rawBaseUrl => FlavorConfig.instance!.rawApiBase;
  static String get mobileBaseApi => FlavorConfig.instance!.mobileBaseApi;
  static String get storageUrl => FlavorConfig.instance!.storageUrl;
  static String locationTracking = '${mobileBaseApi}tracking';
  static String authenticate(String phone) => '$mobileBaseApi$phone/authenticate';
  static String login(String phone, String code) => '$mobileBaseApi$phone/login/$code';
  static String userData(String userId) => '${baseUrl}driveruserdata/$userId';
  static String trips = '${mobileBaseApi}trips';
  static String tripDetails(String tripId) => '$mobileBaseApi$tripId/trip';
  static String timeStopRecord(String tripId, String stopId) => '$mobileBaseApi$tripId/$stopId/time_record';
  //static String documents = '${mobileBaseApi}driver/documents';
  // static String tripEchecks = 'getechecksbytrip/';
  static String get webSocket => 'https://$rawBaseUrl/mobilehub';
  static String stopdetails(String tripId, String stopId) => '${mobileBaseApi}GetStopDetail/$stopId/$tripId';
  static String getEchecksByTrip(String tripId) => '${mobileBaseApi}GetEChecksByTrip/$tripId';
  // static String queryExpressNumber = 'comcheckenquiry/';
  static String driverPaystubs = '${mobileBaseApi}driver/paystubs';
  static String tripReport = '${mobileBaseApi}driver/trip_report';
  static Uri paystubs(DriverPaystubDTO dto) =>
      Uri.https(FlavorConfig.instance!.rawApiBase, '/driver/paystubs', dto.toJson());
  static Uri documents([DriverDocumentsDTO? dto]) =>
      Uri.https(FlavorConfig.instance!.rawApiBase, '/driver/documents', dto?.toJson());
  static String tripDocument(String tripId) => '$mobileBaseApi$tripId/trip/documents';
}
