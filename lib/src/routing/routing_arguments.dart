class FilteredTripsArguments {
  final dynamic data;
  final String title;

  const FilteredTripsArguments({
    required this.data,
    required this.title,
  });
}

class TripDetailsArguments {
  final String tripId;
  final String tripNumber;
  const TripDetailsArguments({required this.tripNumber, required this.tripId});
}

class StopDetailsArguments {
  final String stopId;
  final String tripId;
  const StopDetailsArguments({required this.stopId, required this.tripId});
}

class EcheckArguments {
  final String tripId;
  const EcheckArguments({required this.tripId});
}

class TripDocsArguments {
  final String tripId;
  const TripDocsArguments({required this.tripId});
}

class PDFViewerArguments<T> {
  final String docUrl;
  final String title;
  final T documentData;
  const PDFViewerArguments(this.docUrl, this.title, this.documentData);
}
