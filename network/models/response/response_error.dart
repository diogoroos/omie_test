//import 'package:json_annotation/json_annotation.dart';
import 'response_error_data.dart';

part 'response_error.g.dart';

//@JsonSerializable()
class ResponseError {
  int status;
  List<dynamic> errors;
  ResponseErrorData data;

  ResponseError(
      {required this.data, required this.errors, required this.status});

  factory ResponseError.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorFromJson(json);
}
