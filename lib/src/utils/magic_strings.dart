enum RouteName {
  // phone
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
  documentView,
  stopDetails,
  settings,
  profile,
  editProfile,
  generateEcheck,
  paystubs,
  personalDocumentsList,
  uploadPersonalDocument,
  tripReportDocumentList,
  uploadTripReport,

  /// tablet routes
  tabletTrips,
  tabletTripDetails,
}

enum TripFilterType { processing, delivered }

enum DocumentType { tripDocuments, personalDocuments, paystubs, tripReport }

enum Environment { dev, qa, sandbox }

enum StorageKey { driverData, themeMode, driverToken }

enum EcheckOption { copy, cancel }

enum UploadType { camera, gallery }

enum ParamType { tripId, stopId }
