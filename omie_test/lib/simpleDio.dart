import 'package:dio/dio.dart';
import 'package:omie_test/auth_retry.dart';
import 'package:omie_test/main.dart';
import 'package:omie_test/shared_prefs.dart';

class SimpleDio {
  late Dio _dio;
  Dio get instance => _dio;
  Dio novoDio = Dio();

  SimpleDio.getInstance() {
    _dio = Dio(getOptions());
    _dio.interceptors
        .add(LogInterceptor(request: true, requestHeader: true, error: true));
    _dio.interceptors.add(AuthInterceptor(
        loggedDio: _dio, tokenDio: novoDio, secureStorage: SharedPrefs()));
  }

  BaseOptions getOptions() => BaseOptions(
        baseUrl: MyHomePage.appFlavor,
      );
}
