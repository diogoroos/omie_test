import 'package:omie_test/infra/empresa_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpresaController {
  EmpresaController(this.repository);
  final EmpresasRepository repository;

  Future<void> addToken(String token, String refreshToken) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString("token_app", token);
    sp.setString("refresh_token_app", refreshToken);
  }

  Future<String?> retryTokenCompany() async {
    final sp = await SharedPreferences.getInstance();

    var token = sp.getString('token_app');
    var refreshToken = sp.getString("refresh_token_app");
    if (token != null && refreshToken != null) {
      final response = await repository.retryTokenCompany(token, refreshToken);
      String newToken = '';
      if (response.data['token'].toString().isNotEmpty) {
        newToken = response.data['token'];
        addToken(newToken, response.data['refresh_token']);
      } else {
        print('erro retry Token');
        return null;
      }
      return newToken;
    }
    return null;
  }

  Future<void> setCompany() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString("lastcompany", 'asdasd');
    var response = await repository.getTokenCompany();
    addToken(response.data['token'], response.data['refresh_token']);
  }

  Future<String> loadCompanies() async {
    var response = await repository.getCompanies();
    return response.data;
  }
}
