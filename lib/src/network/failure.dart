//import 'package:equatable/equatable.dart';
/*
class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}
*/

class Failure {
  int code; // 200 or 400
  String message; // error or success

  Failure(this.code, this.message);
}
