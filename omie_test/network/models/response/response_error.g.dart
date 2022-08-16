// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseError _$ResponseErrorFromJson(Map<String, dynamic> json) {
  return ResponseError(
    data: ResponseErrorData.fromJson(json['data'] as Map<String, dynamic>),
    errors: json['errors'] as List<dynamic>,
    status: json['status'] as int,
  );
}

Map<String, dynamic> _$ResponseErrorToJson(ResponseError instance) =>
    <String, dynamic>{
      'status': instance.status,
      'errors': instance.errors,
      'data': instance.data,
    };
