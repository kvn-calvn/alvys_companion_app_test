import 'package:alvys3/flavor_config.dart';
import 'package:alvys3/src/features/authentication/domain/models/driver_user/driver_user.dart';

class ApiRoutes {
  static String get baseUrl => FlavorConfig.instance!.baseUrl;
  static String get rawBaseUrl => FlavorConfig.instance!.rawApiBase;
  static String get mobileBaseApi => FlavorConfig.instance!.mobileBaseApi;
  static String get storageUrl => FlavorConfig.instance!.storageUrl;
  static String locationTracking = '${mobileBaseApi}LiveTruckTracking';
  static String phoneNumber(String phone) => '${mobileBaseApi}Login/$phone';
  static String registerPhoneNumber(String phone) =>
      '${mobileBaseApi}registerdriver/$phone';
  static String userData(String userId) => '${baseUrl}driveruserdata/$userId';
  static String verify(String phone, String code) =>
      '${mobileBaseApi}authenticateuser/$phone/$code';
  static String trips = '${mobileBaseApi}gettrips/';
  static String tripDetails(String tripId) =>
      '${mobileBaseApi}gettripdetail/$tripId';
  static String tripDocs(String tripId) =>
      '${mobileBaseApi}getdocumentsbytrip/$tripId';
  static String minifiedDocuments = '${mobileBaseApi}getminifieddocuments/';
  // static String tripEchecks = 'getechecksbytrip/';
  static String stopdetails(String tripId, String stopId) =>
      '${mobileBaseApi}getstopdetail/$tripId/$stopId';
  static String getEchecksByTrip(String tripId) =>
      '${mobileBaseApi}GetEChecksByTrip/$tripId';
  // static String queryExpressNumber = 'comcheckenquiry/';
  static String driverPaystubs(DriverUser user, int top) =>
      '${baseUrl}billing/QueryPaystubData?UserId=${user.id!}&CompanyCode=${user.userTenants.first.companyCode!}&Top=$top';
  static String get tripDocumentUpload =>
      '${mobileBaseApi}UploadDriverDocuments';
}
