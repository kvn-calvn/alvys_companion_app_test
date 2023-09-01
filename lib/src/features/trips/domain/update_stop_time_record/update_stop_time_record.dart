import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_stop_time_record.freezed.dart';
part 'update_stop_time_record.g.dart';

@freezed
class UpdateStopTimeRecord with _$UpdateStopTimeRecord {
  factory UpdateStopTimeRecord({
    @JsonKey(name: 'In') DateTime? timeIn,
    @JsonKey(name: 'Out') DateTime? timeOut,
    @JsonKey(name: 'StopId') required String stopId,
    @JsonKey(name: 'Latitude') required double latitude,
    @JsonKey(name: 'Longitude') required double longitude,
  }) = _UpdateStopTimeRecord;

  factory UpdateStopTimeRecord.fromJson(Map<String, dynamic> json) => _$UpdateStopTimeRecordFromJson(json);
}
