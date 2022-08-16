//import 'package:json_annotation/json_annotation.dart';

part 'response_error_data.g.dart';

//@JsonSerializable()
class ResponseErrorData {
  String? message;
  String? code;
  dynamic extras;

  ResponseErrorData({this.code, this.extras, this.message});

  factory ResponseErrorData.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorDataFromJson(json);
}
