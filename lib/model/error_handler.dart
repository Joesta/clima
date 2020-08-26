import 'package:flutter/cupertino.dart';

// handles errors
class ErrorHandler {
  final String error;
  final int statusCode;

  // constructs error handler
  ErrorHandler({@required this.error, @required this.statusCode});

  factory ErrorHandler.fromJson(Map<String, dynamic> map) {
    return ErrorHandler(error: map['error'], statusCode: map['statusCode']);
  }

  // getters
  String get getError => this.error;
  int get getStatusCode => this.statusCode;
}
