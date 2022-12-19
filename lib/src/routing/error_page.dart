import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, this.exception}) : super(key: key);

  final Exception? exception;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Page'),
      ),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Text(
            exception.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ErrorFunctionHandler {
  Function? onError;

  ErrorFunctionHandler._inst();
  static final ErrorFunctionHandler _instance = ErrorFunctionHandler._inst();
  static ErrorFunctionHandler get instance => _instance;
  void executeOnError() {
    onError?.call();
    onError = null;
  }
}
