import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveBool(String key, bool value) async => await _prefs.setBool(key, value);
  static bool getBool(String key, {bool def = false}) => _prefs.getBool(key) ?? def;

  static Future<void> saveString(String key, String value) async => await _prefs.setString(key, value);
  static String getString(String key, {String def = ''}) => _prefs.getString(key) ?? def;
}