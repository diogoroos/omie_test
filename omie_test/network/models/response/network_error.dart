//import 'package:json_annotation/json_annotation.dart';
import 'network_error_type.dart';

//@JsonSerializable()
class NetworkError {
  NetworkErrorType type;

  NetworkError({required this.type});
}
