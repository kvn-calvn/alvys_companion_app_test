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
  documentList,
  documentView,
  stopDetails,
  settings,
  profile,
  editProfile,
  generateEcheck,
  paystubs,
  personalDocuments,
  tripReport,

  /// tablet routes
  tabletTrips,
  tabletTripDetails,
}

enum TripFilterType { processing, delivered }

enum DocumentType { tripDocuments, personalDocuments, paystubs, tripReport }

enum Environment { dev, qa, sandbox }

enum StorageKey { driverData, themeMode, driverToken }

enum EcheckOption { copy, cancel }
