import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  factory MapState({
    @Default({}) Set<Marker> markers,
    @Default({}) Set<Polyline> polyLines,
    @Default(MapType.normal) MapType mapType,
  }) = _MapState;
}
