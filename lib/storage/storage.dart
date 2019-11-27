import 'dart:async';
import 'dart:convert';
import 'package:film_fllix/api/models/auth/access.dart';
import 'package:film_fllix/api/models/auth/login_rsp.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Logger logger = new Logger("Storage");

  static Future<String> getToken() async {
    var prefs = await _getPrefs();
    var token = prefs.getString("token");
    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  static Future<bool> setCurrentAccess(Access access) async {
    var prefs = await _getPrefs();
    return prefs.setString("access", json.encode(access));
  }

  static Future<Access> getCurrentAccess() async {
    var prefs = await _getPrefs();
    if (prefs.getString("access") != null) {
      return new Access.fromJson(json.decode(prefs.getString("access")));
    } else {
      return null;
    }
  }

  static Future<String> getApiUrl() async {
    return "https://filmflix.herokuapp.com";
  }

  static Future<Null> setToken(String token) async {
    var prefs = await _getPrefs();
    prefs.setString("token", token);
    prefs.commit();
  }

  static Future<Null> deleteAll() async {
    var prefs = await _getPrefs();
    prefs.clear();
    prefs.commit();
  }

  static Future<Null> setLanguage(String locale) async {
    var prefs = await _getPrefs();
    prefs.setString("locale", locale);
    prefs.commit();
  }

  static Future<String> getLanguage() async {
    var prefs = await _getPrefs();
    return prefs.getString("locale");
  }

  static Future<DateTime> getDateTime(String key) async {
    var prefs = await _getPrefs();
    var value = prefs.get(key);
    return value != null ? DateTime.parse(value) : null;
  }

  static Future<void> setDateTime(String key, DateTime date) async {
    var prefs = await _getPrefs();
    prefs.setString(key, date.toIso8601String());
    return;
  }

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }
}
