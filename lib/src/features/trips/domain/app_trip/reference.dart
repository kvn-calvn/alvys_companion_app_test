import 'package:freezed_annotation/freezed_annotation.dart';

part 'reference.freezed.dart';
part 'reference.g.dart';

@freezed
class Reference with _$Reference {
  factory Reference({
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Value') String? value,
  }) = _Reference;

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);
}
