import 'package:freezed_annotation/freezed_annotation.dart';

import 'record.dart';

part 'time_record.freezed.dart';
part 'time_record.g.dart';

@freezed
class TimeRecord with _$TimeRecord {
  factory TimeRecord({
    @JsonKey(name: 'Driver') Record? driver,
    @JsonKey(name: 'Truck') Record? truck,
  }) = _TimeRecord;

  factory TimeRecord.fromJson(Map<String, dynamic> json) =>
      _$TimeRecordFromJson(json);
}
