import 'network_error.dart';

class NetworkResponse<T> {
  final bool isSuccess;
	final T? data;
	final NetworkError? error;

  NetworkResponse({
		required this.isSuccess,
		this.data,
		this.error
	});
}