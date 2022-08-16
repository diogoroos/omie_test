import 'dart:async';

import 'package:dio/dio.dart';
import 'package:omie_test/main.dart';
import 'package:omie_test/db/shared_prefs.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final Dio loggedDio; //for logged
  final Dio tokenDio;

  // final Dio tokenDio;
  final SharedPrefs secureStorage;

  AuthInterceptor({
    required this.loggedDio,
    required this.tokenDio,
    required this.secureStorage,
  });

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['authorization'] =
        "Bearer ${await secureStorage.getString('token')}";
    //return options;
    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioError error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401 ||
        error.response?.statusCode == 403) {
      //This retries the request if the token was updated later on
      final RequestOptions opt = error.response!.requestOptions;
      _lockDio();
      //check if retry count is 1 (retry count gives number of attempt for refresh token renewable
      // if (options.headers['Retry-Count'] == 1) {
      //   _unlockDio();
      //   // showFlutterToast(AppColors.secondaryColor(1), 'Unauthorized Access! Please login');
      //   secureStorage.removeData();
      //   //TODO: logout user here
      //   return error;
      // }
      //request for new refresh token
      String? tk = await secureStorage.getString('token');
      String? rk = await secureStorage.getString('refresh_token');
      Map<String, String> dados = {"token": tk!, "refresh_token": rk!};
      return await tokenDio
          .post('${MyHomePage.appFlavor}api/portal/users/refresh-token/',
              data: dados)
          .then((response) async {
        await secureStorage.putString('token',
            response.data['token']); //overwriting existing expired token
        await secureStorage.putString(
            'refresh_token',
            response.data[
                'refresh_token']); //overwriting existing expired refresh token
      }).whenComplete(() {
        _unlockDio();
      }).then((e) async {
        opt.headers['Retry-Count'] =
            1; //setting retry count to 1 to prevent further concurrent calls
        Options optGer = Options(
          contentType: opt.contentType,
          extra: opt.extra,
          followRedirects: opt.followRedirects,
          headers: opt.headers,
          method: opt.method,
          listFormat: opt.listFormat,
          maxRedirects: opt.maxRedirects,
          receiveTimeout: opt.receiveTimeout,
          requestEncoder: opt.requestEncoder,
          responseDecoder: opt.responseDecoder,
          responseType: opt.responseType,
          sendTimeout: opt.sendTimeout,
          validateStatus: opt.validateStatus,
        );
        return loggedDio.request(opt.path, options: optGer);
        //return handler.resolve(await _retry(error.response!.requestOptions));
      }).catchError((e) {
        // showFlutterToast(AppColors.secondaryColor(1), 'Unauthorized Access! Please login');
        secureStorage.clearToken();
        return handler
            .next(DioError(requestOptions: error.requestOptions, error: e));
      });
    } else {
      return error;
    }
  }

  // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   final String? token = await _getToken(requestOptions);

  //   requestOptions.headers['Authorization'] = 'Bearer $token';

  //   final options =
  //       Options(method: requestOptions.method, headers: requestOptions.headers);

  //   _network.unlock();

  //   return _network.request(requestOptions.path,
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options);
  // }

  void _lockDio() {
    loggedDio.lock();
    loggedDio.interceptors.responseLock.lock();
    loggedDio.interceptors.errorLock.lock();
  }

  void _unlockDio() {
    loggedDio.unlock();
    loggedDio.interceptors.responseLock.unlock();
    loggedDio.interceptors.errorLock.unlock();
  }
}
