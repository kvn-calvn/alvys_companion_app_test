import 'package:json_annotation/json_annotation.dart';

class UTCDateConverter implements JsonConverter<DateTime, String> {
  const UTCDateConverter();
  @override
  DateTime fromJson(String json) {
    return DateTime.parse('${json}z');
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
