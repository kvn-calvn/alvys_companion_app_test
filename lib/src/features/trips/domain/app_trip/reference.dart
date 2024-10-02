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
    @JsonKey(name: 'ReferenceType') String? referenceType,
    @JsonKey(name: 'Access') String? access,
  }) = _Reference;

  factory Reference.fromJson(Map<String, dynamic> json) => _$ReferenceFromJson(json);
  Reference._();
  String get getValue {
    switch (referenceType?.toUpperCase()) {
      case StopReferenceType.date:
        var newValue = DateTime.tryParse(value ?? '');
        return DateFormat('MM/dd/yyyy').formatNullDate(newValue);
      case StopReferenceType.bool:
        var val = bool.tryParse(value ?? '') ?? false;
        return val ? 'Yes' : 'No';
      case StopReferenceType.text:
      default:
        return value ?? '-';
    }
  }
}

class StopReferenceType {
  static const String text = 'TEXT', bool = 'BOOL', date = 'DATE';
}

class StopReferenceAccessType {
  static const String public = 'PUBLIC';
}
