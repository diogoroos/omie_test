import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:omie_test/auth_controller.dart';
import 'package:omie_test/auth_repository.dart';
import 'package:omie_test/company_repository.dart';
import 'package:omie_test/empresa_controller.dart';

abstract class IDioClient2 {
  void refreshTokenDio(String token);

  Future<dynamic> interceptRequests(Future<Response> request);
  Future<dynamic> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  });
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  });
}

class DioClient2 {
  Dio _dio = Dio();

  // static final DioClient _singleton = DioClient._internal();
  // factory DioClient() => _singleton;
  // DioClient._internal() {
  //   // private constructor that creates the singleton instance
  //   if (_dio.options.baseUrl == "") {
  //     configDio();
  //   }
  // }

  void dispose() {
    _dio.close();
  }

  String token = "";
  bool retried = false;

  // void init() {
  //   _dio = configDio();
  // }

  void refreshTokenDio(String token) {
    _dio.options.headers['Authorization'] = "Bearer " + token;
    print('---------\n' +
        token +
        '\n---------------\n-----------\n-------\n---------\n');
    // if (_dio.options.headers.containsKey('Authorization')) {
    //   _dio.options.headers.update('Authorization', (_) => "Bearer " + token);
    // } else {
    //   _dio.options.headers['Authorization'] = "Bearer " + token;

    //   //   _dio.options.headers.addAll({
    //   //     'Content-Type': 'application/json',
    //   //     'Authorization': 'Bearer ' + token,
    //   //   });
    // }
  }

  Future<dynamic> interceptRequests2(Future<Response> request) async {
    try {
      var x = await request.catchError((_e) {
        throw _e;
      });
      return x;
    } on Exception catch (e) {
      var message = '';
      switch (e.runtimeType) {
        case DioError:
          if ((e as DioError)
              .message
              .toLowerCase()
              .contains('failed host lookup')) {
            throw SocketException('Falha na comunicação.');
          }
          if ((e).response?.data != '') {
            if ((e).response?.data[0] != null) {
              message = (e).response?.data[0];
            }
            if ((e).response?.data.runtimeType == String) {
              message = (e).response?.data;
            }
            if ((e).response?.data.runtimeType == List) {
              message = (e).response?.data['message'] ?? message;
            }
          } else {
            message = (e).message;
          }
          message = message;
      }
    }
  }

  Dio configDio() {
    _dio.options.baseUrl = 'https://app.omie.com.br/';
    _dio.options.maxRedirects = 1000;
    _dio.options.connectTimeout = 10 * 1000;
    //_dio.interceptors.clear();
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      request: true,
      responseHeader: true,
      error: true,
    ));
    //_dio.interceptors.add(interpceptorToken(token));
    return _dio;
  }

  // Dio configDio2() {
  //   _dio.options.baseUrl = 'https://app.omie.com.br/';
  //   _dio.options.maxRedirects = 1000;
  //   _dio.options.connectTimeout = 10 * 1000;
  //   //_dio.interceptors.clear();
  //   _dio.interceptors.add(LogInterceptor(
  //     responseBody: true,
  //     requestBody: true,
  //     requestHeader: true,
  //     request: true,
  //     responseHeader: true,
  //     error: true,
  //   ));
  //   _dio.interceptors.add(InterceptorsWrapper(
  //     onRequest: (options, handler) {
  //       options.headers.addAll({
  //         'Content-Type': 'application/json',
  //         'Authorization': '',
  //       });
  //       return handler.next(options);
  //     },
  //     onResponse: (response, handler) {
  //       var msg = "";
  //       msg = response.data.runtimeType.toString().toLowerCase();
  //       if (msg == 'string') {
  //         msg = response.data.toString().toLowerCase();
  //       }
  //       if (msg == 'list<dynamic>' && response.data?[0]! != null) {
  //         msg = response.data[0].toString().toLowerCase();
  //       }
  //       if (msg.contains('<!doctype html>')) {
  //         return handler.reject(DioError(
  //             requestOptions: RequestOptions(path: ''),
  //             error: 'path not found',
  //             type: DioErrorType.cancel));
  //       }
  //       if (msg.contains('failed host lookup')) {
  //         return handler.reject(DioError(
  //             requestOptions: RequestOptions(path: ''),
  //             error: 'no internet',
  //             type: DioErrorType.connectTimeout));
  //       }
  //       if (msg.contains('invál') || msg.contains('inval')) {
  //         return handler.reject(DioError(
  //                 requestOptions: RequestOptions(path: ''),
  //                 error: 'invalid',
  //                 type: DioErrorType.cancel)
  //             // Response(
  //             //   statusCode: -1,
  //             //   data: {'message': 'Solicitação inválida'},
  //             //   requestOptions:
  //             //       RequestOptions(path: '', contentType: ContentType.json.value),
  //             // ),
  //             );
  //       } else {
  //         return handler.next(response);
  //       }
  //     },
  //     onError: (DioError error, handler) async {
  //       if (error.response != null && error.response!.data != null) {
  //         if (error.response!.data.runtimeType
  //             .toString()
  //             .toLowerCase()
  //             .contains('internallinkedhashmap')) {
  //           if ((error.response!.data as Map<String, dynamic>)
  //               .containsKey('faultstring')) {
  //             if ((error.response!.data as Map<String, dynamic>)
  //                 .values
  //                 .elementAt(0)
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains('não existem registros')) {
  //               return handler.resolve(Response(
  //                   requestOptions: RequestOptions(path: ''),
  //                   statusCode: 200,
  //                   data: {'message': 'Não há informações'}));
  //             }
  //           }
  //         }
  //       }

  //       if (error.type == DioErrorType.receiveTimeout ||
  //           error.type == DioErrorType.connectTimeout ||
  //           error.type == DioErrorType.sendTimeout) {
  //         return handler.next(DioError(
  //             requestOptions: RequestOptions(path: ''),
  //             error: 'timed out',
  //             type: DioErrorType.cancel));
  //       }
  //       if (error.response?.statusCode == 401 ||
  //           error.response?.statusCode == 403) {
  //         try {
  //           String? newToken = "";
  //           Dio _dioRetry = Dio();
  //           _dioRetry.interceptors.add(LogInterceptor(
  //             responseBody: true,
  //             requestBody: true,
  //             requestHeader: true,
  //             request: true,
  //             responseHeader: true,
  //             error: true,
  //           ));
  //           _dioRetry.options.baseUrl = 'https://app.omie.com.br/';
  //           _dioRetry.options.maxRedirects = 1000;
  //           _dioRetry.options.connectTimeout = 10 * 1000;
  //           if (error.requestOptions.path.contains('/apps/')) {
  //             newToken = await EmpresaController(CompaniesRepository())
  //                 .retryTokenCompany();
  //           } else {
  //             newToken = await AuthController(AuthRepository()).retryToken();
  //           }

  //           error.requestOptions.baseUrl = 'https://app.omie.com.br/';

  //           //error.requestOptions.headers.clear();
  //           //error.requestOptions.extra.clear();
  //           error.requestOptions.headers["Authorization"] =
  //               "Bearer " + newToken!;
  //           //refreshTokenDio(newToken);
  //           //create request with new access token
  //           final opts = new Options(
  //               method: error.requestOptions.method,
  //               headers: error.requestOptions.headers);
  //           final cloneReq = await _dioRetry.request(error.requestOptions.path,
  //               options: opts,
  //               data: error.requestOptions.data,
  //               queryParameters: error.requestOptions.queryParameters);

  //           return handler.resolve(cloneReq);
  //         } catch (e, st) {
  //           print('error on gain token');
  //         }
  //       }

  //       // else if ([401, 403].contains(error.response?.statusCode) ||
  //       //     error.message.toLowerCase().contains('unauthorized')) {
  //       //   if (!retried) {
  //       //     Response? result = await retry(error.requestOptions);
  //       //     if (result != null &&
  //       //         result.statusCode != null &&
  //       //         result.statusCode! <= 299) {
  //       //       var r = ResponseInterceptorHandler();
  //       //       r.resolve(Response(
  //       //           requestOptions: RequestOptions(path: ''),
  //       //           statusCode: 200,
  //       //           data: result.data));
  //       //       //return interceptorOnResponse(result, r);
  //       //     } else {
  //       //       Modular.to.popAndPushNamed('/auth');
  //       //       return handler.reject(error);
  //       //     }
  //       //   } else {
  //       //     error.error = '''Não autorizado. Contate o suporte.''';
  //       //     Modular.to.popAndPushNamed('/auth');
  //       //     return handler.reject(error);
  //       //   }
  //       // }
  //       else if (error.message == 'invalid') {
  //         error.type = DioErrorType.cancel;
  //         error.error = '''Solicitação inválida. Tente novamente mais tarde.''';
  //         return handler.next(error);
  //       } else {
  //         return handler.next(error);
  //       }
  //     },
  //   ));
  //   return _dio;
  // }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (path.contains('http')) {
      _dio.options.baseUrl = path;
    }
    //var x = await interceptRequests(
    return await _dio
        .get(path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress)
        .catchError((onError) {
      throw onError;
    });
    //return x;
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    //return await interceptRequests(
    return await _dio
        .patch(path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress)
        .catchError((onError) {
      throw onError;
    });
    //   ,
    // );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    //return await interceptRequests(
    return await _dio
        .put(path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress)
        .catchError((onError) {
      throw onError;
    });
    //   ,
    // );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    //return await interceptRequests(
    //var x = await interceptRequests(
    return await _dio
        .post(path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress)
        .catchError((onError) {
      throw onError;
    });
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    //return await interceptRequests(
    return await _dio
        .delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    )
        .catchError((onError) {
      throw onError;
    });
    //   ,
    // );
  }
}

// InterceptorsWrapper interpceptorToken(String token) {
//   return InterceptorsWrapper(onRequest: (options, handler) async {
//     options.headers['Authorization'] = 'Bearer  $token';
//     return handler.next(options);
//   }, onError: (DioError error, handler) async {
//     return handler.next(error);
//   });
// }
