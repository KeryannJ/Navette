import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

class PreferenceHelper {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static SharedPreferences? _prefsInstance;

  static Future<void> init() async {
    _prefsInstance = await _instance;
    getAllPref();
  }

  static String navetteAPIKey = 'NAVETTE';
  static String bearerKey = 'BEARER';
  static String userIdKey = 'USERID';

  static String navetteApi = '';
  static String bearer = '';
  static int userId = -1;

  static void getAllPref() {
    bearer = isNullString(_prefsInstance!.getString(bearerKey));
    navetteApi = isNullString(_prefsInstance!.getString(navetteAPIKey));
    userId = isNullInt(_prefsInstance!.getInt(userIdKey), -1);
  }

  static bool isNullBool(bool? aBool) {
    if (aBool == null) {
      return false;
    } else {
      return aBool;
    }
  }

  static int isNullInt(int? aInt, int defaultValue) {
    if (aInt == null) {
      return defaultValue;
    } else {
      return aInt;
    }
  }

  static isNullString(String? aStr) {
    if (aStr == null) {
      return '';
    } else {
      return aStr;
    }
  }

  static void setBoolValue(String aStr, bool aBool) {
    saveKeyBool(aStr, aBool);
  }

  static void saveKeyBool(String aStr, bool aBool) {
    _prefsInstance!.setBool(aStr, aBool);
  }

  static void setIntValue(String aStr, int aInt) {
    saveKeyInt(aStr, aInt);
  }

  static void saveKeyInt(String aStr, int aInt) {
    _prefsInstance!.setInt(aStr, aInt);
  }

  static Future<void> setAPIValues(String navette, String bearer) async {
    await _prefsInstance!.setString(navetteAPIKey, navette);
    await _prefsInstance!.setString(bearerKey, bearer);
  }

  static void setUserId(int uid) {
    _prefsInstance!.setInt(userIdKey, uid);
  }
}
