import 'package:dio/dio.dart';
import 'package:omie_test/dioClient.dart';
import 'package:omie_test/dio_client.dart';

class BaseRepository {
  DioClientNew? dioClient = DioClientNew();

  // void init() {
  //   if (dioClient == null) {
  //     dioClient = DioClientNew();
  //     //dioClient!.init();
  //   }
  // }
  void init() {}

  Future<Response> post(String url,
      {dynamic data, dynamic queryParameters}) async {
    init();
    return await dioClient!.post(url, data: data);
  }

  Future<Response> put(String url,
      {dynamic data, dynamic queryParameters}) async {
    init();
    return await dioClient!.put(url, data: data);
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? data}) async {
    init();

    var ret = await dioClient!
        .get(url, queryParameters: data ?? Map<String, dynamic>());
    return ret;
  }

  // Future<Response> patch(String url, {dynamic data}) async {
  //   init();

  //   return await dioClient!.patch(url, data: data);
  // }

  Future<Response> delete(String url) async {
    init();

    return await dioClient!.delete(url);
  }
}
