import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;
  static const _sysToken = 'accessToken';
  static const _refreshToken = 'refreshToken';

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  static void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

//sysToken login
  static Future<bool>? setAccessToken(String value) =>
      _sharedPreferences?.setString(_sysToken, value);

  static String? getAccessToken() => _sharedPreferences?.getString(_sysToken);

//refresh Token login
  static Future<bool>? setRefreshToken(String value) =>
      _sharedPreferences?.setString(_refreshToken, value);

  static String? getRefreshToken() =>
      _sharedPreferences?.getString(_refreshToken);

  static int? getInt(String key) => _sharedPreferences?.getInt(key);

  static Future<bool>? setInt(String key, int value) =>
      _sharedPreferences?.setInt(key, value);

  static Future<bool>? removeInt(String key) =>
      _sharedPreferences?.remove(key);

  static String? getString(String key) => _sharedPreferences?.getString(key);

  static Future<bool>? setString(String key, String value) =>
      _sharedPreferences?.setString(key, value);

  static Future<bool>? removeString(String key) =>
      _sharedPreferences?.remove(key);

  static bool? getBool(String key) => _sharedPreferences?.getBool(key);

  static Future<bool>? setBool(String key, bool value) =>
      _sharedPreferences?.setBool(key, value);

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }
}
