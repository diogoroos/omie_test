import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkRefreshTokenInterceptor extends Interceptor {
  final SharedPreferences _secureStorage;

  NetworkRefreshTokenInterceptor(this._secureStorage);

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String? token = await _getToken(options);

    if (token != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    //await recordError(err);
    await _secureStorage.clear();
    if (await _isLoggedUser()) {
      //await Modular.to.popAndPushNamed('/login');
      return super.onError(err, handler);
    } else {
      return handler.next(err);
    }
  }

  Future<bool> _isLoggedUser() async {
    final token = await _secureStorage.getString('token');
    return token != null;
  }

  Future<String?> _getToken(RequestOptions options) async {
    final String? token;

    token = await _secureStorage.getString('token');

    return token;
  }
}
