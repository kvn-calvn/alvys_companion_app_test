import 'package:alvys3/flavor_config.dart';

class ApiRoutes {
  static String get baseUrl => FlavorConfig.instance!.baseUrl;
  static String get rawBaseUrl => FlavorConfig.instance!.rawApiBase;
  static String get mobileBaseApi => FlavorConfig.instance!.mobileBaseApi;
  static String get storageUrl => FlavorConfig.instance!.storageUrl;
  static String locationTracking = '${mobileBaseApi}tracking';
  static String phoneNumber(String phone) => '${mobileBaseApi}Login/$phone';
  static String authenticate(String phone) => '$mobileBaseApi$phone/authenticate';
  static String login(String phone, String code) => '$mobileBaseApi$phone/login/$code';
  static String registerPhoneNumber(String phone) => '${mobileBaseApi}registerdriver/$phone';
  static String userData(String userId) => '${baseUrl}driveruserdata/$userId';
  static String verify(String phone, String code) => '${mobileBaseApi}authenticateuser/$phone/$code';
  static String trips = '${mobileBaseApi}trips';
  static String tripDetails(String tripId) => '$mobileBaseApi$tripId/trip';
  static String tripDocs(String tripId) => '${mobileBaseApi}getdocumentsbytrip/$tripId';
  static String documents = '${mobileBaseApi}driver/documents';
  // static String tripEchecks = 'getechecksbytrip/';
  static String stopdetails(String tripId, String stopId) => '${mobileBaseApi}GetStopDetail/$stopId/$tripId';
  static String getEchecksByTrip(String tripId) => '${mobileBaseApi}GetEChecksByTrip/$tripId';
  // static String queryExpressNumber = 'comcheckenquiry/';
  static String driverPaystubs = '${mobileBaseApi}driver/paystubs';
  static String get tripDocumentUpload => '${mobileBaseApi}UploadDriverDocuments';
}
