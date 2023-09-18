import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  factory Address({
    @JsonKey(name: 'Street') required String street,
    @JsonKey(name: 'ApartmentNumber') String? apartmentNumber,
    @JsonKey(name: 'City') required String city,
    @JsonKey(name: 'Zip') required String zip,
    @JsonKey(name: 'State') required String state,
    @JsonKey(name: 'Country') String? country,
    @JsonKey(name: 'Phone') @Default(<String>[]) List<String> phone,
    @JsonKey(name: 'Email') @Default(<String>[]) List<String> email,
    @JsonKey(name: 'Website') String? website,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Address._();

  String get formattedAddress => '''$street${apartmentNumber.isNotNullOrEmpty ? '\n$apartmentNumber' : ''}
$city, $state $zip''';
}
