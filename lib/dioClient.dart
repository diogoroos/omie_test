import 'package:dio/dio.dart';
import 'package:omie_test/auth_retry.dart';
import 'package:omie_test/shared_prefs.dart';

class DioClientNew {
// dio instance
  static final DioClientNew _instance = DioClientNew._internal();
  static Dio? dio;

  factory DioClientNew() => _instance;

  DioClientNew._internal() {
    dio = Dio();
    Dio dio2 = dio!;
    dio!.interceptors.add(AuthInterceptor(
        loggedDio: dio!, tokenDio: dio2, secureStorage: SharedPrefs()));
    dio!
      ..options.baseUrl = 'https://app.omie.com.br/api/portal/'
      ..options.connectTimeout = 100000
      ..options.receiveTimeout = 100000
      ..options.responseType = ResponseType.json
      ..options.maxRedirects = 1000
      ..options.headers['User-Agent'] =
          "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1";
  }

  // DioClientNew(this.dio) {
  //   dio
  //     ..options.baseUrl = 'https://app.omie.com.br/api/portal/'
  //     ..options.connectTimeout = 100000
  //     ..options.receiveTimeout = 100000
  //     ..options.responseType = ResponseType.json;
  // }

  void refreshTokenDio(String token) {
    dio!.options.headers['Content-Type'] = 'application/json';
    dio!.options.headers['authorization'] = "Bearer " + token;
    dio!.options.headers['User-Agent'] =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1";
    print('---------\n' +
        token +
        '\n---------------\n-----------\n-------\n---------\n');
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (url.contains('http')) {
        dio!.options.baseUrl = url;
      } else {
        dio!.options.baseUrl = 'https://app.omie.com.br/';
      }
      dio!.options.headers.forEach((key, value) {
        print('-- key ' + key + ' val: ' + value);
      });
      final Response response = await dio!.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      print(response);
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (url.contains('http')) {
      dio!.options.baseUrl = url;
    }
    try {
      final Response response = await dio!.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      print(response);
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio!.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio!.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
