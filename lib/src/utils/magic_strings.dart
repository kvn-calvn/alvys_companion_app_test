enum RouteName {
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
  tripDocuments,
  documentView,
  stopDetails,
  settings,
  profile,
  editProfile,
  generateEcheck,
  paystubs,
  personalDocuments,
  tripReport
}

enum TripFilterType { processing, delivered }

enum DocumentType { tripDocuments, personalDocuments, paystubs, tripReport }

enum Environment { dev, qa, sandbox }

enum StorageKey { driverData, themeMode, driverToken }

enum EcheckOption { copy, cancel }
