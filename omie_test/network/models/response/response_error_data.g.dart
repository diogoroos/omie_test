// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_error_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseErrorData _$ResponseErrorDataFromJson(Map<String, dynamic> json) {
  return ResponseErrorData(
    code: json['code'] as String?,
    extras: json['extras'],
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$ResponseErrorDataToJson(ResponseErrorData instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'extras': instance.extras,
    };
