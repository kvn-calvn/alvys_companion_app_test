import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  factory Address({
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'GoogleId') String? googleId,
    @JsonKey(name: 'Street') String? street,
    @JsonKey(name: 'ApartmentNumber') String? apartmentNumber,
    @JsonKey(name: 'City') String? city,
    @JsonKey(name: 'Zip') String? zip,
    @JsonKey(name: 'State') String? state,
    @JsonKey(name: 'Country') String? country,
    @Default(<String>[]) @JsonKey(name: 'Phone') List<String> phone,
    @JsonKey(name: 'PhoneExtension') String? phoneExtension,
    @Default(<String>[]) @JsonKey(name: 'Email') List<String> email,
    @JsonKey(name: 'Fax') String? fax,
    @JsonKey(name: 'Contacts') List<String>? contacts,
    @JsonKey(name: 'Website') String? website,
    @JsonKey(name: 'Coordinates') dynamic coordinates,
    @Default(false) @JsonKey(name: 'CoordinatesFound') bool coordinatesFound,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
