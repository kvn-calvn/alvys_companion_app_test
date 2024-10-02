import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'reference.freezed.dart';
part 'reference.g.dart';

@freezed
class Reference with _$Reference {
  factory Reference({
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Value') String? value,
  }) = _Reference;

  factory Reference.fromJson(Map<String, dynamic> json) => _$ReferenceFromJson(json);
  Reference._();
  dynamic get getValue {
    var newValue = DateTime.tryParse(value ?? '');
    return DateFormat('MM/dd/YYYY').formatNullDate(newValue, value ?? '-');
  }
}
