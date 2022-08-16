import 'package:omie_test/auth_repository.dart';
import 'package:omie_test/dioClient.dart';
import 'package:omie_test/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthController {
  late IAuthRepository repository;
  Future<dynamic> fazLogin(String email, String password, String? mfa);
  Future<bool> checaEmailExiste(String email);
  Future<bool> checaEmailSenha(String email, String senha);
  Future<void> doLogout();
  void addToken(String accessToken, String? refreshToken);
  Future<String?> retryToken();
  Future<bool> isValidToken();
  Future<dynamic> buscaDadosUsuario();
}

class AuthController implements IAuthController {
  @override
  late IAuthRepository repository;

  @override
  AuthController(this.repository);

  @override
  Future<bool> checaEmailExiste(String email) async {
    bool ret = false;
    final response = await repository.doLogin(email, '', '');
    if (!response.data['status']
        .toString()
        .toUpperCase()
        .contains('REQUIRED')) {
      ret = true;
    }
    return ret;
  }

  @override
  Future<dynamic> buscaDadosUsuario() async {
    var response = await repository.getUserData();
    return response.data;
  }

  @override
  Future<bool> checaEmailSenha(String email, String senha) async {
    bool ret = false;
    final response = await repository.doLogin(email, senha, '');
    if (!response.data['status'].toString().toUpperCase().contains('MFA')) {
      ret = true;
    }
    return ret;
  }

  @override
  Future<dynamic> fazLogin(String email, String password, String? mfa) async {
    final response = await repository.doLogin(email, password, mfa);

    if (response.data['status'].toString().toUpperCase().contains('OK')) {
      //await addToken(response.data['token'], response.data['refresh_token']);
      return response.data;
    }
    if (!response.data['status'].toString().toUpperCase().contains('OK')) {
      if (response.data['message'] != null) {
        return response.data['message'];
      } else {
        return response.data['status'];
      }
    }

    return '';
  }

  @override
  Future<void> doLogout() async {}

  @override
  Future<void> addToken(String accessToken, String? refToken) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('token', accessToken);
    if (refToken != null) {
      await sp.setString('refresh_token', refToken);
    }
    DioClientNew().refreshTokenDio(accessToken);
  }

  @override
  Future<String?> retryToken() async {
    final sp = await SharedPreferences.getInstance();
    var token = sp.getString('token');
    var refreshToken = sp.getString("refresh_token");
    if (token != null && refreshToken != null) {
      final response = await repository.retryTokenUser(token, refreshToken);
      String newToken = '';
      if (response.data['token'].toString().isNotEmpty) {
        newToken = response.data['token'];
        await addToken(newToken, response.data['refresh_token']);
      } else {
        return null;
      }
      return newToken;
    }
    return null;
  }

  @override
  Future<bool> isValidToken() async {
    final sp = await SharedPreferences.getInstance();
    var token = sp.getString("token");
    var refresh = sp.getString("refresh_token");
    if (token == null || token.isEmpty) {
      return false;
    }
    //O token é validado pelo dio_client que direciona para /auth caso inválido
    await addToken(token, refresh);
    return true;
  }
}
