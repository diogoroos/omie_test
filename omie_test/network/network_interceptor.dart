import 'package:dio/dio.dart';
import 'package:omie_test/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_service.dart';

class NetworkInterceptor extends Interceptor {
  final SharedPreferences _secureStorage;
  final NetworkService _network;

  NetworkInterceptor(this._secureStorage, this._network);

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

    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      _network.lock();

      try {
        await _refreshToken(err.response!.requestOptions);
        return handler.resolve(await _retry(err.response!.requestOptions));
      } on DioError catch (ex) {
        return handler.next(ex);
      } catch (ex) {
        return handler
            .next(DioError(requestOptions: err.requestOptions, error: ex));
      }
    }

    return handler.next(err);
  }

  Future _refreshToken(RequestOptions options) async {
    //final newNetwork = NetworkService(_secureStorage);

    if (await _isLoggedUser()) {
      //await Modular.get<IAuthController>().refreshToken();
    }
    //  else {
    //   await authorizationService.localAuth();
    // }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final String? token = await _getToken(requestOptions);

    requestOptions.headers['Authorization'] = 'Bearer $token';

    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);

    _network.unlock();

    return _network.request(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> _isLoggedUser() async {
    final token = await _secureStorage.getString('refresh_token');
    return token != null;
  }

  Future<String?> _getToken(RequestOptions options) async {
    final String? token;

    token = await _secureStorage.getString('token');

    return token;
  }
}
