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
  emptyView
}

enum TripFilterType { processing, delivered }

enum DocumentType { tripDocuments, personalDocuments, paystubs, tripReport }

enum Environment { dev, qa, sandbox }

enum StorageKey { driverData, themeMode, driverToken, companyCode }

enum EcheckOption { copy, cancel }

enum UploadType { camera, gallery }

enum ParamType { tripId, stopId }

enum EcheckReason { advance, trailerWash, extraLaborDelivery, lumper, palletFee }

class DocumentTypes {
  static const String medical = 'Medical',
      tripReport = 'Trip Report',
      license = 'License',
      driverLicense = 'DriverLicense';
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
