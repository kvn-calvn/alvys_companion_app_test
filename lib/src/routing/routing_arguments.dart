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
  const TripDetailsArguments({required this.tripId});
}

class StopDetailsArguments {
  final String stopId;
  final String tripId;
  const StopDetailsArguments({required this.stopId, required this.tripId});
}
