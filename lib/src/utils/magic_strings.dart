import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';

enum RouteName {
  /// phone routes
  about,
  landing,
  signIn,
  verify,
  locationPermission,
  notificationPermission,
  trips,
  tripDetails,
  eCheck,
  tripDocumentList,
  uploadTripDocument,
  tripDocumentView,
  documentView,
  stopDetails,
  settings,
  profile,
  editProfile,
  userDetails,
  generateEcheck,
  paystubs,
  personalDocumentsList,
  uploadPersonalDocument,
  tripReportDocumentList,
  uploadTripReport,
  notifications,
  emptyView,
  mapView,
}

enum TripFilterType { processing, delivered }

enum DisplayDocumentType { tripDocuments, personalDocuments, paystubs, tripReport }

enum Environment { dev, qa, sandbox }

enum SharedPreferencesKey { driverData, themeMode, driverToken, driverStatus, firstInstall }

class DriverStatus {
  static const String sleeping = 'Sleeping',
      driving = 'Driving',
      onDuty = 'On Duty',
      offDuty = 'Off Duty',
      online = 'Online',
      offline = 'Offline';
  static const List<String> driverStatuses = [online, offline];
  static String initStatus(String? status) {
    if (status == null) return online;
    if (status.equalsIgnoreCase(offDuty)) return online;
    if (driverStatuses.containsIgnoreCase(status)) {
      return status;
    } else {
      return offline;
    }
  }
}

class UserPermissions {
  static const String generateEcheck = 'Comchek',
      cancelEcheck = 'CancelComchek',
      viewPaystubs = 'ViewAppPaystubs',
      viewOOPRate = 'OOPRate',
      viewPayableAmount = 'ViewPayableAmount',
      viewCarrierRateConfirmation = 'ViewCarrierRateConfirmation',
      viewCustomerRateConfirmation = 'ViewCustomerRateConfirmation';
}

enum EcheckOption { copy, cancel }

enum UploadType { camera, gallery }

enum ParamType { tripId, stopId, tabIndex }

enum EcheckReason { advance, trailerWash, extraLaborDelivery, lumper, palletFee }

class DocumentTypes {
  static const String medical = 'Medical',
      tripReport = 'Trip Report',
      license = 'License',
      driverLicense = 'DriverLicense',
      carrierRateConfirmation = 'Carrier Rate Confirmation',
      customerRateAndLoadConfirmation = 'Customer Rate and Load Confirmation',
      customerRateConfirmation = 'Customer Rate Confirmation',
      customerLoadConfirmation = 'Customer Load Confirmation';
  static const List<String> customerConfirmationDocTypes = [
    customerLoadConfirmation,
    customerRateAndLoadConfirmation,
    customerRateConfirmation
  ];
}

class TripStatus {
  static const String open = "Open";
  static const String reserved = "Reserved";
  static const String covered = "Covered";
  static const String dispatched = "Dispatched";
  static const String inTransit = "In Transit";
  static const String delivered = "Delivered";
  static const String invoiced = "Invoiced";
  static const String completed = "Completed";
  static const String quoted = "Quoted";
  static const String released = "Released";
  static const String tonu = "TONU";
  static const String cancelled = "Cancelled";
  static const String queued = "Queued";
  static const String financed = "Financed";
  static const String paid = "Paid";
  static const String inReview = "In Review";
}

class ContractorType {
  static const String ownerOperator = "Owner Operator";
  static const String companyDriver = "Company Driver";
  static const String contractor = "Contractor";
}

class ScheduleType {
  static const String firstComeFirstServe = 'FCFS', appointment = 'APPT';
}
