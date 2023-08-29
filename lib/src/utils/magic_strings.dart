enum RouteName {
  /// phone routes
  about,
  landing,
  signIn,
  verify,
  locationPermission,
  notificationPermission,
  trips,
  delivered,
  processing,
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

  /// tablet routes
  tabletTrips,
  tabletTripDetails,
  tabletStopDetails,
  tabletSettings,
  tabletDocumentView,
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
