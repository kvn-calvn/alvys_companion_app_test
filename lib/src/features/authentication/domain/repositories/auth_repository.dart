import 'package:alvys3/src/network/api_response.dart';
import 'package:alvys3/src/features/authentication/domain/models/phonenumber/phonenumber.dart';
import 'package:alvys3/src/features/authentication/domain/models/verified/verified.dart';

abstract class AuthRepository {
  Future<ApiResponse<Phonenumber>> loginWithPhoneNumber(String phoneNumber);
  Future<ApiResponse<Verified>> verifyPhoneNumber(String verificationCode);
}
