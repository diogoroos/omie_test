import 'package:dio/dio.dart';
import 'package:omie_test/dioClient.dart';
import 'package:omie_test/simpleDio.dart';

abstract class IEmpresaRepository {
  Future<Response> getCompanies();
  Future<Response> getTokenCompany();
  Future<Response> retryTokenCompany(String token, String refreshToken);
}

class CompaniesRepository implements IEmpresaRepository {
  @override
  Future<Response> getCompanies() async {
    final Response response = await SimpleDio.getInstance().instance.get(
          //var ret = await dioClient!.get(
          'api/portal/apps',
        );
    return response;
  }

  @override
  Future<Response> getTokenCompany() async {
    final Response response = await SimpleDio.getInstance().instance.get(
          //return await dioClient!.get(
          'api/portal/apps/omie/token',
        );
    return response;
  }

  @override
  Future<Response> retryTokenCompany(String token, String refreshToken) async {
    Map<String, String> dados = {"token": token, "refresh_token": refreshToken};
    var response = await SimpleDio.getInstance().instance.post(
          //var login = await dioClient!.post(
          'api/portal/apps/asdasd/refresh-token/',
          data: dados,
        );
    return response;
  }
}
