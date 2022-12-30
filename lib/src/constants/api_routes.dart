import 'package:alvys3/flavor_config.dart';

class ApiRoutes {
  static final String baseUrl = FlavorConfig.instance!.baseUrl;
  static final String mobileBaseApi = FlavorConfig.instance!.mobileBaseApi;
  static final String storageUrl = FlavorConfig.instance!.storageUrl;
  static const String phoneNumber = 'login/';
  static const String registerPhoneNumber = 'registerdriver/';
  static const String userData = 'driveruserdata/';
  static const String verify = 'authenticateuser';
  static const String trips = 'gettrips/';
  static const String tripdetails = 'gettripdetail/';
  static const String tripdocs = 'getdocumentsbytrip/';
  static const String minifiedDocuments = 'getminifieddocuments/';
  static const String tripechecks = 'getechecksbytrip/';
  static const String stopdetails = 'getstopdetail/';
  static const String getEchecksByTrip = 'getechecksbytrip/';
  static const String queryExpressNumber = 'comcheckenquiry/';
}
