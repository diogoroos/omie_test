import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:omie_test/auth_retry.dart';
import 'package:omie_test/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_interceptor.dart';
import 'network_refresh_token_interceptor.dart';

class NetworkService extends DioForNative {
  NetworkService(
    Dio loggedDio,
    Dio tokenDio,
    SharedPrefs secureStorage,
  ) {
    interceptors.add(AuthInterceptor(
        loggedDio: loggedDio,
        tokenDio: tokenDio,
        secureStorage:
            secureStorage)); //NetworkInterceptor(secureStorage, this));
  }
}
