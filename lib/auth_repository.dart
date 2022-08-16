import 'package:dio/dio.dart';
import 'package:omie_test/dioClient.dart';
import 'package:omie_test/simpleDio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthRepository {
  Future<Response> doLogin(String email, String password, String? mfa);
  Future<Response> retryTokenUser(String token, String refreshToken);
  Future<Response> getUserData();
  Future<Response> doLogout();
}

class AuthRepository implements IAuthRepository {
  @override
  Future<Response> doLogout() async {
    throw UnimplementedError();
  }

  @override
  Future<Response> doLogin(String email, String password, String? mfa) async {
    Map<String, String> dados = {"email": email};
    if (password.isNotEmpty) {
      dados.addAll({'password': password});
    }
    if (mfa != null && mfa.isNotEmpty) {
      dados.addAll({'mfa': mfa});
    }
    var response = await SimpleDio.getInstance().instance.post(
      //var login = await dioClient!.post(
      'login/jwt/',
      data: {'email': email, 'password': password, 'mfa': mfa},
    );
    if (response.data != null && response.data['token'] != null) {
      await addToken(response.data['token'], response.data['refresh_token']);
    }
    return response;
  }

  Future<void> addToken(String accessToken, String? refToken) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('token', accessToken);
    if (refToken != null) {
      await sp.setString('refresh_token', refToken);
    }

    SimpleDio.getInstance().instance.options.headers["Authorization"] =
        "Bearer " + accessToken;
  }

  @override
  Future<Response> retryTokenUser(String token, String refreshToken) async {
    Map<String, String> dados = {"token": token, "refresh_token": refreshToken};
    final response = await SimpleDio.getInstance().instance.post(
          //var login = await dioClient!.post(
          'api/portal/users/refresh-token/',
          data: dados,
        );
    return response;
  }

  @override
  Future<Response> getUserData() async {
    final Response response = await SimpleDio.getInstance().instance.get(
          //var ret = await dioClient!.get(
          'api/portal/users/me',
        );
    return response;
  }
}
