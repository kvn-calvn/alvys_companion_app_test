import 'package:freezed_annotation/freezed_annotation.dart';

import 'data.dart';

part 'verified.freezed.dart';
part 'verified.g.dart';

@freezed
class Verified with _$Verified {
	factory Verified({
		@JsonKey(name: 'Data') Data? data,
		@JsonKey(name: 'ErrorMessage') String? errorMessage,
		@JsonKey(name: 'ErrorCode') int? errorCode,
	}) = _Verified;

	factory Verified.fromJson(Map<String, dynamic> json) => _$VerifiedFromJson(json);
}