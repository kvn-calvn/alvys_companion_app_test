import 'package:freezed_annotation/freezed_annotation.dart';

import 'driver.dart';
import 'truck.dart';

part 'time_record.freezed.dart';
part 'time_record.g.dart';

@freezed
class TimeRecord with _$TimeRecord {
  factory TimeRecord({
    @JsonKey(name: 'Driver') Driver? driver,
    @JsonKey(name: 'Truck') Truck? truck,
  }) = _TimeRecord;

  factory TimeRecord.fromJson(Map<String, dynamic> json) =>
      _$TimeRecordFromJson(json);
}
