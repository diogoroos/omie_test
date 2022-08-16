import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();

  static final SharedPrefs _singleton = SharedPrefs._();

  factory SharedPrefs() {
    return _singleton;
  }

  Future<SharedPreferences> _inst = SharedPreferences.getInstance();

  Future<void> clearToken() async {
    return _inst.then((SharedPreferences sp) {
      sp.remove('token');
      sp.remove('refresh_token');
    });
  }

  Future<String?> getString(String key, {String? val}) async {
    return _inst.then((SharedPreferences sp) {
      return sp.getString(key) ?? val;
    });
  }

  Future<dynamic> getObject(String key, dynamic val) async {
    return _inst.then((SharedPreferences sp) {
      var x = sp.getString(key);
      if (x != null) {
        return jsonDecode(x) as Map<String, dynamic>;
      }
      return null;
    });
  }

  putString(String key, String val) async {
    _inst.then((SharedPreferences sp) {
      sp.setString(key, val);
    });
  }

  Future<bool?> getBool(String key, {bool? defaultValue}) async {
    return _inst.then((SharedPreferences sp) {
      return sp.getBool(key) ?? defaultValue;
    });
  }

  Future<bool> putBool(String key, bool value) async {
    return _inst.then((SharedPreferences sp) {
      sp.setBool(key, value);
      return true;
    });
  }
}
