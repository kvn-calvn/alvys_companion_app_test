import 'package:freezed_annotation/freezed_annotation.dart';

part 'record.freezed.dart';
part 'record.g.dart';

@freezed
class Record with _$Record {
  factory Record({
    @JsonKey(name: 'In') DateTime? timeIn,
    @JsonKey(name: 'Out') DateTime? timeOut,
  }) = _Record;

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
}
