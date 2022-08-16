// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omie_test/infra/auth_controller.dart';
import 'package:omie_test/infra/auth_repository.dart';
import 'package:omie_test/infra/empresa_repository.dart';
import 'package:omie_test/infra/empresa_controller.dart';
import 'package:omie_test/db/shared_prefs.dart';
import 'package:omie_test/net/simple_dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  static String appFlavor = "https://appdsv.omie.com.br/";
  static String email = "diogo.melo@omie.com.br";
  //static String senha = "753dRm12@";
  static String senha = "TesteApple123";

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController tec = TextEditingController();

  Future<void> _incrementCounter() async {
    await getHttp();
    print('-------------------------------');
    print('-------------------------------');
    //await ac.fazLogin('diogo.melo@omie.com.br', '753dRm12@', tec.text);

    SimpleDio.getInstance().instance.options.baseUrl = MyHomePage.appFlavor;

    AuthRepository ar = AuthRepository();
    AuthController ac = AuthController(ar);
    print('MFA: ${tec.text}');
    var retTok =
        await ac.fazLogin(MyHomePage.email, MyHomePage.senha, tec.text);
    print('\nToken: $retTok');

    if (retTok != null && (retTok is Map) && retTok['status'] == 'OK') {
      var retMe = await ac.buscaDadosUsuario();
      print('\nMe: $retMe');

      EmpresasRepository cr = EmpresasRepository();
      EmpresaController ec = EmpresaController(cr);
      try {
        var retApps = await ec.loadCompanies();
        print('\nApps: $retApps');
      } catch (e) {
        print(e);
      }
    } else {
      print('-x-x-x-x-x-x-x-x-x-x-x-x-x-');
      print(retTok.toString());
    }
  }

  Future<void> getHttp() async {
    const ua =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1";

    var request = Dio();

    try {
      var tok = await SimpleDio.getInstance().instance.post(
        '${MyHomePage.appFlavor}login/jwt/',
        data: {
          'email': MyHomePage.email,
          'password': MyHomePage.senha,
          'mfa': tec.text
        },
      );

      print('\nToken:');
      print(tok.data['token']);
      await SharedPrefs().putString('token', tok.data['token']);
      await SharedPrefs().putString('refresh_token', tok.data['refresh_token']);

      request.options.headers["Authorization"] = "Bearer ${tok.data['token']}";
      request.options.baseUrl = MyHomePage.appFlavor;

      var me = await SimpleDio.getInstance()
          .instance
          .get('${MyHomePage.appFlavor}api/portal/users/me');

      print('\nME:');
      print(me);

      var myApps = await SimpleDio.getInstance()
          .instance
          .get('${MyHomePage.appFlavor}api/portal/apps?app_type=OMIE');

      print("\n myApps");
      print(myApps);

      var tokenBraziline = await SimpleDio.getInstance().instance.get(
          '${MyHomePage.appFlavor}api/portal/apps/${myApps.data['appHash']}/token/');

      print("\n tokenEmp");
      print(tokenBraziline);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'MFA',
            ),
            TextField(controller: tec),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _incrementCounter();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
